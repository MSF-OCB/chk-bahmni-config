SELECT sample.collection_date                                   AS "Date de reception",
                       sample.received_date					   AS "Date de prélèvement",
                       ss.name                                                  AS "Centre de provenance",
                       TRIM(concat(COALESCE(NULLIF(person.first_name, ''), ''), ' ',
                                   COALESCE(NULLIF(person.last_name, ''), ''))) AS "Nom",
                       pi.identity_data                                         AS "ID Patient",
                       patient.birth_date ::DATE AS dob,
                       CASE
                         WHEN patient.gender = 'M' THEN 'H'
                         WHEN patient.gender = 'F' THEN 'F'
                         WHEN patient.gender = 'O' THEN 'A'
                         ELSE patient.gender END                                AS sexe,
                       t.name                                                   AS "Test",
                       r.value                                                  AS "Résultat",
                       sample.lastupdated  AS date_of_results,
                       sample.visit_type,
                       a.status_id
                FROM patient_identity pi
                       INNER JOIN patient ON patient.id = pi.patient_id
                       INNER JOIN person ON patient.person_id = person.id
                       INNER JOIN sample_human ON patient.id = sample_human.patient_id
                       INNER JOIN sample sample ON sample_human.samp_id = sample.id
                       INNER JOIN sample_source ss ON sample.sample_source_id = ss.id
                       INNER JOIN sample_item item ON sample.id = item.samp_id
                       INNER JOIN analysis a ON item.id = a.sampitem_id
                       LEFT JOIN RESULT r ON a.id = r.analysis_id
                       INNER JOIN test t ON a.test_id = t.id
                WHERE pi.identity_type_id = 2
                  AND date(sample.collection_date) BETWEEN '#startDate#' AND '#endDate#'