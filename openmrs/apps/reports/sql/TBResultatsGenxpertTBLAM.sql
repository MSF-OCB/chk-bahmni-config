SELECT pi.identifier                                                                             AS "ID",
       group_concat(DISTINCT(CASE WHEN pad.name = 'Type de cohorte' THEN cn.name ELSE NULL END)) AS "Type cohorte",
       CONCAT(pn.family_name, ' ', pn.given_name)                                                AS `Nom`,
       floor(DATEDIFF(CURDATE(), p.birthdate) / 365)                                             AS `Age`,
       date_format(p.birthdate, '%d/%m/%Y')                                                      AS "Date de naissance",
       CASE
         WHEN p.gender = 'M' THEN 'H'
         WHEN p.gender = 'F' THEN 'F'
         WHEN p.gender = 'O' THEN 'A'
         ELSE p.gender END                                                                       AS "Sexe",
       date_format(group_concat(DISTINCT(CASE
                                           WHEN pad.name = 'Date entrée cohorte' THEN date(pa.value)
                                           ELSE NULL END)),
                   '%d/%m/%Y')                                                                   AS "Date entree cohorte",
       date_format(tbpgm.tbStartDate, '%d/%m/%Y')                                                AS "Date début TB",
       tbpgm.reason                                                                              AS "Motif début TB",
       tbpgm.tbType                                                                              AS "Type TB",
       date_format(arvpgm.enrolledDate, '%d/%m/%Y')                                              AS "Date début ARV",
       date_format(tbgenexp.dateresults, '%d/%m/%Y')                                             AS "Date resultats ",
       tbgenexp.genvalue                                                                         AS "Résultats Genexpert",
       tbgenexp.TBLAMvalue                                                                       AS "Resultats TB-LAM"
