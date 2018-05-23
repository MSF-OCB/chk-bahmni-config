select
identifier,
group_concat( distinct ( case when personAttributeTypeDetails.name="Type de cohorte" then cvForAttribute.concept_full_name else NULL end )) as "Type cohorte",
concat( COALESCE(NULLIF(personalDetails.given_name, ''), ''), ' ', COALESCE(NULLIF(personalDetails.family_name, ''), '') ) AS "Nom",
concat(floor(datediff(now(), personForDetails.birthdate)/365), ' ans, ',  floor((datediff(now(), personForDetails.birthdate)%365)/30),' mois') AS "Age",
date_format(personForDetails.birthdate, '%d-%m-%Y') AS "Date de naissance",
CASE WHEN personForDetails.gender = 'M' THEN 'H'
     WHEN personForDetails.gender = 'F' THEN 'F'
     WHEN personForDetails.gender = 'O' THEN 'A'
     else personForDetails.gender END AS "Sexe",

group_concat( distinct ( case when personAttributeTypeDetails.name="Date entrée cohorte"
                              then date_format(DATE(personAttributeDetails.value), '%d-%m-%Y')
                              else NULL end )) as "Date entrée cohorte",
DATE_FORMAT(DATE(A.valueDate),'%d-%m-%Y') AS "Date de RDV",
CASE WHEN MAX(timestampdiff(DAY,DATE(A.valueDate),'#endDate#')) BETWEEN 7 AND 90 THEN "Présumé perdu de vue"
     WHEN MAX(timestampdiff(DAY,DATE(A.valueDate),'#endDate#')) > 90 THEN "Perdu de vu"
     ELSE NULL END AS "Type de pérdu de vue",
group_concat( distinct ( case when personAttributeTypeDetails.name="Tel 1" then personAttributeDetails.value else NULL end )) as "Telephone",
personAddressDetails.address6 AS "Commune",
personAddressDetails.address4 AS "Quartier",
personAddressDetails.address3 AS "Rue",
personAddressDetails.address2 AS "No",
personAddressDetails.address5 AS "Indicateur de localisation",
group_concat( distinct ( case when personAttributeTypeDetails.name="Nom du contact" then personAttributeDetails.value else NULL end )) as "Nom Contact",
group_concat( distinct ( case when personAttributeTypeDetails.name="Tel 1 du Contact" then personAttributeDetails.value else NULL end )) as "Téléphone contact",
group_concat( distinct ( case when personAttributeTypeDetails.name="Nom du Confident 1" then personAttributeDetails.value else NULL end )) as "Nom confident 1",
group_concat( distinct ( case when personAttributeTypeDetails.name="Tel Conf 1" then personAttributeDetails.value else NULL end )) as "Téléphone confident 1",
group_concat( distinct ( case when personAttributeTypeDetails.name="Nom du Confident 2" then personAttributeDetails.value else NULL end )) as "Nom confident 2",
group_concat( distinct ( case when personAttributeTypeDetails.name="Tel Conf 2" then personAttributeDetails.value else NULL end )) as "Téléphone confident 2",
CASE when personForDetails.dead = 0 then "Non"
     When personForDetails.dead = 1 Then "Oui"
     ELSE NULL END AS "Est décédé?",
DATE_FORMAT(DATE(personForDetails.death_date),'%d-%m-%Y') AS "Date de décés",
cvForGettingDeathReason.concept_full_name AS "Raison de décés"

from
(select
person_id,
max(obsForAppointmentDate.obs_datetime) AS "obsDate",
max(obsForAppointmentDate.value_datetime) as "valueDate",
max(visitForAppointmentDate.date_started) AS "dateStarted"
from obs obsForAppointmentDate
INNER JOIN visit visitForAppointmentDate on visitForAppointmentDate.patient_id = obsForAppointmentDate.person_id
where obsForAppointmentDate.concept_id in (
                                              select concept_id
                                              from concept_view
                                              where concept_full_name
                                                                    in (
                                                                        "Date du prochain RDV",
                                                                        "Date de prochain RDV"
                                                                       )
                                           )
AND obsForAppointmentDate.voided = 0
AND visitForAppointmentDate.voided = 0
group by obsForAppointmentDate.person_id
)
as A
INNER JOIN person personForDetails on A.person_id = personForDetails.person_id
left JOIN concept_view cvForGettingDeathReason on personForDetails.cause_of_death = cvForGettingDeathReason.concept_id
INNER JOIN patient_identifier identifier on A.person_id = identifier.patient_id AND identifier.voided = 0
INNER JOIN person_name personalDetails ON A.person_id  = personalDetails.person_id
left JOIN person_address personAddressDetails on personAddressDetails.person_id = A.person_id
LEFT JOIN person_attribute personAttributeDetails on  A.person_id = personAttributeDetails.person_id AND personAttributeDetails.voided = 0
LEFT JOIN person_attribute_type personAttributeTypeDetails ON  personAttributeDetails.person_attribute_type_id = personAttributeTypeDetails.person_attribute_type_id
LEFT JOIN concept_view cvForAttribute on personAttributeDetails.value = cvForAttribute.concept_id

where
DATE(A.valueDate) between ('#startDate#')  AND ('#endDate#')
AND DATE(A.valueDate) > DATE(A.datestarted)
AND DATE(A.valueDate) < curdate()
AND datediff('#endDate#',A.valueDate) >= 7

GROUP BY A.person_id
