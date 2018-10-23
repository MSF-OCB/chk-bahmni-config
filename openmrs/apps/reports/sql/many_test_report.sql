SELECT *
FROM (SELECT to_char(B.date_of_results, ''DD/MM/YYYY'')                                                                  AS "Date des résults",
             B.care_center_requesting                                                                                    AS "Provenance",
             B.Patient_Name                                                                                              AS "Nom du patient",
             B.Patient_Identifier                                                                                        AS "Id Patient",
             to_char(B.dob, ''DD/MM/YYYY'')                                                                              AS "Date naissance",
             to_char(B.sample_date, ''DD/MM/YYYY'')                                                                      AS "Date de prelevement",
             B.sexe                                                                                                      AS "Sexe",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(
                                              CAST(CASE WHEN B.PROTIEN = '''' THEN NULL ELSE B.PROTIEN END AS NUMERIC))) AS "Pandy LCR",
             sum(CAST(CASE WHEN B.PLAQUETTES = '''' THEN NULL ELSE B.PLAQUETTES END AS
                      NUMERIC))AS                                                                                           "Pqt",
             sum(CAST(CASE WHEN B.HEMO = '''' THEN NULL ELSE B.HEMO END AS NUMERIC))AS                                      "Hb",
             sum(
               CAST(CASE WHEN B.GBLANCS = '''' THEN NULL ELSE B.GBLANCS END AS NUMERIC))AS                                  "GB",
             sum(
               CAST(CASE WHEN B.FLLYM = '''' THEN NULL ELSE B.FLLYM END AS NUMERIC))AS                                      "FL-L%",
             sum(
               CAST(CASE WHEN B.FLNEUT = '''' THEN NULL ELSE B.FLNEUT END AS NUMERIC))AS                                    "FL-N%",
             sum(
               CAST(CASE WHEN B.FLMXD = '''' THEN NULL ELSE B.FLMXD END AS NUMERIC))                                     AS "FL-MID%",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(
                                              CAST(CASE WHEN B.MALARIA = '''' THEN NULL ELSE B.MALARIA END AS NUMERIC))) AS "Palu",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.SYPHILLS = '''' THEN NULL ELSE B.SYPHILLS END AS
                                                     NUMERIC)))                                                          AS "Siphilis",
             sum(
               CAST(CASE WHEN B.HEMOPR = '''' THEN NULL ELSE B.HEMOPR END AS NUMERIC))                                   AS "Hb(Hemocue)",
             sum(
               CAST(CASE WHEN B.GlYCEME = '''' THEN NULL ELSE B.GlYCEME END AS NUMERIC))                                 AS "Glycémie",
             sum(CAST(CASE WHEN B.LACT = '''' THEN NULL ELSE B.LACT END AS NUMERIC))                                     AS "Lactate",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Microscopie_Urine = '''' THEN NULL
                                                       ELSE B.Microscopie_Urine END AS
                                                     NUMERIC)))                                                          AS "Micro TB - Recherche de BAAR (Urine)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(
                                                  CASE WHEN B.Microscopie_LCR = '''' THEN NULL ELSE B.Microscopie_LCR END
                                                  AS
                                                  NUMERIC)))                                                             AS "Micro TB - Recherche de BAAR (LCR)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Microscopie_LCR_TB = '''' THEN NULL
                                                       ELSE B.Microscopie_LCR_TB END AS
                                                     NUMERIC)))                                                          AS "Micro TB - Recherche de BAAR (LCR-TB)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Microscopie_TB_Crachat = '''' THEN NULL
                                                       ELSE B.Microscopie_TB_Crachat END AS
                                                     NUMERIC)))                                                          AS "Micro TB - Recherche de BAAR (Crachat)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Microscopie_TB_Pleural = '''' THEN NULL
                                                       ELSE B.Microscopie_TB_Pleural END AS
                                                     NUMERIC)))                                                          AS "Micro TB - Recherche de BAAR (Pleural)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Microscopie_TB_Ascite = '''' THEN NULL
                                                       ELSE B.Microscopie_TB_Ascite END AS
                                                     NUMERIC)))                                                          AS "Micro TB - Recherche de BAAR (Ascite)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Microscopie_TB_Pus = '''' THEN NULL
                                                       ELSE B.Microscopie_TB_Pus END AS
                                                     NUMERIC)))                                                          AS "Micro TB - Recherche de BAAR (Pus)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Microscopie_TB_Gangi = '''' THEN NULL
                                                       ELSE B.Microscopie_TB_Gangi END AS
                                                     NUMERIC)))                                                          AS "Micro TB - Recherche de BAAR (Ganglionnaire)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Microscopie_TB_Synovial = '''' THEN NULL
                                                       ELSE B.Microscopie_TB_Synovial END AS
                                                     NUMERIC)))                                                          AS "Micro TB - Recherche de BAAR (Synovial)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Microscopie_TB_Gastrique = '''' THEN NULL
                                                       ELSE B.Microscopie_TB_Gastrique END AS
                                                     NUMERIC)))                                                          AS "Micro TB - Recherche de BAAR (Gastrique)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(
                                              CAST(CASE WHEN B.Sang_hématurie = '''' THEN NULL ELSE B.Sang_hématurie END
                                                   AS
                                                   NUMERIC)))                                                            AS "BU-Sang",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.urobilinogène = '''' THEN NULL ELSE B.urobilinogène END
                                                     AS
                                                     NUMERIC)))                                                          AS "BU-Urobilinogène",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(
                                                  CASE
                                                    WHEN B.bilirubine_urine = '''' THEN NULL
                                                    ELSE B.bilirubine_urine END
                                                  AS
                                                  NUMERIC)))                                                             AS "BU-Bilirubine",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(
                                                  CASE WHEN B.Proteines_urine = '''' THEN NULL ELSE B.Proteines_urine END
                                                  AS
                                                  NUMERIC)))                                                             AS "BU-Protéines",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(
                                              CAST(CASE WHEN B.nitrites = '''' THEN NULL ELSE B.nitrites END AS
                                                   NUMERIC)))                                                            AS "BU-Nitrites",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.corps_urine = '''' THEN NULL ELSE B.corps_urine END AS
                                                     NUMERIC)))                                                          AS "BU-Corps cétoniques",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.Acide_urine = '''' THEN NULL ELSE B.Acide_urine END AS
                                                     NUMERIC)))                                                          AS "BU-Acide ascorbique",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.Glucose_urine = '''' THEN NULL ELSE B.Glucose_urine END
                                                     AS
                                                     NUMERIC)))                                                          AS "BU-Glucose",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(
                                              CAST(CASE WHEN B.ph_urine = '''' THEN NULL ELSE B.ph_urine END AS
                                                   NUMERIC)))                                                            AS "BU-pH",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.leucocytes = '''' THEN NULL ELSE B.leucocytes END AS
                                                     NUMERIC)))                                                          AS "BU-Leucocytes",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.Test_de_urine = '''' THEN NULL ELSE B.Test_de_urine END
                                                     AS
                                                     NUMERIC)))                                                          AS "Urine Test de grosse",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) =
                    sum(CAST(CASE WHEN B.gram = '''' THEN NULL ELSE B.gram END AS NUMERIC)))                             AS "Gram",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.Rivalta_urine = '''' THEN NULL ELSE B.Rivalta_urine END
                                                     AS
                                                     NUMERIC)))                                                          AS "Rivalta(Urine)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.Rivalta_LCR = '''' THEN NULL ELSE B.Rivalta_LCR END AS
                                                     NUMERIC)))                                                          AS "Rivalta(LCR)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(
                                                  CASE WHEN B.Rivalta_Crachat = '''' THEN NULL ELSE B.Rivalta_Crachat END
                                                  AS
                                                  NUMERIC)))                                                             AS "Rivalta(Crachat)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(
                                                  CASE WHEN B.Rivalta_Pleural = '''' THEN NULL ELSE B.Rivalta_Pleural END
                                                  AS
                                                  NUMERIC)))                                                             AS "Rivalta(Pleural)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(
                                              CAST(CASE WHEN B.Rivalta_Ascite = '''' THEN NULL ELSE B.Rivalta_Ascite END
                                                   AS
                                                   NUMERIC)))                                                            AS "Rivalta(Ascite)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE WHEN B.Rivalta_Pus = '''' THEN NULL ELSE B.Rivalta_Pus END AS
                                                     NUMERIC)))                                                          AS "Rivalta(Pus)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Rivalta_Ganglionnaire = '''' THEN NULL
                                                       ELSE B.Rivalta_Ganglionnaire END AS
                                                     NUMERIC)))                                                          AS "Rivalta(Ganglionnaire)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(
                                                  CASE
                                                    WHEN B.Rivalta_Synovial = '''' THEN NULL
                                                    ELSE B.Rivalta_Synovial END
                                                  AS
                                                  NUMERIC)))                                                             AS "Rivalta (Synovial)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) = sum(CAST(CASE
                                                       WHEN B.Rivalta_Gastrique = '''' THEN NULL
                                                       ELSE B.Rivalta_Gastrique END AS
                                                     NUMERIC)))                                                          AS "Rivalta (Gastrique)",
             (SELECT d.dict_entry
              FROM DICTIONARY d
              WHERE CAST(d.id AS NUMERIC) =
                    sum(CAST(CASE WHEN B.ge = '''' THEN NULL ELSE B.ge END AS NUMERIC)))                                 AS "GE"

      FROM (/*Pivoting the table row to column*/
           SELECT Patient_Name,
                  care_center_requesting,
                  Patient_Identifier,
                  sample_date,
                  dob,
                  sexe,
                  date_of_results,
                  month_of_results,
                  sid,
                  COMMENT,
                  CASE
                    WHEN tname = ''GE'' THEN tvalue
                      END AS ge,
                  CASE
                    WHEN tname = ''Rivalta (Gastrique)'' THEN tvalue
                      END AS Rivalta_Gastrique,
                  CASE
                    WHEN tname = ''Rivalta (Synovial)'' THEN tvalue
                      END AS Rivalta_Synovial,
                  CASE
                    WHEN tname = ''Rivalta (Ganglionnaire)'' THEN tvalue
                      END AS Rivalta_Ganglionnaire,
                  CASE
                    WHEN tname = ''Rivalta (Pus)'' THEN tvalue
                      END AS Rivalta_Pus,
                  CASE
                    WHEN tname = ''Rivalta (Ascite)'' THEN tvalue
                      END AS Rivalta_Ascite,
                  CASE
                    WHEN tname = ''Rivalta (Pleural)'' THEN tvalue
                      END AS Rivalta_Pleural,
                  CASE
                    WHEN tname = ''Rivalta (Crachat)'' THEN tvalue
                      END AS Rivalta_Crachat,
                  CASE
                    WHEN tname = ''Rivalta (LCR)'' THEN tvalue
                      END AS Rivalta_LCR,
                  CASE
                    WHEN tname = ''Rivalta (Urine)'' THEN tvalue
                      END AS Rivalta_urine,
                  CASE
                    WHEN tname = ''Gram'' THEN tvalue
                      END AS gram,
                  CASE
                    WHEN tname = ''Test de Grossesse'' THEN tvalue
                      END AS Test_de_urine,
                  CASE
                    WHEN tname = ''Leucocytes'' THEN tvalue
                      END AS leucocytes,
                  CASE
                    WHEN tname = ''pH'' THEN tvalue
                      END AS ph_urine,
                  CASE
                    WHEN tname = ''Glucose'' THEN tvalue
                      END AS Glucose_urine,
                  CASE
                    WHEN tname = ''Acide ascorbique'' THEN tvalue
                      END AS Acide_urine,
                  CASE
                    WHEN tname = ''Corps cétoniques'' THEN tvalue
                      END AS corps_urine,
                  CASE
                    WHEN tname = ''Nitrites'' THEN tvalue
                      END AS nitrites,
                  CASE
                    WHEN tname = ''Protéines'' THEN tvalue
                      END AS proteines_urine,
                  CASE
                    WHEN tname = ''Bilirubine'' THEN tvalue
                      END AS bilirubine_urine,
                  CASE
                    WHEN tname = ''Urobilinogène'' THEN tvalue
                      END AS urobilinogène,
                  CASE
                    WHEN tname = ''Sang (hématurie)'' THEN tvalue
                      END AS Sang_hématurie,
                  CASE
                    WHEN tname = ''Micro TB - Recherche de BAAR (Gastrique)''
                            THEN tvalue
                      END AS Microscopie_TB_Gastrique,
                  CASE
                    WHEN tname = ''Micro TB - Recherche de BAAR (Synovial)''
                            THEN tvalue
                      END AS Microscopie_TB_Synovial,
                  CASE
                    WHEN tname = ''Micro TB - Recherche de BAAR (Ganglionnaire)''
                            THEN tvalue
                      END AS Microscopie_TB_Gangi,
                  CASE
                    WHEN tname = ''Micro TB - Recherche de BAAR (Pus)''
                            THEN tvalue
                      END AS Microscopie_TB_Pus,
                  CASE
                    WHEN tname = ''Micro TB - Recherche de BAAR (Ascite)''
                            THEN tvalue
                      END AS Microscopie_TB_Ascite,
                  CASE
                    WHEN tname = ''Micro TB - Recherche de BAAR (Pleural)''
                            THEN tvalue
                      END AS Microscopie_TB_Pleural,
                  CASE
                    WHEN tname = ''Micro TB - Recherche de BAAR (Crachat)''
                            THEN tvalue
                      END AS Microscopie_TB_Crachat,
                  CASE
                    WHEN tname = ''Micro TB - Recherche de BAAR (LCR-TB)''
                            THEN tvalue
                      END AS Microscopie_LCR_TB,
                  CASE
                    WHEN tname = ''Micro TB - Recherche de BAAR (LCR)''
                            THEN tvalue
                      END AS Microscopie_LCR,
                  CASE
                    WHEN tname = ''Micro TB - Recherche de BAAR (Urine)''
                            THEN tvalue
                      END AS Microscopie_Urine,
                  CASE
                    WHEN tname = ''Proteinorachie (test de Pandy)'' THEN tvalue
                      END AS PROTIEN,
                  CASE
                    WHEN tname = ''FL - NEUT%'' THEN tvalue
                      END AS FLNEUT,
                  CASE
                    WHEN tname = ''FL - MXD%'' THEN tvalue
                      END AS FLMXD,
                  CASE
                    WHEN tname = ''FL - LYM%'' THEN tvalue
                      END AS FLLYM,
                  CASE
                    WHEN tname = ''Plaquettes'' THEN tvalue
                      END AS PLAQUETTES,
                  CASE
                    WHEN tname = ''Hemoglobine'' THEN tvalue
                      END AS HEMO,
                  CASE
                    WHEN tname = ''Syphilis'' THEN tvalue
                      END AS SYPHILLS,
                  CASE
                    WHEN tname = ''Glycémie'' THEN tvalue
                      END AS GLYCEME,
                  CASE
                    WHEN tname = ''Hemoglobine* (Hemocue)'' THEN tvalue
                      END AS HEMOPR,
                  CASE
                    WHEN tname = ''Lactate'' THEN tvalue
                      END AS LACT,
                  CASE
                    WHEN tname = ''Globules Blancs'' THEN tvalue
                      END AS GBLANCS,
                  CASE
                    WHEN tname = ''TDR - Malaria'' THEN tvalue
                      END AS MALARIA


           FROM (/*Pivoting the table row to column*/
                SELECT sample.collection_date                                                                                                            AS sample_date,
                       ss.name                                                                                                                           AS care_center_requesting,
                       TRIM(concat(
                              COALESCE(NULLIF(person.first_name, ''''), ''''),
                              '' '',
                              COALESCE(NULLIF(person.last_name, ''''), '''')))                                                                           AS Patient_Name,
                       pi.identity_data                                                                                                                  AS Patient_Identifier,
                       patient.birth_date ::DATE AS dob,
                       CASE
                         WHEN patient.gender = ''M''
                                 THEN ''H''
                         WHEN patient.gender = ''F''
                                 THEN ''F''
                         WHEN patient.gender = ''O''
                                 THEN ''A''
                         ELSE patient.gender END                                                                                                         AS sexe,
                       t.name                                                                                                                            AS tname,
                       r.value                                                                                                                           AS tvalue,
                       sample.id                                                                                                                         AS sid,
                       sample.lastupdated ::DATE AS date_of_results,
                       to_char(
                         to_timestamp(date_part(''month'', r.lastupdated) :: TEXT, ''MM''),
                         ''Month'')                                                                                                                      AS month_of_results,
                       a.comment
                FROM patient_identity pi
                       INNER JOIN patient ON patient.id = pi.patient_id
                       INNER JOIN person ON patient.person_id = person.id
                       INNER JOIN sample_human ON patient.id = sample_human.patient_id
                       INNER JOIN sample sample ON sample_human.samp_id = sample.id
                       INNER JOIN sample_source ss ON sample.sample_source_id = ss.id
                       INNER JOIN sample_item item ON sample.id = item.samp_id
                       INNER JOIN analysis a ON item.id = a.sampitem_id
                       INNER JOIN RESULT r ON a.id = r.analysis_id
                       INNER JOIN test t ON a.test_id = t.id AND
                                            t.name IN
                                            (''GE'', ''Rivalta (Gastrique)'', ''Rivalta (Synovial)'', ''Rivalta (Pus)'', ''Rivalta (Ascite)'', ''Rivalta (Pleural)'', ''Rivalta (Crachat)'', ''Rivalta (LCR)'', ''Rivalta (Urine)'', ''Gram'', ''Plaquettes'',
                                                ''Test de Grossesse'', ''Leucocytes'', ''pH'', ''Glucose'', ''Acide ascorbique'', ''Corps cétoniques'', ''Nitrites'', ''Protéines'', ''Bilirubine'',
                                                ''Urobilinogène'', ''Sang (hématurie)'', ''Microscopie TB - Recherche de BAAR (Gastrique)'', ''Micro TB - Recherche de BAAR (Synovial)'',
                                                ''Micro TB - Recherche de BAAR (Ganglionnaire)'', ''Micro TB - Recherche de BAAR (Pus)'', ''Micro TB - Recherche de BAAR (Ascite)'',
                                                ''Micro TB - Recherche de BAAR (Pleural)'', ''Micro TB - Recherche de BAAR (Crachat)'', ''Micro TB - Recherche de BAAR (LCR-TB)'',
                                                ''Micro TB - Recherche de BAAR (LCR)'', ''Micro TB - Recherche de BAAR (Urine)'', ''Proteinorachie (test de Pandy)'',
                                                ''FL - NEUT%'', ''FL - MXD%'', ''FL - LYM%'', ''Rivalta (Ganglionnaire)'', ''Hemoglobine* (Hemocue)'', ''Hemoglobine'',
                                                ''Lactate'', ''Globules Blancs'', ''Syphilis'', ''TDR - Malaria'', ''Glycémie'')

                WHERE a.status_id = 6 /*Filtering the result which are validated*/
                  AND sample.accession_number IS NOT NULL
                  AND pi.identity_type_id = 2) AS A) AS B
      WHERE date(B.date_of_results) BETWEEN ''#startDate#'' AND ''#endDate#''
      GROUP BY B.Patient_Name,
               B.sample_date,
               B.care_center_requesting,
               B.Patient_Identifier,
               B.dob,
               B.sexe,
               B.date_of_results,
               B.month_of_results,
               B.sid
      ORDER BY B.date_of_results,
               B.care_center_requesting,
               B.Patient_Name,
               B.dob,
               B.sexe)AS A
WHERE COALESCE("FL-L%", "FL-MID%", "FL-N%") IS NOT NULL
   OR COALESCE("Siphilis", "Micro TB - Recherche de BAAR (Urine)", "Micro TB - Recherche de BAAR (LCR)",
               "Micro TB - Recherche de BAAR (LCR-TB)", "Micro TB - Recherche de BAAR (Crachat)",
               "Micro TB - Recherche de BAAR (Pleural)", "Micro TB - Recherche de BAAR (Ascite)",
               "Micro TB - Recherche de BAAR (Pus)", "Micro TB - Recherche de BAAR (Ganglionnaire)",
               "Micro TB - Recherche de BAAR (Synovial)", "Micro TB - Recherche de BAAR (Gastrique)",
               "BU-Sang", "BU-Urobilinogène", "BU-Bilirubine", "BU-Protéines", "Palu", "Pandy LCR",
               "BU-Nitrites", "BU-Corps cétoniques", "BU-Acide ascorbique", "BU-Acide ascorbique",
               "BU-Glucose", "BU-pH", "BU-Leucocytes", "Urine Test de grosse", "Gram", "Rivalta(Urine)", "Rivalta(LCR)",
               "Rivalta(Crachat)", "Rivalta(Pleural)",
               "Rivalta(Ascite)", "Rivalta(Pus)", "Rivalta(Ganglionnaire)", "Rivalta (Synovial)", "Rivalta (Gastrique)",
               "GE") IS NOT NULL
   OR COALESCE("Pqt", "Hb", "GB", "Lactate", "Glycémie", "Hb(Hemocue)") IS NOT NULL;
