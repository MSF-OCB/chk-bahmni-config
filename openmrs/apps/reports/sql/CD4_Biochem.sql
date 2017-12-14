SELECT B.date_of_results AS "Date of Results",
       B.care_center_requesting AS "Center",
       B.Patient_Name AS "Last and First Name",
       B.Patient_Identifier AS "PATIENT ID",
       EXTRACT(YEAR FROM Now()) - EXTRACT(YEAR FROM B.dob) as "Age"  ,
       B.sexe AS "Sexe",
       sum(cast(B.CD4 AS INTEGER)) AS "RESULTS CD4 (cells/µl)",
       sum(cast(B.CD4_percentage AS INTEGER)) AS "CD4 %",
       sum(cast(B.GPT AS INTEGER)) AS "SGPT (UI/L)",
       sum(cast(B.Creatinine AS INTEGER)) AS "CREAT (µmol/L)",
       sum(cast(B.Glucose_LCR AS INTEGER)) AS "GLU LCR (mg/dl)",
       (Select dict_entry from DICTIONARY where id in (sum(cast(B.Hep_B AS INTEGER))) ) "Hep. B", /*getting coded value for tests*/
       (Select dict_entry from DICTIONARY where id in (sum(cast(B.Crag_serique AS INTEGER))) )AS "CRAG SERIQUE",/*getting coded value for tests*/
       (Select dict_entry from DICTIONARY where id in (sum(cast(B.Crag_LCR AS INTEGER)))) AS "CRAG LCR"/*getting coded value for tests*/

FROM
  (/*Pivoting the table row to column*/
      SELECT
       date_of_results,
       Patient_Name,
       care_center_requesting,
       Patient_Identifier,
       dob,
       sexe,
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
         (/*defining columns*/          SELECT r.lastupdated :: DATE AS date_of_results,
                                                      ss.name AS care_center_requesting,
                                                      trim( concat( COALESCE(NULLIF(person.first_name, ''), ''), ' ', COALESCE(NULLIF(person.last_name, ''), '') ) ) AS Patient_Name,
                                                      pi.identity_data AS Patient_Identifier,
                                                      patient.birth_date :: DATE AS dob,
                                                      patient.gender AS sexe,
                                                      t.name AS tname,
                                                      r.value AS tvalue


          FROM
            (                           SELECT p_identiity.identity_data,
                                                         p_identiity.patient_id
             FROM patient_identity p_identiity
             WHERE p_identiity.identity_type_id = 2) pi
          INNER JOIN patient ON patient.id = pi.patient_id
          INNER JOIN person ON patient.person_id = person.id
          INNER JOIN sample_human ON patient.id = sample_human.patient_id
          INNER JOIN
            ( /* Selecting order which are validated ie status = 3*/
            SELECT id, sample_source_id
            FROM sample
            WHERE accession_number IS NOT NULL
            and status_id=3
            ) AS sample ON sample_human.samp_id = sample.id
          INNER JOIN sample_source ss ON sample.sample_source_id = ss.id
          INNER JOIN sample_item item ON sample.id = item.samp_id
          INNER JOIN analysis a ON item.id = a.sampitem_id
          INNER JOIN RESULT r ON a.id = r.analysis_id
          INNER JOIN test t ON a.test_id = t.id
          WHERE t.name IN ('CD4',
                           'CD4 % (enfants de - 5 ans)',
                           'GPT',
                            'Creatinine',
                            'Glucose (LCR)',
                            'Hep. B',
                            'Crag serique',
                            'Crag') ) AS A
    ) AS B
GROUP BY B.Patient_Name,
         B.care_center_requesting,
         B.Patient_Identifier,
         B.dob,
         B.sexe,
         B.date_of_results
ORDER BY B.date_of_results,
         B.care_center_requesting,
         B.Patient_Name,
         B.dob,
         B.sexe;
