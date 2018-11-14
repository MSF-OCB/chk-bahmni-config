select
drugName AS 'Nom',
quantityOfDrug AS 'Qté Totale disp.',
unitOfDrug AS 'Unité',
identifier.identifier AS 'ID Patient',
cv.concept_full_name AS 'Type Cohorte',
DATE_FORMAT(dateDispensed, '%d/%m/%Y \n %I:%i %p') AS 'Date dispensation',
vt.name AS 'Type de visite',
Case when a = 1 then 'Nouvelle'  when a > 1 then 'Renouvellement' else null end As 'Type de prescription',
concat(ifnull(dispensedBy.family_name,''),' ',ifnull(dispensedBy.middle_name,''),' ', ifnull(dispensedBy.given_name,'')) AS 'Dispensé par'
From
(/*Fetching patient drug related information*/
        Select
        count(1) as a,
        gettingOrderDetails.patient_id,
        gettingOrderDetails.name as 'drugName',
        gettingOrderDetails.dateActivated,
        gettingOrderDetails.unit AS 'unitOfDrug',
        gettingOrderDetails.quantity AS 'quantityOfDrug',
        dispensedCreator,
        innerEncounter,
        dateDispensed
        from
        orders
        INNER JOIN drug_order on drug_order.order_id = orders.order_id AND orders.order_type_id = 2
        INNER JOIN drug on drug_order.drug_inventory_id = drug.drug_id
        INNER JOIN obs o on orders.order_id = o.order_id and o.concept_id = 128
        INNER JOIN
                 (/*filtering patient who have same drugs ordered */
                    Select
                    orders.date_activated as 'dateActivated',
                    orders.patient_id,
                    drug.name,
                    drug_order.quantity,
                    cvForUnit.concept_full_name AS 'unit',
                    o.obs_datetime as 'dateDispensed',
                    o.creator AS "dispensedCreator",
                    o.encounter_id AS "innerEncounter"
                    from
                    orders
                    INNER JOIN drug_order on drug_order.order_id = orders.order_id AND orders.order_type_id = 2
                    INNER JOIN drug on drug_order.drug_inventory_id = drug.drug_id
                    INNER JOIN obs o on orders.order_id = o.order_id and o.concept_id = 128
                    INNER JOIN concept_view cvForUnit on drug_order.quantity_units = cvForUnit.concept_id
                 ) AS gettingOrderDetails ON gettingOrderDetails.patient_id = orders.patient_id
                 AND gettingOrderDetails.name = drug.name AND orders.date_activated <= gettingOrderDetails.dateActivated
                 /*Comparing patient current drug ordered date with previous order date*/
        Group by orders.patient_id,drugName,gettingOrderDetails.dateActivated
) AS drugOrderDetails
INNER JOIN encounter_provider ep on ep.encounter_id = drugOrderDetails.innerEncounter
INNER JOIN provider p on p.provider_id = ep.provider_id
INNER JOIN person_name dispensedBy on dispensedBy.person_id = p.person_id
INNER JOIN patient_identifier identifier ON identifier.patient_id = drugOrderDetails.patient_id
INNER JOIN person_attribute valuesOfattribute  ON identifier.patient_id = valuesOfattribute.person_id
INNER JOIN person_attribute_type cohortType ON cohortType.person_attribute_type_id = valuesOfattribute.person_attribute_type_id and cohortType.name = 'Type de cohorte'
INNER JOIN concept_view cv ON valuesOfattribute.value = cv.concept_id
INNER JOIN encounter e ON drugOrderDetails.innerEncounter= e.encounter_id
INNER JOIN visit v on e.visit_id = v.visit_id
INNER JOIN visit_type vt on v.visit_type_id = vt.visit_type_id
WHERE DATE(drugOrderDetails.dateDispensed) BETWEEN DATE('#startDate#') and DATE('#endDate#')
and identifier.voided = 0
and valuesOfattribute.voided = 0
and cohortType.retired = 0
and e.voided = 0
and ep.voided = 0
and v.voided = 0
and vt.retired = 0
and p.retired = 0
order by dateDispensed,dateActivated,identifier.identifier;
