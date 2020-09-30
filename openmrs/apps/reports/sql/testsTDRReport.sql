SELECT identifier                                                                       AS "ID",
       concept_full_name                                                                AS "Type cohorte",
       TDRReport.NameOfPerson                                                           AS "Nom",
       TDRReport.personAge                                                              AS "Age",
       TDRReport.dateOfBirth                                                            AS "Date de naissance",
       TDRReport.gender                                                                 AS "Sexe",
       dateTypeTheCohorte                                                               AS "Date entrée cohorte",
       dateResults                                                                      AS "Date résultats",
       typeOfVisit                                                                      AS "Type de visite",
       sum(Labtest1768)                                                                 AS "Hémoglobine (Hemocue)(g/dl)",
       (SELECT concept_full_name FROM concept_view WHERE concept_id = sum(Labtest1773)) AS "TDR - Malaria",
       sum(Labtest1769)                                                                 AS "Glycémie(mg/dl)",
       sum(Labtest1771)                                                                 AS "CD4 % (Enfants de moins de 5 ans)(%)",
       sum(Labtest1770)                                                                 AS "CD4(cells/µl)",
       (SELECT concept_full_name FROM concept_view WHERE concept_id = sum(Labtest1772)) AS "TB - LAM"

FROM (SELECT obsLabTest.obs_datetime,
             obsLabTest.person_id,
             pi.identifier,
             cv.concept_full_name,
             DATE_FORMAT(obsLabTest.obs_datetime, '%d/%m/%Y %H:%i:%S')              AS "dateResults",
             vtype.name                                                             AS "typeOfVisit",
             concat(COALESCE(NULLIF(pnPersonAttribute.given_name, ''), ''), ' ',
                    COALESCE(NULLIF(pnPersonAttribute.family_name, ''), ''))        AS "NameOfPerson",
             concat(floor(datediff(now(), person.birthdate) / 365), ' ans, ',
                    floor((datediff(now(), person.birthdate) % 365) / 30), ' mois') AS "personAge",
             date_format(person.birthdate, '%d/%m/%Y')                              AS "dateOfBirth",
             CASE
               WHEN person.gender = 'M' THEN 'H'
               WHEN person.gender = 'F' THEN 'F'
               WHEN person.gender = 'O' THEN 'A'
               ELSE person.gender END                                               AS "gender",
             date_format(pa.date_created, '%d/%m/%Y')                               AS "dateTypeTheCohorte",
             CASE
               WHEN obsLabTest.concept_id = (SELECT concept_id
                                             FROM concept_view
                                             WHERE concept_full_name = "CD4 % (Enfants de moins de 5 ans)(%)")
                       THEN obsLabTest.value_numeric END                            AS 'Labtest1771',
             CASE
               WHEN obsLabTest.concept_id =
                    (SELECT concept_id FROM concept_view WHERE concept_full_name = "CD4(cells/µl)")
                       THEN obsLabTest.value_numeric END                            AS 'Labtest1770',
             CASE
               WHEN obsLabTest.concept_id =
                    (SELECT concept_id FROM concept_view WHERE concept_full_name = "Glycémie(mg/dl)")
                       THEN obsLabTest.value_numeric END                            AS 'Labtest1769',
             CASE
               WHEN obsLabTest.concept_id =
                    (SELECT concept_id FROM concept_view WHERE concept_full_name = "Hémoglobine (Hemocue)(g/dl)")
                       THEN obsLabTest.value_numeric END                            AS 'Labtest1768',
             CASE
               WHEN obsLabTest.concept_id =
                    (SELECT concept_id FROM concept_view WHERE concept_full_name = "TR, TDR - Malaria")
                       THEN obsLabTest.value_coded END                              AS 'Labtest1773',
             CASE
               WHEN obsLabTest.concept_id = (SELECT concept_id FROM concept_view WHERE concept_full_name = "TB - LAM")
                       THEN obsLabTest.value_coded END                              AS 'Labtest1772'
      FROM obs obsLabTest
             INNER JOIN patient_identifier pi ON obsLabTest.person_id = pi.patient_id
             INNER JOIN person_attribute pa ON obsLabTest.person_id = pa.person_id
             INNER JOIN person_attribute_type pat
               ON pa.person_attribute_type_id = pat.person_attribute_type_id AND pat.name = "Type de cohorte" AND
                  pat.retired = 0
             INNER JOIN concept_view cv ON cv.concept_id = pa.value
             INNER JOIN person ON person.person_id = obsLabTest.person_id
             INNER JOIN person_name pnPersonAttribute ON person.person_id = pnPersonAttribute.person_id
			 INNER JOIN encounter e ON e.encounter_id = obsLabTest.encounter_id AND e.voided = 0
			 INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided = 0 
			 INNER JOIN visit_type vtype ON v.visit_type_id = vtype.visit_type_id

      WHERE obsLabTest.voided = 0
        AND DATE(obsLabTest.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
        AND obsLabTest.concept_id IN (SELECT concept_id
                                      FROM concept_name
                                      WHERE `name` IN ("CD4 % (Enfants de moins de 5 ans)(%)",
                                                       "CD4(cells/µl)",
                                                       "Glycémie(mg/dl)",
                                                       "Hémoglobine (Hemocue)(g/dl)",
                                                       "TR, TDR - Malaria",
                                                       "TB - LAM")
                                        AND locale_preferred = 1
                                        AND voided = 0
                                        AND concept_name_type = "FULLY_SPECIFIED")
      GROUP BY dateResults, Labtest1771, Labtest1770, Labtest1769, Labtest1768, Labtest1773, Labtest1772) AS TDRReport

GROUP BY person_id, obs_datetime, dateResults
ORDER BY obs_datetime
