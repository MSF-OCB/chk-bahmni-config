SELECT
  "Date de prelevement",
  "Provenance",
  "Nom du patient",
  "Id Patient",
  "Date naissance",
  "Sexe",
  regexp_replace("Motif", ',$', '') AS "Motif",
  "Charge virale",
  "Charge virale (Valeur Log)",
  "Date des résultats",
  "Notes",
  "Mois des résultats"
from(
      SELECT to_char(B.sample_date,'DD/MM/YYYY')  AS "Date de prelevement",
             B.care_center_requesting AS "Provenance",
             B.Patient_Name AS "Nom du patient",
             B.Patient_Identifier AS "Id Patient",
             to_char(B.dob,'DD/MM/YYYY') AS "Date naissance",
             B.sexe AS "Sexe",
             string_agg(B.comment, ',') as "Motif",
             sum(cast(case when B.ChargeVirale_value = '' then null else B.ChargeVirale_value end AS NUMERIC)) AS "Charge virale",
             sum(cast(case when B.ChargeVirale_value_log = '' then null else B.ChargeVirale_value_log end AS NUMERIC)) AS "Charge virale (Valeur Log)",
             to_char(B.date_of_results,'DD/MM/YYYY') AS "Date des résultats",
             string_agg(case
                        when visit_type='OPD' AND priority=1 then 'OPD HIGH'
                        when visit_type='IPD' AND priority=1 then 'IPD HIGH'
                        when visit_type='OPD' AND priority=0  then visit_type
                        when visit_type='IPD' AND priority=0  then visit_type
                        when visit_type='IPD'and priority =NULL then 'IPD'
                        when visit_type='OPD' and priority=NULL then 'OPD' else null end, ',') as "Notes",
             B.month_of_results AS "Mois des résultats"



      FROM
        (/*Pivoting the table row to column*/ SELECT Patient_Name,
                                                care_center_requesting,
                                                Patient_Identifier,
                                                sample_date,
                                                dob,
                                                sexe,
                                                date_of_results,
                                                month_of_results,

                                                CASE
                                                WHEN tname ='Charge Virale HIV - Value' THEN tvalue
                                                END AS ChargeVirale_value,
                                                CASE
                                                WHEN tname ='Charge Virale HIV - Logarithme' THEN tvalue
                                                END AS ChargeVirale_value_log,
                                                visit_type,
                                                priority,
                                                comment,
                                                uuid

                                              FROM
                                                (/*Pivoting the table row to column*/ SELECT sample.collection_date  AS sample_date,
                                                                                             ss.name AS care_center_requesting,
                                                                                             trim( concat( COALESCE(NULLIF(person.first_name, ''), ''), ' ', COALESCE(NULLIF(person.last_name, ''), '') ) ) AS Patient_Name,
                                                                                             pi.identity_data AS Patient_Identifier,
                                                                                             patient.birth_date :: DATE AS dob,
                                                                                             case when patient.gender = 'M' then 'H'
                                                                                             when patient.gender = 'F' then 'F'
                                                                                             when patient.gender = 'O' then 'A'
                                                                                             else
                                                                                               patient.gender END AS sexe,
                                                                                             t.name AS tname,
                                                                                             r.value AS tvalue,
                                                                                             sample.lastupdated :: DATE AS date_of_results,
                                                                                             to_char(sample.lastupdated, 'MM') AS month_of_results,
                                                                                        a.comment,
                                                                                        sample.visit_type,
                                                                                        sample.priority,
                                                                                        sample.uuid
                                                                                      FROM
                                                                                        patient_identity pi
                                                                                        INNER JOIN patient ON patient.id = pi.patient_id
                                                                                        INNER JOIN person ON patient.person_id = person.id
                                                                                        INNER JOIN sample_human ON patient.id = sample_human.patient_id
                                                                                        INNER JOIN sample sample on sample_human.samp_id=sample.id
                                                                                        INNER JOIN sample_source ss ON sample.sample_source_id = ss.id
                                                                                        INNER JOIN sample_item item ON sample.id = item.samp_id
                                                                                        INNER JOIN analysis a ON item.id = a.sampitem_id
                                                                                        INNER JOIN RESULT r ON a.id = r.analysis_id
                                                                                        INNER JOIN test t ON a.test_id = t.id
                                                                                      WHERE t.name IN  ('Charge Virale HIV - Value',
                                                                                                        'Charge Virale HIV - Logarithme')
                                                                                            AND a.status_id=6 /*Filtering the result which are validated*/
                                                                                            AND sample.accession_number IS NOT NULL
                                                                                            AND pi.identity_type_id = 2) AS A) AS B
      WHERE date(B.date_of_results) BETWEEN '#startDate#' and '#endDate#'
      GROUP BY B.Patient_Name,
        B.sample_date,
        B.care_center_requesting,
        B.Patient_Identifier,
        B.dob,
        B.sexe,
        B.date_of_results,
        B.month_of_results,
        B.visit_type,
        B.uuid

      ORDER BY B.date_of_results,
        B.care_center_requesting,
        B.Patient_Name,
        B.dob,
        B.sexe
    ) as A
Where
  COALESCE ("Charge virale", "Charge virale (Valeur Log)") is not null;