FROM (SELECT pp.patient_id,
             p.name                                                                         AS Pname,
             vt.visit_id                                                                    AS visitid,
             max(date(pp.date_enrolled))                                                    AS `tbStartDate`,
             group_concat(DISTINCT(IF(pat.name = 'TB Type', cn.name, NULL)))                AS `tbType`,
             group_concat(DISTINCT(IF(pat.name = 'Site TEP', cn.name, NULL)))               AS `siteTEP`,
             pp.date_completed                                                              AS `endDate`,
             group_concat(DISTINCT(IF(pat.name = 'Motif début traitement', cn.name, NULL))) AS `reason`
      FROM patient_program pp
             INNER JOIN (/*TB Program information*/
                        SELECT pp.patient_id, pp.program_id, max(pp.date_enrolled) AS date_enrolled
                        FROM patient_program pp
                               INNER JOIN program p
                                 ON pp.program_id = p.program_id AND p.retired = 0 AND pp.voided = 0 AND
                                    p.name = 'Programme TB'
                        WHERE pp.patient_id NOT IN
                              (/*removing patient which have program end date before reporting date*/
                              SELECT CASE
                                       WHEN Max(date(TBpatientProgCompletedDate.date_completed)) >
                                            Max(Date(TBpatientProgStartDate.date_enrolled))
                                               THEN TBpatientProgCompletedDate.patient_id
                                       ELSE 0 END AS patientID
                              FROM patient_program TBpatientProgCompletedDate
                                     JOIN patient_program TBpatientProgStartDate
                                       ON TBpatientProgCompletedDate.patient_id = TBpatientProgStartDate.patient_id
                                            AND
                                          TBpatientProgCompletedDate.program_id = TBpatientProgStartDate.program_id
                              WHERE TBpatientProgCompletedDate.date_completed IS NOT NULL
                                AND TBpatientProgCompletedDate.outcome_concept_id IS NOT NULL
                                AND DATE(TBpatientProgCompletedDate.date_completed) <= DATE('#endDate#')
                                AND TBpatientProgCompletedDate.voided = 0
                                AND TBpatientProgCompletedDate.program_id = 2
                                AND TBpatientProgStartDate.voided = 0
                                AND pp.patient_id = TBpatientProgCompletedDate.patient_id
                                AND DATE(TBpatientProgStartDate.date_enrolled) <= DATE('#endDate#')
                              GROUP BY TBpatientProgCompletedDate.patient_id)
                        GROUP BY pp.patient_id) latest_TB_prog
               ON latest_TB_prog.patient_id = pp.patient_id AND latest_TB_prog.date_enrolled = pp.date_enrolled
             LEFT JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE
             LEFT JOIN program_workflow pw ON pw.program_id = pp.program_id
             LEFT JOIN patient_program_attribute ppa
               ON ppa.patient_program_id = pp.patient_program_id AND ppa.voided IS FALSE
             LEFT JOIN program_attribute_type pat
               ON ppa.attribute_type_id = pat.program_attribute_type_id AND pat.retired IS FALSE
             LEFT JOIN program_workflow_state pws ON pws.program_workflow_id = pw.program_workflow_id
             LEFT JOIN patient_state ps
               ON ps.patient_program_id = pp.patient_program_id AND ps.state = pws.program_workflow_state_id
                    AND ps.voided = 0 AND ps.end_date IS NULL
             LEFT JOIN concept_name cn ON cn.concept_id = ppa.value_reference AND cn.concept_name_type = 'SHORT'
             LEFT JOIN visit vt ON vt.patient_id = pp.patient_id
      WHERE p.program_id = 2
      GROUP BY patient_id) AS tbpgm
       INNER JOIN (/* TBLAM and Genexpert */
                  SELECT t1.patient_id                           AS PID,
                         group_concat(DISTINCT(CASE
                                                 WHEN t1.genvalue IN ('Positif', 'Négatif') THEN t1.genvalue
                                                 ELSE NULL END)) AS "TBLAMvalue",
                         group_concat(DISTINCT(CASE
                                                 WHEN t1.genvalue IN
                                                      ('MTB -', 'MTB + RIF -', 'MTB + RIF +', 'MTB + RIF indeterminé')
                                                         THEN t1.genvalue
                                                 ELSE NULL END)) AS genvalue,
                         (CASE
                            WHEN t1.genvalue IN ('Positif', 'Négatif') THEN date(obsdate)
                            WHEN t1.genvalue IN ('MTB -', 'MTB + RIF -', 'MTB + RIF +', 'MTB + RIF indeterminé')
                                    THEN date(obsdate)
                            ELSE NULL END)                       AS "dateresults",
                         t1.visit
                  FROM (SELECT patient_id, visit, genvalue, c1, obsdate, oid, encounter_id
                        FROM (SELECT patient_id, visit, genvalue, c1, obsdate, oid, encounter_id
                              FROM (SELECT et.patient_id,
                                           et.visit_id                                   AS visit,
                                           GROUP_CONCAT(DISTINCT(cva.concept_full_name)) AS genvalue,
                                           NULL                                          AS C1,
                                           max(oTest.obs_datetime)                       AS obsdate,
                                           max(oTest.obs_id)                             AS OID,
                                           max(et.encounter_id)                          AS encounter_id
                                    FROM obs oTest
                                           INNER JOIN encounter et
                                             ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
                                           INNER JOIN concept_view cvt
                                             ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name IN
                                                                                      ('Genexpert (Crachat)', 'Genexpert (Pus)', 'Genexpert (Gastrique)', 'Genexpert (Ascite)',
                                                                                          'Genexpert (Pleural)', 'Genexpert (Ganglionnaire)', 'Genexpert (Synovial)',
                                                                                          'Genexpert (Urine)', 'Genexpert (LCR)', 'Genexpert (LCR - Bilan de routine IPD)',
                                                                                          'Genexpert (Ascite - Bilan de routine IPD)',
                                                                                          'Genexpert (Urine - Bilan de routine IPD)',
                                                                                          'Genexpert (Synovial - Bilan de routine IPD)',
                                                                                          'Genexpert (Crachat - Bilan de routine IPD)',
                                                                                          'Genexpert (Pleural - Bilan de routine IPD)',
                                                                                          'Genexpert (Pus - Bilan de routine IPD)',
                                                                                          'Genexpert (Ganglionnaire - Bilan de routine IPD)',
                                                                                          'Genexpert (Gastrique - Bilan de routine IPD)')
                                                  AND oTest.voided IS FALSE AND
                                                cvt.retired IS FALSE
                                           INNER JOIN concept_view cva
                                             ON cva.concept_id = oTest.value_coded AND cva.retired IS FALSE
                                    GROUP BY visit, oTest.obs_datetime
                                    ORDER BY oTest.obs_id DESC)X
                              GROUP BY X.genvalue, X.patient_id
                              ORDER BY obsdate DESC)Y
                        GROUP BY patient_id, visit
                        UNION ALL
                        SELECT person_id, visit, lamvalue, cname, obs_datetime, obs_id, encounter_id
                        FROM (SELECT o.person_id,
                                     latestEncounter.visit_id    AS visit,
                                     answer_concept.name         AS "LAMVALUE",
                                     latestEncounter.conceptName AS cname,
                                     o.obs_datetime,
                                     o.obs_id,
                                     e.encounter_id
                              FROM obs o
                                     INNER JOIN encounter e
                                       ON o.encounter_id = e.encounter_id AND e.voided IS FALSE AND o.voided IS FALSE
                                     INNER JOIN (SELECT e.visit_id,
                                                        max(e.encounter_datetime) AS `encounterTime`,
                                                        cn.concept_id,
                                                        cn.name                   AS conceptName
                                                 FROM obs o
                                                        INNER JOIN concept_name cn
                                                          ON o.concept_id = cn.concept_id AND cn.name = 'TB - LAM' AND
                                                             cn.voided IS FALSE AND
                                                             cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                             cn.locale = 'fr' AND o.voided IS FALSE
                                                        INNER JOIN encounter e
                                                          ON o.encounter_id = e.encounter_id AND e.voided IS FALSE
                                                 GROUP BY e.visit_id) latestEncounter
                                       ON latestEncounter.encounterTime = e.encounter_datetime AND
                                          o.concept_id = latestEncounter.concept_id
                                     INNER JOIN concept_name answer_concept
                                       ON o.value_coded = answer_concept.concept_id AND
                                          answer_concept.voided IS FALSE AND
                                          answer_concept.concept_name_type = 'FULLY_SPECIFIED' AND
                                          answer_concept.locale = 'fr')tbgen)AS t1
                  GROUP BY PID, visit) AS tbgenexp ON tbgenexp.PID = tbpgm.patient_id
       LEFT JOIN (/*ARV enrollment Date*/
                 SELECT pp.patient_id, date(pp.date_enrolled) AS enrolledDate
                 FROM patient_program pp
                        INNER JOIN (SELECT ARV_prog.patient_id, max(ARV_prog.date_enrolled) AS date_enrolled
                                    FROM (SELECT pp.patient_id, pp.program_id, pp.date_enrolled
                                          FROM patient_program pp
                                                 INNER JOIN program p
                                                   ON pp.program_id = p.program_id AND p.retired IS FALSE AND
                                                      pp.voided = 0 AND
                                                      p.name = 'Programme ARV') ARV_prog
                                    GROUP BY patient_id) latest_arv_prog
                          ON latest_arv_prog.patient_id = pp.patient_id AND
                             latest_arv_prog.date_enrolled = pp.date_enrolled
                        INNER JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE
                 GROUP BY patient_id) AS arvpgm ON arvpgm.patient_id = tbpgm.patient_id
       INNER JOIN person p ON tbpgm.patient_id = p.person_id
       INNER JOIN patient_identifier pi ON pi.patient_id = tbpgm.patient_id
       INNER JOIN person_name pn ON pn.person_id = p.person_id
       INNER JOIN person_attribute pa ON pa.person_id = p.person_id
       INNER JOIN person_attribute_type pad ON pad.person_attribute_type_id = pa.person_attribute_type_id
       INNER JOIN concept_name cn ON cn.concept_id = pa.value
WHERE date(tbgenexp.dateresults) BETWEEN date('2018/01/01') AND Date('2018/10/31')
  AND Date(tbpgm.tbStartDate) <= Date(tbgenexp.dateresults)
GROUP BY pi.identifier, tbgenexp.dateresults;
