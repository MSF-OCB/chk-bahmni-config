
Select
* from (
SELECT to_char(B.sample_date,'DD/MM/YYYY')  AS "Date prélèvement",
       B.care_center_requesting AS "Provenance",
       B.Patient_Name AS "Nom",
       B.Patient_Identifier AS "ID",
       concat((current_Date-b.dob)/365 ,' ','ans' , ' ',((current_date-b.dob)%365)/30, ' ','Mois')as Age,
       B.sexe AS "Sexe",
       to_char(B.date_of_results,'DD/MM/YYYY') AS "Date resultats",
sum(cast(case when B.FLLYM = '' then null else B.FLLYM end AS NUMERIC))AS "FLLYM%",
sum(cast(case when B.FLMXD='' then null else B.FLMXD  end AS NUMERIC)) AS "FL-MXD%",
sum(cast(case when B.FLNEUT='' then null else B.FLNEUT  end AS NUMERIC))AS "FL-NEUT%",

(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Proteinorachie='' then null else B.Proteinorachie end as   NUMERIC))) AS "Proteinorachie (test de Pandy)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Microscopie_Urine='' then null else B.Microscopie_Urine end    AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Urine)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Microscopie_LCR='' then null else B.Microscopie_LCR end   AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (LCR)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Microscopie_LCR_TB='' then null else B.Microscopie_LCR_TB end  AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (LCR-TB)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Microscopie_TB_Crachat='' then null else B.Microscopie_TB_Crachat end  AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Crachat)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Microscopie_TB_Pleural='' then null else B.Microscopie_TB_Pleural end AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Pleural)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Microscopie_TB_Ascite ='' then null else B.Microscopie_TB_Ascite end AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Ascite)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Microscopie_TB_Pus='' then null else B.Microscopie_TB_Pus  end AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Pus)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Microscopie_TB_Gangi='' then null else B.Microscopie_TB_Gangi end   AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Ganglionnaire)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Microscopie_TB_Synovial='' then null else B.Microscopie_TB_Synovial end  AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Synovial)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Microscopie_TB_Gastrique='' then null else  B.Microscopie_TB_Gastrique end AS NUMERIC))) AS "Microscopie TB - Recherche de BAAR (Gastrique)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Sang_hématurie='' then null else B.Sang_hématurie end  AS NUMERIC))) AS "Sang (hématurie)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.urobilinogène='' then null else B.urobilinogène end  AS NUMERIC))) AS "Urobilinogène",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.bilirubine_urine='' then null else B.bilirubine_urine end  AS NUMERIC))) AS "Bilirubine",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Proteines_urine ='' then null else B.Proteines_urine end  AS NUMERIC))) AS "Protéines",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.nitrites='' then null else B.nitrites end AS NUMERIC))) AS "Nitrites",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.corps_urine='' then null else B.corps_urine end  AS NUMERIC))) AS "Corps cétoniques",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Acide_urine='' then null else B.Acide_urine  end AS NUMERIC))) AS "Acide ascorbique",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Glucose_urine ='' then null else  B.Glucose_urine end AS NUMERIC))) AS "Glucose",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.ph_urine='' then null else B.ph_urine end AS NUMERIC))) AS "pH",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.leucocytes='' then null else B.leucocytes end AS NUMERIC))) AS "Leucocytes",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Test_de_urine='' then null else B.Test_de_urine end   AS NUMERIC))) AS "Test de Grossesse",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.gram ='' then null else B.gram end AS NUMERIC))) AS "Gram",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Rivalta_urine='' then null else B.Rivalta_urine end  AS NUMERIC))) AS "Rivalta(Urine)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Rivalta_LCR='' then null else B.Rivalta_LCR end   AS NUMERIC))) AS "Rivalta(LCR)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Rivalta_Crachat ='' then null else B.Rivalta_Crachat end AS NUMERIC))) AS "Rivalta(Crachat)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Rivalta_Pleural='' then null else  B.Rivalta_Pleural end AS NUMERIC))) AS "Rivalta(Pleural)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Rivalta_Ascite='' then null else  B.Rivalta_Ascite end AS NUMERIC))) AS "Rivalta(Ascite)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Rivalta_Pus ='' then null else B.Rivalta_Pus end  AS NUMERIC))) AS "Rivalta(Pus)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Rivalta_Ganglionnaire ='' then  null else B.Rivalta_Ganglionnaire end  AS NUMERIC))) AS "Rivalta(Ganglionnaire)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Rivalta_Synovial='' then null else B.Rivalta_Synovial end  AS NUMERIC))) AS "Rivalta (Synovial)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.Rivalta_Gastrique='' then null else  B.Rivalta_Gastrique end  AS NUMERIC))) AS "Rivalta (Gastrique)",
(Select d.dict_entry from  dictionary d where   cast(d.id as NUMERIC) =sum(cast(case when B.ge='' then null else B.ge end   AS NUMERIC))) AS "GE"

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
         B.sexe )as A
         where COALESCE ("FLLYM%","FL-MXD%","FL-NEUT%") is not null
         OR coalesce ("Proteinorachie (test de Pandy)","Microscopie TB - Recherche de BAAR (Urine)","Microscopie TB - Recherche de BAAR (LCR)","Microscopie TB - Recherche de BAAR (LCR-TB)","Microscopie TB - Recherche de BAAR (Crachat)","Microscopie TB - Recherche de BAAR (Pleural)","Microscopie TB - Recherche de BAAR (Ascite)","Microscopie TB - Recherche de BAAR (Pus)","Microscopie TB - Recherche de BAAR (Ganglionnaire)","Microscopie TB - Recherche de BAAR (Synovial)","Microscopie TB - Recherche de BAAR (Gastrique)",
         "Sang (hématurie)","Urobilinogène","Bilirubine","Protéines",
         "Nitrites","Corps cétoniques","Acide ascorbique","Acide ascorbique",
         "Glucose","pH","Leucocytes","Test de Grossesse","Gram","Rivalta(Urine)","Rivalta(LCR)","Rivalta(Crachat)","Rivalta(Pleural)",
         "Rivalta(Ascite)","Rivalta(Pus)","Rivalta(Ganglionnaire)","Rivalta (Synovial)","Rivalta (Gastrique)","GE") is not null ;

