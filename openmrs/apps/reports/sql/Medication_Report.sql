SELECT
drugName AS 'Nom',
quantityOfDrug AS 'Qté Totale disp.',
unitOfDrug AS 'Unité',
identifier.identifier AS 'ID Patient',
cv.concept_full_name AS 'Type Cohorte',
DATE_FORMAT(dateActivated, '%d/%m/%Y \n %I:%i %p') AS 'Date prescription',
DATE_FORMAT(dateDispensed, '%d/%m/%Y \n %I:%i %p') AS 'Date dispensation',
vt.name AS 'Type de visite',
CASE WHEN a = 1 THEN 'Nouvelle'  WHEN a > 1 THEN 'Renouvellement' ELSE NULL END AS 'Type de prescription',
CONCAT(IFNULL(dispensedBy.family_name,''),' ',IFNULL(dispensedBy.middle_name,''),' ', IFNULL(dispensedBy.given_name,'')) AS 'Dispensé par'
FROM
(/*Fetching patient drug related information*/
        SELECT
        COUNT(1) AS a,
        gettingOrderDetails.patient_id,
        gettingOrderDetails.name AS 'drugName',
        gettingOrderDetails.dateActivated,
        gettingOrderDetails.unit AS 'unitOfDrug',
        gettingOrderDetails.quantity AS 'quantityOfDrug',
        dispensedCreator,
        innerEncounter,
        dateDispensed
        FROM
        orders
        INNER JOIN drug_order ON drug_order.order_id = orders.order_id AND orders.order_type_id = 2
        INNER JOIN drug ON drug_order.drug_inventory_id = drug.drug_id
        INNER JOIN obs o ON orders.order_id = o.order_id AND o.concept_id = 128
        INNER JOIN
                 (/*filtering patient who have same drugs ordered */
                    SELECT
                    orders.date_activated AS 'dateActivated',
                    orders.patient_id,
                    drug.name,
                    drug_order.quantity,
                    cvForUnit.concept_full_name AS 'unit',
                    o.obs_datetime AS 'dateDispensed',
                    o.creator AS "dispensedCreator",
                    o.encounter_id AS "innerEncounter"
                    FROM
                    orders
                    INNER JOIN drug_order ON drug_order.order_id = orders.order_id AND orders.order_type_id = 2
                    INNER JOIN drug ON drug_order.drug_inventory_id = drug.drug_id
                    INNER JOIN obs o ON orders.order_id = o.order_id AND o.concept_id = 128
                    INNER JOIN concept_view cvForUnit ON drug_order.quantity_units = cvForUnit.concept_id
                 ) AS gettingOrderDetails ON gettingOrderDetails.patient_id = orders.patient_id
                 AND gettingOrderDetails.name = drug.name AND orders.date_activated <= gettingOrderDetails.dateActivated
                 /*Comparing patient current drug ordered date with previous order date*/
        GROUP BY orders.patient_id,drugName,gettingOrderDetails.dateActivated
) AS drugOrderDetails
INNER JOIN encounter_provider ep ON ep.encounter_id = drugOrderDetails.innerEncounter
INNER JOIN provider p ON p.provider_id = ep.provider_id
INNER JOIN person_name dispensedBy ON dispensedBy.person_id = p.person_id
INNER JOIN patient_identifier identifier ON identifier.patient_id = drugOrderDetails.patient_id
INNER JOIN person_attribute valuesOfattribute  ON identifier.patient_id = valuesOfattribute.person_id
INNER JOIN person_attribute_type cohortType ON cohortType.person_attribute_type_id = valuesOfattribute.person_attribute_type_id AND cohortType.name = 'Type de cohorte'
INNER JOIN concept_view cv ON valuesOfattribute.value = cv.concept_id
INNER JOIN encounter e ON drugOrderDetails.innerEncounter= e.encounter_id
INNER JOIN visit v ON e.visit_id = v.visit_id
INNER JOIN visit_type vt ON v.visit_type_id = vt.visit_type_id
WHERE DATE(drugOrderDetails.dateDispensed) BETWEEN DATE('#startDate#') and DATE('#endDate#')
AND identifier.voided = 0
AND valuesOfattribute.voided = 0
AND cohortType.retired = 0
AND e.voided = 0
AND ep.voided = 0
AND v.voided = 0
AND vt.retired = 0
AND p.retired = 0
ORDER BY dateDispensed,dateActivated,identifier.identifier;
