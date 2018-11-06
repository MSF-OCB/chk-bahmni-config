SELECT identifier,
       group_concat(DISTINCT (CASE
                                WHEN personAttributeTypeDetails.name = "Type de cohorte"
                                        THEN cvForAttribute.concept_full_name
                                ELSE NULL END))                                         AS "Type cohorte",
       concat(COALESCE(NULLIF(personalDetails.given_name, ''), ''), ' ',
              COALESCE(NULLIF(personalDetails.family_name, ''), ''))                    AS "Nom",
       concat(floor(datediff(now(), personForDetails.birthdate) / 365), ' ans, ',
              floor((datediff(now(), personForDetails.birthdate) % 365) / 30), ' mois') AS "Age",
       date_format(personForDetails.birthdate, '%d/%m/%Y')                              AS "Date de naissance",
       CASE
         WHEN personForDetails.gender = 'M' THEN 'H'
         WHEN personForDetails.gender = 'F' THEN 'F'
         WHEN personForDetails.gender = 'O' THEN 'A'
         ELSE personForDetails.gender END                                               AS "Sexe",
       group_concat(DISTINCT (CASE
                                WHEN personAttributeTypeDetails.name = "Date entrée cohorte"
                                        THEN date_format(DATE(personAttributeDetails.value), '%d/%m/%Y')
                                ELSE NULL END))                                         AS "Date entrée cohorte",
       DATE_FORMAT(DATE(lostToFollowUpPatients.appointmentDate), '%d/%m/%Y')            AS "Date de RDV",
       CASE
         WHEN MAX(timestampdiff(DAY, DATE(lostToFollowUpPatients.appointmentDate), '#endDate#')) BETWEEN 4 AND 90
                 THEN "Présumé perdu de vue"
         WHEN MAX(timestampdiff(DAY, DATE(lostToFollowUpPatients.appointmentDate), '#endDate#')) > 90 THEN "Perdu de vu"
         ELSE NULL END                                                                  AS "Type de pérdu de vue",
       group_concat(DISTINCT (CASE
                                WHEN personAttributeTypeDetails.name = "Tel 1" THEN personAttributeDetails.value
                                ELSE NULL END))                                         AS "Telephone",
       personAddressDetails.address6                                                    AS "Commune",
       personAddressDetails.address4                                                    AS "Quartier",
       personAddressDetails.address3                                                    AS "Rue",
       personAddressDetails.address2                                                    AS "No",
       personAddressDetails.address5                                                    AS "Indicateur de localisation",
       group_concat(DISTINCT (CASE
                                WHEN personAttributeTypeDetails.name = "Nom du contact"
                                        THEN personAttributeDetails.value
                                ELSE NULL END))                                         AS "Nom Contact",
       group_concat(DISTINCT (CASE
                                WHEN personAttributeTypeDetails.name = "Tel 1 du Contact"
                                        THEN personAttributeDetails.value
                                ELSE NULL END))                                         AS "Téléphone contact",
       group_concat(DISTINCT (CASE
                                WHEN personAttributeTypeDetails.name = "Nom du Confident 1"
                                        THEN personAttributeDetails.value
                                ELSE NULL END))                                         AS "Nom confident 1",
       group_concat(DISTINCT (CASE
                                WHEN personAttributeTypeDetails.name = "Tel Conf 1" THEN personAttributeDetails.value
                                ELSE NULL END))                                         AS "Téléphone confident 1",
       group_concat(DISTINCT (CASE
                                WHEN personAttributeTypeDetails.name = "Nom du Confident 2"
                                        THEN personAttributeDetails.value
                                ELSE NULL END))                                         AS "Nom confident 2",
       group_concat(DISTINCT (CASE
                                WHEN personAttributeTypeDetails.name = "Tel Conf 2" THEN personAttributeDetails.value
                                ELSE NULL END))                                         AS "Téléphone confident 2",
       CASE
         WHEN personForDetails.dead = 0 THEN "Non"
         WHEN personForDetails.dead = 1 THEN "Oui"
         ELSE NULL END                                                                  AS "Est décédé?",
       DATE_FORMAT(DATE(personForDetails.death_date), '%d/%m/%Y')                       AS "Date de décés",
       cvForGettingDeathReason.concept_full_name                                        AS "Raison de décés"
FROM (SELECT person_id,
             obs_id,
             max(obsForAppointmentDate.obs_datetime)   AS "obsDate",
             max(obsForAppointmentDate.value_datetime) AS "appointmentDate",
             max(visitForAppointmentDate.date_started) AS "visitDate"
      FROM obs obsForAppointmentDate
             INNER JOIN visit visitForAppointmentDate
               ON visitForAppointmentDate.patient_id = obsForAppointmentDate.person_id
      WHERE obsForAppointmentDate.concept_id IN (SELECT concept_id
                                                 FROM concept_view
                                                 WHERE concept_full_name
                                                         IN ("Date du prochain RDV", "Date de prochain RDV"))
        AND obsForAppointmentDate.voided = 0
        AND visitForAppointmentDate.voided = 0
        AND obs_id NOT IN (SELECT obs_id
                           FROM obs obsForAppointmentDate
                                  INNER JOIN visit visitForAppointmentDate
                                    ON visitForAppointmentDate.patient_id = obsForAppointmentDate.person_id
                           WHERE obsForAppointmentDate.concept_id IN (SELECT concept_id
                                                                      FROM concept_view
                                                                      WHERE concept_full_name
                                                                              IN ("Date du prochain RDV",
                                                                                  "Date de prochain RDV"))
                             AND obsForAppointmentDate.voided = 0
                             AND visitForAppointmentDate.voided = 0
                             AND ( /*1. To remove patient with visit present between appointment date and report end date
                                    2. To remove patients with appt date greater than report end date*/
                                     date(visitForAppointmentDate.date_started) BETWEEN date(obsForAppointmentDate.value_datetime) AND Date('#endDate#')
                                       OR date(obsForAppointmentDate.value_datetime) > DATE('#endDate#')

                                     ))

      GROUP BY obsForAppointmentDate.person_id) AS lostToFollowUpPatients
       INNER JOIN person personForDetails ON lostToFollowUpPatients.person_id = personForDetails.person_id
       LEFT JOIN concept_view cvForGettingDeathReason
         ON personForDetails.cause_of_death = cvForGettingDeathReason.concept_id
       INNER JOIN patient_identifier identifier
         ON lostToFollowUpPatients.person_id = identifier.patient_id AND identifier.voided = 0
       INNER JOIN person_name personalDetails ON lostToFollowUpPatients.person_id = personalDetails.person_id
       LEFT JOIN person_address personAddressDetails
         ON personAddressDetails.person_id = lostToFollowUpPatients.person_id
       LEFT JOIN person_attribute personAttributeDetails
         ON lostToFollowUpPatients.person_id = personAttributeDetails.person_id AND personAttributeDetails.voided = 0
       INNER JOIN person_attribute_type personAttributeTypeDetails
         ON personAttributeDetails.person_attribute_type_id = personAttributeTypeDetails.person_attribute_type_id
       LEFT JOIN concept_view cvForAttribute ON personAttributeDetails.value = cvForAttribute.concept_id

WHERE DATE_ADD(DATE(lostToFollowUpPatients.appointmentDate), INTERVAL 3 DAY) <
      DATE('#endDate#') /* Condition 1 & 2 To remove the patient if appt date + 3 days is less than reporting end date. (Not considered as lost to followup patients.)*/
GROUP BY lostToFollowUpPatients.person_id;
