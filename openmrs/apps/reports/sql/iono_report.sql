SELECT to_char(B.date_of_results,'DD/MM/YYYY') AS "Date des résultats",
       B.care_center_requesting AS "Provenance",
       B.Patient_Name AS "Nom du patient",
       B.Patient_Identifier AS "Id Patient",
       b.dob AS "Date de naissance",
       to_char(B.sample_date,'DD/MM/YYYY')  AS "Date prélèvement",
       B.sexe AS "Sexe",
       sum(cast(B.Potassium AS NUMERIC)) AS "K",
       sum(cast(B.sod AS NUMERIC)) AS "Na",
       sum(cast(B.chlore AS NUMERIC)) AS "Cl",
       sum(cast(B.phosphate_alca AS NUMERIC)) AS "Phosphate_alcaline",
       sum(cast(B.bilitotalE AS NUMERIC)) AS "Bilirubine totalE",
       sum(cast(B.bildirect AS NUMERIC)) AS "Bilirubine directE",
       sum(cast(B.calc AS NUMERIC)) AS "Calcium"
       
FROM
  (/*Pivoting the table row to column*/ SELECT Patient_Name,
                                               care_center_requesting,
                                               Patient_Identifier,
                                               sample_date,
                                               dob,
                                               sexe,
                                               date_of_results,
                                               month_of_results,
                                               COMMENT,
                                               CASE
                                                   WHEN tname ='potassium' THEN tvalue
                                               END AS Potassium,
                                               CASE
                                                   WHEN tname ='sodium' THEN tvalue
                                               END AS sod,
                                               CASE
                                                   WHEN tname ='Chlore' THEN tvalue
                                               END AS chlore,
                                               CASE
                                                   WHEN tname ='Phosphatase alcaline' THEN tvalue
                                               END AS phosphate_alca,
                                               CASE
                                                   WHEN tname ='Bilirubine totalE' THEN tvalue
                                               END AS bilitotalE,
                                               CASE
                                                   WHEN tname ='Bilirubine directE' THEN tvalue
                                               END AS bildirect,
                                               CASE
                                                   WHEN tname ='Calcium' THEN tvalue
                                               END AS calc
                                               
                                               
   FROM
     (/*Pivoting the table row to column*/ SELECT sample.collection_date AS sample_date,
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
                                                  trim( concat( COALESCE(NULLIF(d.dict_entry,''),''),' ')) AS dvalue,
                                                  r.lastupdated :: DATE AS date_of_results,
                                                  to_char(to_timestamp(date_part('month', r.lastupdated) :: TEXT, 'MM'), 'Month') AS month_of_results,
                                                  a.comment
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
      INNER JOIN test t ON a.test_id = t.id AND
            t.name IN  ('potassium','sodium','Chlore','Phosphatase alcaline','Bilirubine totalE','Bilirubine directE','Calcium')
       LEFT JOIN dictionary d ON  r.result_type = 'D' and cast(d.id as Text) = r.value
       WHERE   a.status_id=6 /*Filtering the result which are validated*/
                       AND sample.accession_number IS NOT NULL
                       AND pi.identity_type_id = 2) AS A) AS B
                       WHERE date(B.date_of_results) BETWEEN  '#startDate#' and '#endDate#'
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
         B.sexe ;
