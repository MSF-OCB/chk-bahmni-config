SELECT to_char(B.date_of_results,'DD/MM/YYYY')   AS "Date des résultats",
       B.care_center_requesting AS "Provenance",
       B.Patient_Name AS "Nom du patient",
       B.Patient_Identifier AS "ID Patient",
       EXTRACT(YEAR FROM Now()) - EXTRACT(YEAR FROM B.dob) as "Age"  ,
       B.sexe AS "Sexe",
       to_char(B.sample_date, 'DD/MM/YYYY') as "Date de prélèvement",
       sum(cast(B.CD4 AS NUMERIC)) AS "RESULTS CD4 (cells/µl)",
       sum(cast(B.CD4_percentage AS NUMERIC)) AS "CD4 %",
       sum(cast(B.GPT AS NUMERIC)) AS "SGPT (UI/L)",
       sum(cast(B.Creatinine AS NUMERIC)) AS "CREAT (µmol/L)",
       sum(cast(B.Glucose_LCR AS NUMERIC)) AS "GLU LCR (mg/dl)",
       (Select dict_entry from DICTIONARY where id in (sum(cast(B.Hep_B AS NUMERIC))) ) "Hep. B", /*getting coded value for tests*/
       (Select dict_entry from DICTIONARY where id in (sum(cast(B.Crag_serique AS NUMERIC))) )AS "CRAG SERIQUE",/*getting coded value for tests*/
       (Select dict_entry from DICTIONARY where id in (sum(cast(B.Crag_LCR AS NUMERIC)))) AS "CRAG LCR"/*getting coded value for tests*/

FROM
  (/*Pivoting the table row to column*/
      SELECT
       accession_number,
       date_of_results,
       Patient_Name,
       care_center_requesting,
       Patient_Identifier,
       dob,
       sexe,
       sample_date,
       
       CASE
           WHEN tname ='CD4' THEN tvalue
       END AS CD4,
       CASE
           WHEN tname ='CD4 % (enfants de - 5 ans)' THEN tvalue
       END AS CD4_percentage,
       CASE
           WHEN tname ='GPT' THEN tvalue
       END AS GPT,
       CASE
           WHEN tname ='Creatinine' THEN tvalue
       END AS Creatinine,
       CASE
           WHEN tname ='Glucose (LCR)' THEN tvalue
       END AS Glucose_LCR,
       CASE
           WHEN tname ='Hep. B' THEN tvalue
       END AS Hep_B,
       CASE
           WHEN tname ='Crag serique' THEN tvalue
       END AS Crag_serique,
        CASE
           WHEN tname ='Crag' THEN tvalue
       END AS Crag_LCR

       FROM
         (/*defining columns*/
           SELECT
                sample.lastupdated  AS date_of_results,
                ss.name AS care_center_requesting,
                trim( concat( COALESCE(NULLIF(person.first_name, ''), ''), ' ', COALESCE(NULLIF(person.last_name, ''), '') ) ) AS Patient_Name,
                pi.identity_data AS Patient_Identifier,
                patient.birth_date :: DATE AS dob,
                case when patient.gender = 'M' then 'H'
                     when patient.gender = 'F' then 'F'
                     when patient.gender = 'O' then 'A'
                else
                    patient.gender END AS sexe,
                sample.collection_date as "sample_date",
                t.name AS tname,
                r.value AS tvalue,
                sample.accession_number
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
          WHERE t.name IN (
                            'CD4',
                            'CD4 % (enfants de - 5 ans)',
                            'GPT',
                            'Creatinine',
                            'Glucose (LCR)',
                            'Hep. B',
                            'Crag serique',
                            'Crag'
                          )
                AND a.status_id=6 /*Filtering the result which are validated*/
                AND sample.accession_number IS NOT NULL
                AND pi.identity_type_id = 2
                           ) AS A
    ) AS B
WHERE date(B.date_of_results) BETWEEN '#startDate#' and '#endDate#'
GROUP BY B.Patient_Name,
         B.care_center_requesting,
         B.Patient_Identifier,
         B.dob,
         B.sexe,
         B.sample_date,
         B.date_of_results,
         B.accession_number
ORDER BY B.date_of_results,
         B.care_center_requesting,
         B.Patient_Name,
         B.dob,
         B.sexe;
