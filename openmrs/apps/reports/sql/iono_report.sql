SELECT result_date      AS "Date des résultats",
       provenance       as "Provenance",
       nom              AS "Nom du patient",
       id               AS "Id Patient",
       date_naissance   AS "Date naissance",
       date_prelevement AS "Date de prelevement",
       sexe             as "Sexe",
       k                as "K",
       na               as "Na",
       cl               as "Cl",
       gamma            AS "Gamma GT(GGT)",
       pal              AS "Phosphatase alchaline(Pal)",
       bt               AS "Billi Total(BT)",
       bd               AS "Billi direct(BD)",
       calcium          AS "Calcium (Ca)"
FROM (SELECT to_char(B.date_of_results, 'DD/MM/YYYY')                                        AS "result_date",
             B.care_center_requesting                                                        AS "provenance",
             B.Patient_Name                                                                  AS "nom",
             B.Patient_Identifier                                                            AS "id",
             to_char(b.dob, 'DD/MM/YYYY')                                                    AS "date_naissance",
             to_char(B.sample_date, 'DD/MM/YYYY')                                            AS "date_prelevement",
             B.sexe                                                                          AS "sexe",
             sum(CAST(CASE WHEN B.Potassium = '' THEN NULL ELSE B.Potassium END AS NUMERIC)) AS "k",
             sum(CAST(CASE WHEN B.sod = '' THEN NULL ELSE B.sod END AS NUMERIC))             AS "na",
             sum(CAST(CASE WHEN B.chlore = '' THEN NULL ELSE B.chlore END AS NUMERIC))       AS "cl",
             sum(CAST(CASE WHEN B.gamma = '' THEN NULL ELSE B.gamma END AS NUMERIC))         AS "gamma",
             sum(CAST(CASE WHEN B.phosphate_alca = '' THEN NULL ELSE B.phosphate_alca END AS
                      NUMERIC))                                                              AS "pal",
             sum(CAST(CASE WHEN B.bilitotalE = '' THEN NULL ELSE B.bilitotalE END AS
                      NUMERIC))                                                              AS "bt",
             sum(CAST(CASE WHEN B.bildirect = '' THEN NULL ELSE B.bildirect END AS
                      NUMERIC))                                                              AS "bd",
             sum(CAST(CASE WHEN B.calc = '' THEN NULL ELSE B.calc END AS NUMERIC))           AS "calcium"
      FROM (/*Pivoting the table row to column*/
           SELECT Patient_Name,
                  care_center_requesting,
                  Patient_Identifier,
                  sample_date,
                  dob,
                  sexe,
                  date_of_results,
                  month_of_results,
                  COMMENT,
                  CASE
                    WHEN tname = 'potassium' THEN tvalue
                      END AS Potassium,
                  CASE
                    WHEN tname = 'sodium' THEN tvalue
                      END AS sod,
                  CASE
                    WHEN tname = 'Chlore' THEN tvalue
                      END AS chlore,
                  CASE
                    WHEN tname = 'Gamma GT' THEN tvalue
                      END AS gamma,
                  CASE
                    WHEN tname = 'Phosphatase alcaline' THEN tvalue
                      END AS phosphate_alca,
                  CASE
                    WHEN tname = 'Bilirubine totalE' THEN tvalue
                      END AS bilitotalE,
                  CASE
                    WHEN tname = 'Bilirubine directE' THEN tvalue
                      END AS bildirect,
                  CASE
                    WHEN tname = 'Calcium' THEN tvalue
                      END AS calc


           FROM (/*Pivoting the table row to column*/
                SELECT sample.collection_date                                                                                                        AS sample_date,
                       ss.name                                                                                                                       AS care_center_requesting,
                       TRIM(concat(
                              COALESCE(NULLIF(person.first_name, ''), ''),
                              ' ',
                              COALESCE(NULLIF(person.last_name, ''), '')))                                                                           AS Patient_Name,
                       pi.identity_data                                                                                                              AS Patient_Identifier,
                       patient.birth_date ::DATE AS dob,
                       CASE
                         WHEN patient.gender = 'M'
                                 THEN 'H'
                         WHEN patient.gender = 'F'
                                 THEN 'F'
                         WHEN patient.gender = 'O'
                                 THEN 'A'
                         ELSE patient.gender END                                                                                                     AS sexe,
                       t.name                                                                                                                        AS tname,
                       r.value                                                                                                                       AS tvalue,
                       TRIM(concat(COALESCE(NULLIF(d.dict_entry, ''), ''), ' '))                                                                     AS dvalue,
                       r.lastupdated ::DATE AS date_of_results,
                       to_char(
                         to_timestamp(date_part('month', r.lastupdated) :: TEXT, 'MM'),
                         'Month')                                                                                                                    AS month_of_results,
                       a.comment
                FROM patient_identity pi
                       INNER JOIN patient ON patient.id = pi.patient_id
                       INNER JOIN person ON patient.person_id = person.id
                       INNER JOIN sample_human ON patient.id = sample_human.patient_id
                       INNER JOIN sample sample ON sample_human.samp_id = sample.id
                       INNER JOIN sample_source ss ON sample.sample_source_id = ss.id
                       INNER JOIN sample_item item ON sample.id = item.samp_id
                       INNER JOIN analysis a ON item.id = a.sampitem_id
                       INNER JOIN RESULT r ON a.id = r.analysis_id
                       INNER JOIN test t ON a.test_id = t.id AND
                                            t.name IN ('potassium',
                                                       'sodium',
                                                       'Chlore',
                                                       'Phosphatase alcaline',
                                                       'Bilirubine totalE',
                                                       'Bilirubine directE',
                                                       'Calcium',
                                                       'Gamma GT')
                       LEFT JOIN DICTIONARY d ON r.result_type = 'D' AND CAST(d.id AS TEXT) = r.value
                WHERE a.status_id = 6 /*Filtering the result which are validated*/
                  AND sample.accession_number IS NOT NULL
                  AND pi.identity_type_id = 2) AS A) AS B
      WHERE date(B.date_of_results) BETWEEN '#startDate#' AND '#endDate#'
      GROUP BY B.Patient_Name,
               B.sample_date,
               B.care_center_requesting,
               B.Patient_Identifier,
               B.dob,
               B.sexe,
               B.date_of_results,
               B.month_of_results
      ORDER BY B.date_of_results,
               B.care_center_requesting,
               B.Patient_Name,
               B.dob,
               B.sexe) AS A
WHERE COALESCE("k", "na", "cl", "gamma", "pal", "bt", "bd",
               "calcium") IS NOT NULL;
