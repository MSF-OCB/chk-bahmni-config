SELECT to_char(B.date_of_results,'DD/MM/YYYY') AS "Date des résultats",
       B.care_center_requesting AS "Provenance",
       B.Patient_Name AS "Nom du patient",
       B.Patient_Identifier AS "Id Patient",
       b.dob AS "Date de naissance",
       to_char(B.sample_date,'DD/MM/YYYY')  AS "Date prélèvement",
       B.sexe AS "Sexe",
       (Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) = sum(cast(B.EID AS NUMERIC)) )AS "EID/PCR",
       (Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) = sum(cast(B.GenCrachat AS NUMERIC)))  AS "Genexpert Crachat",
       (Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) = sum(cast(B.GenUrine AS NUMERIC))) AS "Genexpert Urine",
       (Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) = sum(cast(B.GenLcr AS NUMERIC))) AS "Genexpert LCR",
       (Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) = sum(cast(B.GenPleural AS NUMERIC))) AS "Genexpert Pleural",
       (Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) = sum(cast(B.GenAscite AS NUMERIC))) AS "Genexpert Ascite",
       (Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) = sum(cast(B.GenPus AS NUMERIC))) AS "Genexpert Pus",
       (Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) = sum(cast(B.GenGangilio AS NUMERIC))) AS "Genexpert Ganglionnaire",
       (Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) = sum(cast(B.GenSynovial AS NUMERIC))) AS "Genexpert Synovial",
       (Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) = sum(cast(B.GenGastrique AS NUMERIC))) AS "Genexpert Gastrique"
       
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
                                                   WHEN tname ='Genexpert (Crachat)' THEN tvalue
                                               END AS GenCrachat,
                                               CASE
                                                   WHEN tname ='Genexpert (Urine)' THEN tvalue
                                               END AS GenUrine,
                                               CASE
                                                   WHEN tname ='Genexpert (LCR)' THEN tvalue
                                               END AS GenLcr,
                                               CASE
                                                   WHEN tname ='Genexpert (Pleural)' THEN tvalue
                                               END AS GenPleural,
                                               CASE
                                                   WHEN tname ='Genexpert (Ascite)' THEN tvalue
                                               END AS GenAscite,
                                               CASE
                                                   WHEN tname ='Genexpert (Pus)' THEN tvalue
                                               END AS GenPus,
                                               CASE
                                                   WHEN tname ='Genexpert (Ganglionnaire)' THEN tvalue
                                               END AS GenGangilio,
                                               CASE
                                                   WHEN tname ='Genexpert (Gastrique)' THEN tvalue
                                               END AS GenGastrique,
                                               CASE
                                                   WHEN tname ='EID (PCR)' THEN tvalue
                                               END AS EID,
                                               case 
                                                   when tname ='Genexpert (Synovial)' then tvalue
                                               end as GenSynovial
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
                                                  
                                                  sample.lastupdated :: DATE AS date_of_results,
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
            t.name IN  ('Genexpert (Crachat)','Genexpert (Urine)','Genexpert (LCR)','Genexpert (Pleural)','Genexpert (Ascite)','Genexpert (Pus)','Genexpert (Ganglionnaire)','Genexpert (Synovial)','Genexpert (Gastrique)','EID (PCR)')
       
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
