SELECT provenance          AS "Provenance",
       nom                 AS "Nom du patient",
       id                  AS "ID Patient",
       age                 AS "Age",
       date_naissance      AS "Date naissance",
       sexe                AS "Sexe",
       date_de_prélèvement AS "Date de prélèvement",
       results_cd4         AS "RESULTS CD4 (cells/µl)",
       cd4                    "CD4 %",
       sgpt                AS "SGPT (UI/L)",
       creat               AS "CREAT (µmol/L)",
       glycorachie         AS "Glycorachie",
       hepb                AS "Hep. B",
       crag                AS "CRAG SERIQUE",
       crag_lcr            AS "CRAG LCR",
       notes               AS "Notes"
FROM (SELECT B.care_center_requesting                                            AS            "provenance",
             B.Patient_Name                                                      AS            "nom",
             B.Patient_Identifier                                                AS            "id",
             EXTRACT(YEAR FROM Now()) - EXTRACT(YEAR FROM B.dob)                 AS            "age",
             to_char(B.dob, 'DD/MM/YYYY')                                        AS            "date_naissance",
             B.sexe                                                              AS            "sexe",
             to_char(B.sample_date, 'DD/MM/YYYY')                                AS            "date_de_prélèvement",
             sum(CAST(CASE WHEN B.CD4 = '' THEN NULL ELSE B.CD4 END AS NUMERIC)) AS            "results_cd4",
             sum(CAST(CASE WHEN B.CD4_percentage = '' THEN NULL ELSE B.CD4_percentage END AS
                      NUMERIC))                                                  AS            "cd4",
             sum(CAST(CASE WHEN B.GPT = '' THEN NULL ELSE B.GPT END AS NUMERIC)) AS            "sgpt",
             sum(CAST(CASE WHEN B.Creatinine = '' THEN NULL ELSE B.Creatinine END AS
                      NUMERIC))                                                  AS            "creat",
             sum(CAST(CASE WHEN B.Glucose_LCR = '' THEN NULL ELSE B.Glucose_LCR END AS
                      NUMERIC))                                                  AS            "glycorachie",
             (SELECT dict_entry
              FROM DICTIONARY
              WHERE id IN
                    (sum(CAST(CASE WHEN B.Hep_B = '' THEN NULL ELSE B.Hep_B END AS NUMERIC)))) "hepb",
             /*getting coded value for tests*/
             (SELECT dict_entry
              FROM DICTIONARY
              WHERE id IN (sum(CAST(CASE WHEN B.Crag_serique = '' THEN NULL ELSE B.Crag_serique END AS
                                    NUMERIC))))AS                                              "crag",
             /*getting coded value for tests*/
             (SELECT dict_entry
              FROM DICTIONARY
              WHERE id IN (sum(CAST(CASE WHEN B.Crag_LCR = '' THEN NULL ELSE B.Crag_LCR END AS
                                    NUMERIC))))                                  AS            "crag_lcr",
             /*getting coded value for tests*/

             CASE
               WHEN visit_type = 'OPD' AND priority = 1 THEN 'OPD HIGH'
               WHEN visit_type = 'IPD' AND priority = 1 THEN 'IPD HIGH'
               WHEN visit_type = 'OPD' AND priority = 0 THEN 'OPD'
               WHEN visit_type = 'IPD' AND priority = 0 THEN 'IPD'
               WHEN visit_type = 'IPD'AND priority = NULL THEN 'IPD'
               WHEN visit_type = 'OPD' AND priority = NULL THEN 'OPD'
                 END                                                             AS            "notes"

      FROM (/*Pivoting the table row to column*/
           SELECT accession_number,
                  date_of_results,
                  Patient_Name,
                  care_center_requesting,
                  Patient_Identifier,
                  dob,
                  sexe,
                  sample_date,
                  Motif,
                  CASE
                    WHEN tname = 'CD4' THEN tvalue
                      END AS CD4,
                  CASE
                    WHEN tname = 'CD4 % (enfants de - 5 ans)' THEN tvalue
                      END AS CD4_percentage,
                  CASE
                    WHEN tname = 'GPT' THEN tvalue
                      END AS GPT,
                  CASE
                    WHEN tname = 'Creatinine' THEN tvalue
                      END AS Creatinine,
                  CASE
                    WHEN tname = 'Glycorachie' THEN tvalue
                      END AS Glucose_LCR,
                  CASE
                    WHEN tname = 'Hépatite B' THEN tvalue
                      END AS Hep_B,
                  CASE
                    WHEN tname = 'Crag serique' THEN tvalue
                      END AS Crag_serique,
                  CASE
                    WHEN tname = 'Crag' THEN tvalue
                      END AS Crag_LCR,
                  priority,
                  visit_type

           FROM (/*defining columns*/
                SELECT sample.lastupdated                                       AS date_of_results,
                       ss.name                                                  AS care_center_requesting,
                       TRIM(concat(COALESCE(NULLIF(person.first_name, ''), ''), ' ',
                                   COALESCE(NULLIF(person.last_name, ''), ''))) AS Patient_Name,
                       pi.identity_data                                         AS Patient_Identifier,
                       patient.birth_date                                       AS dob,
                       CASE
                         WHEN patient.gender = 'M' THEN 'H'
                         WHEN patient.gender = 'F' THEN 'F'
                         WHEN patient.gender = 'O' THEN 'A'
                         ELSE patient.gender END                                AS sexe,
                       sample.collection_date                                   AS "sample_date",
                       t.name                                                   AS tname,
                       r.value                                                  AS tvalue,
                       sample.accession_number,
                       sample.priority,
                       sample.visit_type,
                       a.comment                                                AS Motif
                FROM patient_identity pi
                       INNER JOIN patient ON patient.id = pi.patient_id
                       INNER JOIN person ON patient.person_id = person.id
                       INNER JOIN sample_human ON patient.id = sample_human.patient_id
                       INNER JOIN sample sample ON sample_human.samp_id = sample.id
                       INNER JOIN sample_source ss ON sample.sample_source_id = ss.id
                       INNER JOIN sample_item item ON sample.id = item.samp_id
                       INNER JOIN analysis a ON item.id = a.sampitem_id
                       INNER JOIN RESULT r ON a.id = r.analysis_id
                       INNER JOIN test t ON a.test_id = t.id
                WHERE t.name IN ('CD4',
                                 'CD4 % (enfants de - 5 ans)',
                                 'GPT',
                                 'Creatinine',
                                 'Glycorachie',
                                 'Hépatite B',
                                 'Crag serique',
                                 'Crag')
                  AND a.status_id = 6 /*Filtering the result which are validated*/
                  AND sample.accession_number IS NOT NULL
                  AND pi.identity_type_id = 2) AS A) AS B
      WHERE date(B.date_of_results) BETWEEN '#startDate#' AND '#endDate#'

      GROUP BY B.Patient_Name,
               B.care_center_requesting,
               B.Patient_Identifier,
               B.dob,
               B.sexe,
               B.sample_date,
               B.date_of_results,
               B.accession_number,
               B.priority,
               B.visit_type,
               B.Motif


      ORDER BY B.date_of_results,
               B.care_center_requesting,
               B.Patient_Name,
               B.dob,
               B.sexe) AS A
WHERE COALESCE("results_cd4", "cd4", "sgpt", "creat", "glycorachie") IS NOT NULL
   OR COALESCE("crag_lcr", "hepb", "crag") IS NOT NULL;
