SELECT result_date      AS "Date des résultats",
       Provenance,
       Nom              AS "Nom du patient",
       Id               AS "Id Patient",
       date_naissance   AS "Date naissance",
       date_prelevement AS "Date de prelevement",
       Sexe,
       eid              AS "EID/PCR",
       crachat          AS "Genexpert Crachat",
       urine            AS "Genexpert Urine",
       lcr              AS "Genexpert LCR",
       pleural          AS "Genexpert Pleural",
       ascite              "Genexpert Ascite",
       pus              AS "Genexpert Pus",
       ganlionnaire     AS "Genexpert Ganglionnaire",
       synovial         AS "Genexpert Synovial",
       gastrique        AS "Genexpert Gastrique"
FROM (SELECT to_char(B.date_of_results, 'DD/MM/YYYY')                                                                    AS "result_date",
             B.care_center_requesting                                                                                    AS "Provenance",
             B.Patient_Name                                                                                              AS "Nom",
             B.Patient_Identifier                                                                                        AS "Id",
             to_char(b.dob, 'DD/MM/YYYY')                                                                                AS "date_naissance",
             to_char(B.sample_date, 'DD/MM/YYYY')                                                                        AS "date_prelevement",
             B.sexe                                                                                                      AS "Sexe",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) =
                    sum(CAST(CASE WHEN B.EID = '' THEN NULL ELSE B.EID END AS NUMERIC)))                                 AS "eid",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.GenCrachat = '' THEN NULL ELSE B.GenCrachat END AS
                                                     NUMERIC)))                                                          AS "crachat",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(
                                              CAST(CASE WHEN B.GenUrine = '' THEN NULL ELSE B.GenUrine END AS NUMERIC))) AS "urine",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(
                                              CAST(CASE WHEN B.GenLcr = '' THEN NULL ELSE B.GenLcr END AS NUMERIC)))     AS "lCR",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.GenPleural = '' THEN NULL ELSE B.GenPleural END AS
                                                     NUMERIC)))                                                          AS "pleural",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.GenAscite = '' THEN NULL ELSE B.GenAscite END AS
                                                     NUMERIC)))                                                          AS "ascite",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(
                                              CAST(CASE WHEN B.GenPus = '' THEN NULL ELSE B.GenPus END AS NUMERIC)))     AS "pus",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.GenGangilio = '' THEN NULL ELSE B.GenGangilio END AS
                                                     NUMERIC)))                                                          AS "ganglionnaire",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.GenSynovial = '' THEN NULL ELSE B.GenSynovial END AS
                                                     NUMERIC)))                                                          AS "synovial",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.GenGastrique = '' THEN NULL ELSE B.GenGastrique END AS
                                                     NUMERIC)))                                                          AS "gastrique"

      FROM (/*Pivoting the table row to column*/ SELECT Patient_Name,
                                                        care_center_requesting,
                                                        Patient_Identifier,
                                                        sample_date,
                                                        dob,
                                                        sexe,
                                                        date_of_results,
                                                        month_of_results,
                                                        COMMENT,
                                                        CASE
                                                          WHEN tname = 'Genexpert (Crachat)' THEN tvalue
                                                            END AS GenCrachat,
                                                        CASE
                                                          WHEN tname = 'Genexpert (Urine)' THEN tvalue
                                                            END AS GenUrine,
                                                        CASE
                                                          WHEN tname = 'Genexpert (LCR)' THEN tvalue
                                                            END AS GenLcr,
                                                        CASE
                                                          WHEN tname = 'Genexpert (Pleural)' THEN tvalue
                                                            END AS GenPleural,
                                                        CASE
                                                          WHEN tname = 'Genexpert (Ascite)' THEN tvalue
                                                            END AS GenAscite,
                                                        CASE
                                                          WHEN tname = 'Genexpert (Pus)' THEN tvalue
                                                            END AS GenPus,
                                                        CASE
                                                          WHEN tname = 'Genexpert (Ganglionnaire)' THEN tvalue
                                                            END AS GenGangilio,
                                                        CASE
                                                          WHEN tname = 'Genexpert (Gastrique)' THEN tvalue
                                                            END AS GenGastrique,
                                                        CASE
                                                          WHEN tname = 'EID (PCR)' THEN tvalue
                                                            END AS EID,
                                                        CASE
                                                          WHEN tname = 'Genexpert (Synovial)' THEN tvalue
                                                            END AS GenSynovial
                                                 FROM (/*Pivoting the table row to column*/ SELECT sample.collection_date                              AS sample_date,
                                                                                                   ss.name                                             AS care_center_requesting,
                                                                                                   TRIM(concat(
                                                                                                          COALESCE(NULLIF(person.first_name, ''), ''),
                                                                                                          ' ',
                                                                                                          COALESCE(NULLIF(person.last_name, ''), ''))) AS Patient_Name,
                                                                                                   pi.identity_data                                    AS Patient_Identifier,
                                                                                                   patient.birth_date ::DATE AS dob,
                                                                                                   CASE
                                                                                                     WHEN patient.gender = 'M'
                                                                                                             THEN 'H'
                                                                                                     WHEN patient.gender = 'F'
                                                                                                             THEN 'F'
                                                                                                     WHEN patient.gender = 'O'
                                                                                                             THEN 'A'
                                                                                                     ELSE patient.gender END                           AS sexe,
                                                                                                   t.name                                              AS tname,
                                                                                                   r.value                                             AS tvalue,
                                                                                                   r.lastupdated ::DATE AS date_of_results,
                                                                                                   to_char(
                                                                                                     to_timestamp(date_part('month', r.lastupdated) :: TEXT, 'MM'),
                                                                                                     'Month')                                          AS month_of_results,
                                                                                                   a.comment
                                                                                            FROM patient_identity pi
                                                                                                   INNER JOIN patient
                                                                                                     ON patient.id = pi.patient_id
                                                                                                   INNER JOIN person
                                                                                                     ON patient.person_id = person.id
                                                                                                   INNER JOIN sample_human
                                                                                                     ON patient.id = sample_human.patient_id
                                                                                                   INNER JOIN sample sample
                                                                                                     ON sample_human.samp_id = sample.id
                                                                                                   INNER JOIN sample_source ss
                                                                                                     ON sample.sample_source_id = ss.id
                                                                                                   INNER JOIN sample_item item
                                                                                                     ON sample.id = item.samp_id
                                                                                                   INNER JOIN analysis a
                                                                                                     ON item.id = a.sampitem_id
                                                                                                   INNER JOIN RESULT r
                                                                                                     ON a.id = r.analysis_id
                                                                                                   INNER JOIN test t
                                                                                                     ON a.test_id = t.id AND
                                                                                                        t.name IN (
                                                                                                            'Genexpert (Crachat)',
                                                                                                            'Genexpert (Urine)',
                                                                                                            'Genexpert (LCR)',
                                                                                                            'Genexpert (Pleural)',
                                                                                                            'Genexpert (Ascite)',
                                                                                                            'Genexpert (Pus)',
                                                                                                            'Genexpert (Ganglionnaire)',
                                                                                                            'Genexpert (Synovial)',
                                                                                                            'Genexpert (Gastrique)',
                                                                                                            'EID (PCR)')

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
WHERE COALESCE("EID/PCR", "Genexpert Crachat", "Genexpert Urine", "Genexpert LCR", "Genexpert Pleural",
               "Genexpert Ascite", "Genexpert Pus", "Genexpert Ganglionnaire", "Genexpert Synovial",
               "Genexpert Gastrique") IS NOT NULL;
