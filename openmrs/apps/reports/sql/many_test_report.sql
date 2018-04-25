
SELECT to_char(B.sample_date,'DD/MM/YYYY')  AS "Date prélèvement",
       B.care_center_requesting AS "Provenance",
       B.Patient_Name AS "Nom",
       B.Patient_Identifier AS "ID",
       concat((current_Date-b.dob)/365 ,' ','ans' , ' ',((current_date-b.dob)%365)/30, ' ','Mois')as Age,
       B.sexe AS "Sexe",
       to_char(B.date_of_results,'DD/MM/YYYY') AS "Date resultats",
sum(cast(B.FLLYM AS NUMERIC))AS "FLLYM%",
sum(cast(B.FLMXD AS NUMERIC)) AS "FL-MXD%",
sum(cast(B.FLNEUT AS NUMERIC))AS "FL-NEUT%",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Proteinorachie AS NUMERIC))) AS "Proteinorachie (test de Pandy)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Microscopie_Urine AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Urine)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Microscopie_LCR AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (LCR)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Microscopie_LCR_TB AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (LCR-TB)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Microscopie_TB_Crachat AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Crachat)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Microscopie_TB_Pleural AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Pleural)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Microscopie_TB_Ascite AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Ascite)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Microscopie_TB_Pus AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Pus)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Microscopie_TB_Gangi AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Ganglionnaire)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Microscopie_TB_Synovial AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Synovial)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Microscopie_TB_Gastrique AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Gastrique)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Sang_hématurie AS NUMERIC))) AS "Sang (hématurie)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.urobilinogène AS NUMERIC))) AS "Urobilinogène",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.bilirubine_urine AS NUMERIC))) AS "Bilirubine",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Proteines_urine AS NUMERIC))) AS "Protéines",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.nitrites AS NUMERIC))) AS "Nitrites",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.corps_urine AS NUMERIC))) AS "Corps cétoniques",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Acide_urine AS NUMERIC))) AS "Acide ascorbique",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Glucose_urine  AS NUMERIC))) AS "Glucose",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.ph_urine AS NUMERIC))) AS "pH",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.leucocytes AS NUMERIC))) AS "Leucocytes",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Test_de_urine AS NUMERIC))) AS "Test de Grossesse",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.gram AS NUMERIC))) AS "Gram",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Rivalta_urine AS NUMERIC))) AS "Rivalta(Urine)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Rivalta_LCR  AS NUMERIC))) AS "Rivalta(LCR)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Rivalta_Crachat  AS NUMERIC))) AS "Rivalta(Crachat)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Rivalta_Pleural  AS NUMERIC))) AS "Rivalta(Pleural)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Rivalta_Ascite AS NUMERIC))) AS "Rivalta(Ascite)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Rivalta_Pus AS NUMERIC))) AS "Rivalta(Pus)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Rivalta_Ganglionnaire  AS NUMERIC))) AS "Rivalta(Ganglionnaire)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Rivalta_Synovial  AS NUMERIC))) AS "Rivalta (Synovial)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.Rivalta_Gastrique  AS NUMERIC))) AS "Rivalta (Gastrique)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(B.ge  AS NUMERIC))) AS "GE"

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
                                                   WHEN tname ='GE' THEN tvalue
                                               END AS ge,
                                               CASE
                                                   WHEN tname = 'Rivalta (Gastrique)' THEN tvalue
                                               END AS Rivalta_Gastrique,
                                               CASE
                                                   WHEN tname ='Rivalta (Synovial)' THEN tvalue
                                               END AS Rivalta_Synovial,
                                               CASE WHEN tname ='Rivalta (Ganglionnaire)' THEN tvalue
                                               END AS Rivalta_Ganglionnaire,
                                               CASE
                                                   WHEN tname ='Rivalta (Pus)' THEN tvalue
                                               END AS Rivalta_Pus,
                                               CASE
                                                   WHEN tname ='Rivalta (Ascite)' THEN tvalue
                                               END AS Rivalta_Ascite,
                                               CASE
                                                   WHEN tname ='Rivalta (Pleural)' THEN tvalue
                                               END AS Rivalta_Pleural,
                                               CASE
                                                   WHEN tname ='Rivalta (Crachat)' THEN tvalue
                                               END AS Rivalta_Crachat,
                                               CASE
                                                   WHEN tname ='Rivalta (LCR)' THEN tvalue
                                               END AS Rivalta_LCR,
                                               CASE
                                                   WHEN tname ='Rivalta (Urine)' THEN tvalue
                                               END AS Rivalta_urine,
                                               CASE
                                                   WHEN tname ='Gram' THEN tvalue
                                               END AS gram,
                                               CASE
                                                   WHEN tname ='Test de Grossesse' THEN tvalue
                                               END AS Test_de_urine,
                                               CASE
                                                   WHEN tname ='Leucocytes' THEN tvalue
                                               END AS leucocytes,
                                               CASE
                                                   WHEN tname ='pH' THEN tvalue
                                               END AS ph_urine,
                                               CASE
                                                   WHEN tname ='Glucose' THEN tvalue
                                               END AS Glucose_urine,
                                               CASE
                                                   WHEN tname ='Acide ascorbique' then tvalue
                                               END AS Acide_urine,
                                               CASE
                                                   WHEN tname ='Corps cétoniques' then tvalue
                                               END AS corps_urine,
                                               CASE
                                                   WHEN tname ='Nitrites' then tvalue
                                               END AS nitrites,
                                               CASE
                                                   WHEN tname ='Protéines' then tvalue
                                               END AS proteines_urine,
                                               CASE
                                                   WHEN tname ='Bilirubine' then tvalue
                                               END AS bilirubine_urine,
                                               CASE
                                                   WHEN tname ='Urobilinogène' then tvalue
                                               END AS urobilinogène,
                                               CASE
                                                   WHEN tname ='Sang (hématurie)' then tvalue
                                               END AS Sang_hématurie,
                                               CASE
                                                   WHEN tname ='Microscopie TB - Recherche de BAAR (Gastrique)' then tvalue
                                               END AS Microscopie_TB_Gastrique,
                                               CASE
                                                   WHEN tname ='Microscopie TB - Recherche de BAAR (Synovial)' then tvalue
                                               END AS Microscopie_TB_Synovial,
                                               CASE
                                                   WHEN tname ='Microscopie TB - Recherche de BAAR (Ganglionnaire)' then tvalue
                                               END AS Microscopie_TB_Gangi,
                                               CASE
                                                   WHEN tname ='Microscopie TB - Recherche de BAAR (Pus)' then tvalue
                                               END AS Microscopie_TB_Pus,
                                               CASE
                                                   WHEN tname ='Microscopie TB - Recherche de BAAR (Ascite)' then tvalue
                                               END AS Microscopie_TB_Ascite,
                                               CASE
                                                   WHEN tname ='Microscopie TB - Recherche de BAAR (Pleural)' then tvalue
                                               END AS Microscopie_TB_Pleural,
                                               CASE
                                                   WHEN tname ='Microscopie TB - Recherche de BAAR (Crachat)' then tvalue
                                               END AS Microscopie_TB_Crachat,
                                               CASE
                                                   WHEN tname ='Microscopie TB - Recherche de BAAR (LCR-TB)' then tvalue
                                               END AS Microscopie_LCR_TB,
                                                CASE
                                                   WHEN tname ='Microscopie TB - Recherche de BAAR (LCR)' then tvalue
                                               END AS Microscopie_LCR,
                                                CASE
                                                   WHEN tname ='Microscopie TB - Recherche de BAAR (Urine)' then tvalue
                                               END AS Microscopie_Urine,
                                                CASE
                                                   WHEN tname ='Proteinorachie (test de Pandy)' then tvalue
                                               END AS Proteinorachie,
                                                CASE
                                                   WHEN tname ='FL - NEUT%' then tvalue
                                               END AS FLNEUT,
                                                CASE
                                                   WHEN tname ='FL - MXD%' then tvalue
                                               END AS FLMXD,
                                                CASE
                                                   WHEN tname ='FL - LYM%' then tvalue
                                               END AS FLLYM






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
            t.name IN  ('GE','Rivalta (Gastrique)','Rivalta (Synovial)','Rivalta (Pus)','Rivalta (Ascite)','Rivalta (Pleural)','Rivalta (Crachat)','Rivalta (LCR)','Rivalta (Urine)','Gram',
            'Test de Grossesse','Leucocytes','pH','Glucose','Acide ascorbique','Corps cétoniques','Nitrites','Protéines','Bilirubine',
            'Urobilinogène','Sang (hématurie)','Microscopie TB - Recherche de BAAR (Gastrique)','Microscopie TB - Recherche de BAAR (Synovial)',
            'Microscopie TB - Recherche de BAAR (Ganglionnaire)','Microscopie TB - Recherche de BAAR (Pus)','Microscopie TB - Recherche de BAAR (Ascite)',
            'Microscopie TB - Recherche de BAAR (Pleural)','Microscopie TB - Recherche de BAAR (Crachat)','Microscopie TB - Recherche de BAAR (LCR-TB)',
            'Microscopie TB - Recherche de BAAR (LCR)','Microscopie TB - Recherche de BAAR (Urine)','Proteinorachie (test de Pandy)',
            'FL - NEUT%','FL - MXD%','FL - LYM%','Rivalta (Ganglionnaire)')

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
