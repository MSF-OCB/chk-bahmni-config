SELECT
      pi.identifier AS "ID",
      cv.concept_full_name AS "Type cohorte",
      concat( COALESCE(NULLIF(pnPersonAttribute.given_name, ''), ''), ' ', COALESCE(NULLIF(pnPersonAttribute.family_name, ''), '') ) AS "Nom",
      TIMESTAMPDIFF(YEAR, personAttribute.birthdate, CURDATE()) AS "Age",
      personAttribute.birthdate AS "Date de naissance",
      CASE WHEN personAttribute.gender = 'M' THEN 'H'
           WHEN personAttribute.gender = 'F' THEN 'F'
           WHEN personAttribute.gender = 'O' THEN 'A'
           ELSE personAttribute.gender END AS "Sexe",
      vtype.name AS "Type de visite",
      CASE WHEN DATE(personAttribute.date_created) = DATE(v.date_started)  THEN  "New Visit" ELSE NULL END AS "Nouvelle visite",
      concat( COALESCE(NULLIF(pnForConsultant.given_name, ''), ''), ' ', COALESCE(NULLIF(pnForConsultant.family_name, ''), '') ) AS "Consultant",
      obsForGettingAppDate.value_datetime AS "Date de rendez-vous",
      v.date_started AS "Date debut visite",
      v.date_stopped AS "Date fin visite"
FROM
      person personAttribute
      INNER JOIN patient_identifier pi ON personAttribute.person_id = pi.patient_id
      INNER JOIN person_name pnPersonAttribute ON pi.patient_id = pnPersonAttribute.person_id
      INNER JOIN person_attribute pa ON personAttribute.person_id = pa.person_id
      INNER JOIN person_attribute_type pat ON pa.person_attribute_type_id = pat.person_attribute_type_id AND pat.name = "Type de cohorte" AND pat.retired = 0
      INNER JOIN concept_view cv ON cv.concept_id = pa.value
      INNER JOIN visit v ON v.patient_id = personAttribute.person_id AND v.voided = 0
      INNER JOIN visit_type vtype ON v.visit_type_id = vtype.visit_type_id
      INNER JOIN obs obsForConsultant ON obsForConsultant.person_id = personAttribute.person_id
      INNER JOIN users usersForConsultant ON usersForConsultant.user_id = obsForConsultant.creator
      INNER JOIN person_name pnForConsultant ON pnForConsultant.person_id = usersForConsultant.person_id
      /*for getting Appoinment date of previous visit*/
      INNER JOIN obs obsForGettingAppDate ON obsForGettingAppDate.person_id = personAttribute.person_id
      INNER JOIN visit visitForGettingAppDate ON visitForGettingAppDate.patient_id = obsForGettingAppDate.person_id
WHERE obsForGettingAppDate.concept_id IN (
                                        SELECT concept_id
                                        from concept_view
                                        where concept_full_name IN ("Date du prochain RDV","Date de prochain RDV")
                                        AND retired = 0
                                        )
      AND  v.date_started > (
                            SELECT max(obs_datetime)
                            from obs obsForGettingValueDate
                            where obsForGettingValueDate.person_id = obsForGettingAppDate.person_id
                            AND obsForGettingValueDate.concept_id IN (
                                                    SELECT concept_id
                                                    from concept_view
                                                    where concept_full_name IN ("Date du prochain RDV","Date de prochain RDV")
                                                    AND retired = 0
                                                  )
                            AND obsForGettingValueDate.obs_datetime < v.date_started
                            )
      AND DATE(v.date_started) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
GROUP BY Consultant,ID
ORDER BY "Date debut visite";
