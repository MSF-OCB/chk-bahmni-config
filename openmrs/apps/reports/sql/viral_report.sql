SELECT B.sample_date AS "Date de prelevement",
       B.care_center_requesting AS "Care Center Requesting",
       B.Patient_Name AS "Nom du patient",
       B.Patient_Identifier AS "Id Patient",
       B.dob AS "Dob",
       B.sexe AS "Sexe",
       sum(cast(B.ChargeVirale_value AS INTEGER)) AS "Viral Load",
       sum(cast(B.ChargeVirale_value_log AS INTEGER)) AS "Log Value VL",
       B.date_of_results AS "Date of Results",
       B.month_of_results AS "Month of result",
       B.comment AS "Notes"
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
                                                   WHEN tname ='Charge Virale - Value' THEN tvalue
                                               END AS ChargeVirale_value,
                                               CASE
                                                   WHEN tname ='Charge Virale - Logarythm' THEN tvalue
                                               END AS ChargeVirale_value_log
   FROM
     (/*Pivoting the table row to column*/ SELECT sample.lastupdated :: DATE AS sample_date,
                                                  ss.name AS care_center_requesting,
                                                  trim( concat( COALESCE(NULLIF(person.first_name, ''), ''), ' ', COALESCE(NULLIF(person.last_name, ''), '') ) ) AS Patient_Name,
                                                  pi.identity_data AS Patient_Identifier,
                                                  patient.birth_date :: DATE AS dob,
                                                  patient.gender AS sexe,
                                                  t.name AS tname,
                                                  r.value AS tvalue,
                                                  r.lastupdated :: DATE AS date_of_results,
                                                  to_char(to_timestamp(date_part('month', r.lastupdated) :: TEXT, 'MM'), 'TMMONTH') AS month_of_results,
                                                  a.comment
      FROM
        (/*Pivoting the table row to column*/ SELECT p_identiity.identity_data,
                                                     p_identiity.patient_id
         FROM patient_identity p_identiity
         WHERE p_identiity.identity_type_id = 2) pi
      INNER JOIN patient ON patient.id = pi.patient_id
      INNER JOIN person ON patient.person_id = person.id
      INNER JOIN sample_human ON patient.id = sample_human.patient_id
      INNER JOIN
        ( SELECT id,sample_source_id,lastupdated
            FROM sample
            WHERE accession_number IS NOT NULL
            and status_id=3 ) AS sample ON sample_human.samp_id = sample.id
      INNER JOIN sample_source ss ON sample.sample_source_id = ss.id
      INNER JOIN sample_item item ON sample.id = item.samp_id
      INNER JOIN analysis a ON item.id = a.sampitem_id
      INNER JOIN RESULT r ON a.id = r.analysis_id
      INNER JOIN test t ON a.test_id = t.id
      WHERE t.name IN ('Charge Virale - Value',
                       'Charge Virale - Logarythm') ) AS A) AS B
      WHERE B.date_of_results BETWEEN '#startDate#' and '#endDate#'
GROUP BY B.Patient_Name,
         B.sample_date,
         B.care_center_requesting,
         B.Patient_Identifier,
         B.dob,
         B.sexe,
         B.date_of_results,
         B.month_of_results,
         B.comment
ORDER BY B.Patient_Name,
         B.sample_date,
         B.care_center_requesting,
         B.Patient_Identifier,
         B.dob,
         B.sexe,
         B.date_of_results,
         B.month_of_results,
         B.comment;
