SELECT
  identifier AS "ID",
  concept_full_name AS "Type cohorte",
  TDRReport.NameOfPerson AS "Nom",
  TDRReport.personAge AS "Age",
  TDRReport.dateOfBirth as "Date de naissance",
  TDRReport.gender AS "Sexe",
  dateTypeTheCohorte AS "Date entrée cohorte",
  obs_datetime AS "Date résultats",
  typeOfVisit AS "Type de visite",
  sum(Labtest1768) AS "Hémoglobine (Hemocue)(g/dl)",
  (SELECT concept_full_name FROM concept_view WHERE concept_id = sum(Labtest549)) AS "TDR - Malaria",
  sum(Labtest1769) AS "Glycémie(mg/dl)",
  sum(Labtest1771) AS "CD4 % (Enfants de moins de 5 ans)(%)",
  sum(Labtest1770) AS "CD4(cells/µl)",
  (SELECT concept_full_name FROM concept_view WHERE concept_id = sum(Labtest1772)) AS "TB - LAM"

FROM
      (
      SELECT
      pi.identifier,
      cv.concept_full_name,
      obsLabResults.person_id,
      obsLabResults.obs_datetime,
      vtype.name AS "typeOfVisit",
      concat( COALESCE(NULLIF(pnPersonAttribute.given_name, ''), ''), ' ', COALESCE(NULLIF(pnPersonAttribute.family_name, ''), '') ) AS "NameOfPerson",
      TIMESTAMPDIFF(YEAR, person.birthdate, CURDATE()) AS "personAge",
      person.birthdate AS "dateOfBirth",
      CASE WHEN person.gender = 'M' THEN 'H'
           WHEN person.gender = 'F' THEN 'F'
           WHEN person.gender = 'O' THEN 'A'
           else person.gender END AS "gender",
      pa.date_created AS "dateTypeTheCohorte",
      CASE WHEN obsLabTest.value_coded = (
                                          SELECT concept_id
                                          FROM concept_view
                                          WHERE concept_full_name = "CD4 % (Enfants de moins de 5 ans)(%)"
                                          )
                                          THEN obsLabResults.value_numeric  END AS 'Labtest1771',
      CASE WHEN obsLabTest.value_coded = (
                                          SELECT concept_id
                                          FROM concept_view
                                          WHERE concept_full_name = "CD4(cells/µl)"
                                          )
                                          THEN obsLabResults.value_numeric  END AS 'Labtest1770',
      CASE WHEN obsLabTest.value_coded = (
                                          SELECT concept_id
                                          FROM concept_view
                                          WHERE concept_full_name = "Glycémie(mg/dl)"
                                          )
                                          THEN obsLabResults.value_numeric  END AS 'Labtest1769',
      CASE WHEN obsLabTest.value_coded = (
                                          SELECT concept_id
                                          FROM concept_view
                                          WHERE concept_full_name = "TB - LAM"
                                          ) THEN obsLabResults.value_coded  END AS 'Labtest1772',
      CASE WHEN obsLabTest.value_coded = (
                                          SELECT concept_id
                                          FROM concept_view
                                          WHERE concept_full_name = "Hémoglobine (Hemocue)(g/dl)"
                                          )
                                          THEN obsLabResults.value_numeric  END AS 'Labtest1768',
      CASE WHEN obsLabTest.value_coded = (
                                          SELECT concept_id
                                          FROM concept_view
                                          WHERE concept_full_name = "TR, TDR - Malaria"
                                          ) THEN obsLabResults.value_coded  END AS 'Labtest549'
      FROM obs obsLabTest
      INNER JOIN obs obsLabResults ON obsLabResults.obs_group_id = obsLabTest.obs_group_id
      AND obsLabResults.person_id = obsLabTest.person_id
      AND obsLabTest.obs_id != obsLabResults.obs_id
      INNER JOIN patient_identifier pi ON obsLabTest.person_id = pi.patient_id
      INNER JOIN person_attribute pa ON obsLabTest.person_id = pa.person_id
      INNER JOIN person_attribute_type pat ON pa.person_attribute_type_id = pat.person_attribute_type_id AND pat.name = "Type de cohorte" AND pat.retired = 0
      INNER JOIN concept_view cv ON cv.concept_id = pa.value
      INNER JOIN person ON person.person_id = obsLabTest.person_id
      INNER JOIN person_name pnPersonAttribute ON person.person_id = pnPersonAttribute.person_id
      INNER JOIN visit v ON v.patient_id = person.person_id AND v.voided = 0
      INNER JOIN visit_type vtype ON v.visit_type_id = vtype.visit_type_id

      WHERE obsLabTest.concept_id = (
                                     SELECT concept_id
                                     FROM concept_view
                                     WHERE concept_full_name = "Tests"
                                    )
      AND obsLabTest.value_coded IN
                                  (SELECT concept_id
                                  FROM concept_view
                                  WHERE concept_full_name IN
                                                            ("CD4 % (Enfants de moins de 5 ans)(%)",
                                                            "CD4(cells/µl)","Glycémie(mg/dl)",
                                                            "Hémoglobine (Hemocue)(g/dl)",
                                                            "TB - LAM",
                                                            "TR, TDR - Malaria")
                                                            )
      AND obsLabResults.voided = 0
      AND obsLabTest.voided = 0
      AND DATE(obsLabResults.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
) AS TDRReport
GROUP BY person_id,obs_datetime
ORDER BY "Date résultats"
