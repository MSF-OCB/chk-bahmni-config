Select
identifier,
group_concat( distinct ( case when personAttributeTypeDetails.name="Type de cohorte" then cvForAttribute.concept_full_name else NULL end )) as "Type cohorte",
concat( COALESCE(NULLIF(personalDetails.given_name, ''), ''), ' ', COALESCE(NULLIF(personalDetails.family_name, ''), '') ) AS "Nom",
concat(floor(datediff(now(), personForDetails.birthdate)/365), ' ans, ',  floor((datediff(now(), personForDetails.birthdate)%365)/30),' mois') AS "Age",
date_format(personForDetails.birthdate, '%d/%m/%Y') AS "Date de naissance",
CASE WHEN personForDetails.gender = 'M' THEN 'H'
     WHEN personForDetails.gender = 'F' THEN 'F'
     WHEN personForDetails.gender = 'O' THEN 'A'
     else personForDetails.gender END AS "Sexe",
group_concat( distinct ( case when personAttributeTypeDetails.name="Date entrée cohorte"
                              then date_format(DATE(personAttributeDetails.value), '%d/%m/%Y')
                              else NULL end )) as "Date entrée cohorte",
DATE_FORMAT(DATE(lostToFollowUpPatients.appointmentDate),'%d/%m/%Y') AS "Date de RDV",
CASE WHEN MAX(timestampdiff(DAY,DATE(lostToFollowUpPatients.appointmentDate),'#endDate#')) BETWEEN 4 AND 90 THEN "Présumé perdu de vue"
     WHEN MAX(timestampdiff(DAY,DATE(lostToFollowUpPatients.appointmentDate),'#endDate#')) > 90 THEN "Perdu de vu"
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
DATE_FORMAT(DATE(personForDetails.death_date),'%d/%m/%Y') AS "Date de décés",
cvForGettingDeathReason.concept_full_name AS "Raison de décés"
from (
        select
        person_id,
        obs_id,
        max(obsForAppointmentDate.obs_datetime) AS "obsDate",
        max(obsForAppointmentDate.value_datetime) as "appointmentDate",
        max(visitForAppointmentDate.date_started) AS "visitDate"
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

        And obs_id not in (
                                select

                                obs_id
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
                                AND
                                ( /*1. To remove patient with visit present between appointment date and report end date
                                    2. To remove patients with appt date greater than report end date*/
                                    date(visitForAppointmentDate.date_started) between date(obsForAppointmentDate.value_datetime) and Date('#endDate#')
                                    OR date(obsForAppointmentDate.value_datetime) > DATE('#endDate#')

                                )

                            )

group by obsForAppointmentDate.person_id
) as lostToFollowUpPatients
INNER JOIN person personForDetails on lostToFollowUpPatients.person_id = personForDetails.person_id
left JOIN concept_view cvForGettingDeathReason on personForDetails.cause_of_death = cvForGettingDeathReason.concept_id
INNER JOIN patient_identifier identifier on lostToFollowUpPatients.person_id = identifier.patient_id AND identifier.voided = 0
INNER JOIN person_name personalDetails ON lostToFollowUpPatients.person_id  = personalDetails.person_id
LEFT JOIN person_address personAddressDetails on personAddressDetails.person_id = lostToFollowUpPatients.person_id
LEFT JOIN person_attribute personAttributeDetails on  lostToFollowUpPatients.person_id = personAttributeDetails.person_id AND personAttributeDetails.voided = 0
INNER JOIN person_attribute_type personAttributeTypeDetails ON  personAttributeDetails.person_attribute_type_id = personAttributeTypeDetails.person_attribute_type_id
LEFT JOIN concept_view cvForAttribute on personAttributeDetails.value = cvForAttribute.concept_id

Where DATE_ADD(DATE(lostToFollowUpPatients.appointmentDate), INTERVAL 3 DAY) < DATE('#endDate#') /* Condition 1 & 2 To remove the patient if appt date + 3 days is less than reporting end date. (Not considered as lost to followup patients.)*/
GROUP BY lostToFollowUpPatients.person_id;
