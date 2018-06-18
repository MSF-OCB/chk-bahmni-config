
select
  
    pi.identifier                                   AS `ID Patient`,
    
    cohertType.name                                 AS `Type de cohorte`,
    CONCAT(pn.family_name,' ', pn.given_name)           AS `Nom`,
    floor(DATEDIFF(CURDATE(), p.birthdate) / 365)   AS `Age`,
    p.gender                                        AS `Sexe`,
    date_format(v.date_started, '%m/%d/%y')                                  AS `Date de visite`,
    date_format(prochainEncounter.value_datetime,'%m/%d/%y')                AS `Date prochain RDV`,
    date_format(diagnosticEncounter.value_datetime,'%m/%d/%y')              AS `Hist - Date diagnostic VIH`,
    regimeDebutLigne.name                           AS `Hist - Ligne ARV début`,
    date_format(regimeDebutDate.value_datetime,'%m/%d/%y')                  AS `Hist - Date début Régime`,
    regimeDebutARV.name                             AS `Hist - Régime ARV début`,
    regimeActualLigne.name                          AS `Hist - Ligne ARV actuel`,
    date_format(regimeActualDate.value_datetime,'%m/%d/%y')                 AS `Hist - Date début Régime actuel`,
    regimeActualARV.name                            AS `Hist - Régime ARV actuel`,
    prophylaxieInfo.name                            AS `Hist - Prophylaxie`,
    date_format(arvprogram.enrolledDate,'%m/%d/%y')                       AS `Date début ARV`,
    regimeDebut.name                                AS `Régime début`,
    regimeActual.name                               AS `Régime actuel`,
    arvprogram.value                            AS `Ligne ARV actuelle`,
    stadeOMS.name                                   AS `Stade OMS`,
    taille.value_numeric                            AS `Taille`,
    poids.value_numeric                             AS `Poids`,
    group_concat(distinct (diagnostic.S1),'')                               AS `Diagnostic`,
    tenir.name                                      AS `Observations et conduite à tenir`,
    infections.name                                 AS `Infections opportunistes`,
    tbProgram.tbType                                AS `Type de TB`,
    tbProgram.siteTEP                               AS `Site TB`,
    date_format(tbProgram.tbStartDate,'%m/%d/%y')                           AS `Date début Traitement`,
    Date_format(tbProgram.endDate,'%m/%d/%y')                               AS `Date fin traitement`,
    tbProgram.reason                                AS `Motif début traitement TB`,
    cd4.value                                       AS `CD4`,
    cv.value                                        AS `CV`,
    hemoglobin.value                                AS `Hemoglobine`,
    glyceme.value                                   AS `Glycémie`,
    ct.value                                AS `Créatinine`,
    gpt.value                                       AS `GPT`,
    tblam.value                                     AS `TB LAM`,
    group_concat(distinct(drugs.name) ,'')                                      AS `Traitement`,
    effects1.name                                   AS `Effets secondaires 1`,
    effects2.name                                   AS `Effets secondaires 2`,
    effects3.name                                   AS `Effets secondaires 3`
from person p
    INNER JOIN person_name pn ON p.person_id = pn.person_id AND p.voided IS FALSE AND pn.voided IS FALSE
    INNER JOIN patient_identifier pi ON pi.patient_id = pn.person_id AND pi.voided IS FALSE
    INNER JOIN(select
                   pa.person_id,
                   cn.name
               from person_attribute pa
                   INNER JOIN person_attribute_type pat on pa.person_attribute_type_id = pat.person_attribute_type_id
                                                           AND pat.retired IS FALSE AND pa.voided IS FALSE and
                                                           pat.name = 'Type de cohorte'
                   INNER JOIN concept_name cn
                       ON cn.concept_id = pa.value and cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                          cn.locale = 'fr'
              ) cohertType ON cohertType.person_id = pi.patient_id
    INNER JOIN visit v ON v.patient_id = pi.patient_id AND v.voided IS FALSE
    LEFT JOIN (select
                   o.person_id,
                   latestEncounter.visit_id,
                   o.value_datetime
               from obs o
                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                   INNER JOIN (select
                                   e.visit_id,
                                   max(e.encounter_datetime) AS `encounterTime`,
                                   cn.concept_id
                               from obs o
                                   INNER join concept_name cn
                                       on o.concept_id = cn.concept_id and cn.name = 'Date de prochain RDV' AND cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                               GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND o.concept_id = latestEncounter.concept_id
              ) prochainEncounter ON prochainEncounter.visit_id = v.visit_id and prochainEncounter.person_id = v.patient_id
    LEFT JOIN (select
                   o.person_id,
                   latestEncounter.visit_id,
                   o.value_datetime
               from obs o
                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE and o.voided is false
                   INNER JOIN (select
                                   e.visit_id,
                                   max(e.encounter_datetime) AS `encounterTime`,
                                   cn.concept_id
                               from obs o
                                   INNER join concept_name cn
                                       on o.concept_id = cn.concept_id and cn.name = 'Date diagnostic VIH(Ant)' AND cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                               GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND
                                                                       o.concept_id = latestEncounter.concept_id
              ) diagnosticEncounter ON diagnosticEncounter.visit_id = v.visit_id and diagnosticEncounter.person_id = v.patient_id
    LEFT JOIN (select
                   latestConceptFillInfoForRegmeDebutLingeARV.patient_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.concept_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.latestVisit,
                   answer.name
               from
                   (
                       select
                           e.patient_id,
                           ligneArvInfo.concept_id,
                           MAX(ligneArvInfo.obs_id) AS latestObsId,
                           MAX(ligneArvInfo.obs_group_id) AS latestObsGroupId,
                           MAX(e.encounter_datetime) AS latestEncounterDateTime,
                           e.visit_id AS latestVisit
                       from
                           (select
                                o.obs_id,
                                o.obs_group_id,
                                cn.concept_id,
                                o.encounter_id
                            from obs o
                                inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = "Ligne d'ARV" AND cn.voided IS FALSE AND
                                                              cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                           ) ligneArvInfo
                           inner join obs o2
                               on o2.obs_id = ligneArvInfo.obs_group_id and o2.encounter_id = ligneArvInfo.encounter_id and o2.voided is false
                           inner join concept_name cn on o2.concept_id = cn.concept_id and cn.name = 'Régime Début' AND cn.voided IS FALSE AND
                                                         cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
                           inner join encounter e on ligneArvInfo.encounter_id = e.encounter_id and e.voided is false
                       GROUP BY e.patient_id, e.visit_id
                   ) latestConceptFillInfoForRegmeDebutLingeARV
                   inner join obs o3 on o3.obs_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsId and
                                        o3.obs_group_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsGroupId and
                                        o3.person_id = latestConceptFillInfoForRegmeDebutLingeARV.patient_id
                   inner join concept_name answer on o3.value_coded = answer.concept_id AND answer.voided IS FALSE AND
                                                     answer.concept_name_type = 'FULLY_SPECIFIED' AND answer.locale = 'fr'
              ) regimeDebutLigne ON regimeDebutLigne.patient_id = v.patient_id AND regimeDebutLigne.latestVisit = v.visit_id
    LEFT JOIN (select
                   latestConceptFillInfoForRegmeDebutLingeARV.patient_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.concept_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.latestVisit,
                   o3.value_datetime
               from
                   (
                       select
                           e.patient_id,
                           ligneArvInfo.concept_id,
                           MAX(ligneArvInfo.obs_id) AS latestObsId,
                           MAX(ligneArvInfo.obs_group_id) AS latestObsGroupId,
                           MAX(e.encounter_datetime) AS latestEncounterDateTime,
                           e.visit_id AS latestVisit
                       from
                           (select
                                o.obs_id,
                                o.obs_group_id,
                                cn.concept_id,
                                o.encounter_id
                            from obs o
                                inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = 'HA, Date début' AND cn.voided IS FALSE AND
                                                              cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                           ) ligneArvInfo
                           inner join obs o2
                               on o2.obs_id = ligneArvInfo.obs_group_id and o2.encounter_id = ligneArvInfo.encounter_id and o2.voided is false
                           inner join concept_name cn on o2.concept_id = cn.concept_id and cn.name = 'Régime Début' AND cn.voided IS FALSE AND
                                                         cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
                           inner join encounter e on ligneArvInfo.encounter_id = e.encounter_id and e.voided is false
                       GROUP BY e.patient_id, e.visit_id
                   ) latestConceptFillInfoForRegmeDebutLingeARV
                   inner join obs o3 on o3.obs_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsId and
                                        o3.obs_group_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsGroupId and
                                        o3.person_id = latestConceptFillInfoForRegmeDebutLingeARV.patient_id
              ) regimeDebutDate ON regimeDebutDate.patient_id = v.patient_id AND regimeDebutDate.latestVisit = v.visit_id
    LEFT JOIN (select
                   latestConceptFillInfoForRegmeDebutLingeARV.patient_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.concept_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.latestVisit,
                   answer.name
               from
                   (
                       select
                           e.patient_id,
                           ligneArvInfo.concept_id,
                           MAX(ligneArvInfo.obs_id) AS latestObsId,
                           MAX(ligneArvInfo.obs_group_id) AS latestObsGroupId,
                           MAX(e.encounter_datetime) AS latestEncounterDateTime,
                           e.visit_id AS latestVisit
                       from
                           (select
                                o.obs_id,
                                o.obs_group_id,
                                cn.concept_id,
                                o.encounter_id
                            from obs o
                                inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = 'ARV' AND cn.voided IS FALSE AND
                                                              cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                           ) ligneArvInfo
                           inner join obs o2
                               on o2.obs_id = ligneArvInfo.obs_group_id and o2.encounter_id = ligneArvInfo.encounter_id and o2.voided is false
                           inner join concept_name cn on o2.concept_id = cn.concept_id and cn.name = 'Régime Début' AND cn.voided IS FALSE AND
                                                         cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
                           inner join encounter e on ligneArvInfo.encounter_id = e.encounter_id and e.voided is false
                       GROUP BY e.patient_id, e.visit_id
                   ) latestConceptFillInfoForRegmeDebutLingeARV
                   inner join obs o3 on o3.obs_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsId and
                                        o3.obs_group_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsGroupId and
                                        o3.person_id = latestConceptFillInfoForRegmeDebutLingeARV.patient_id
                   inner join concept_name answer on o3.value_coded = answer.concept_id AND answer.voided IS FALSE AND
                                                     answer.concept_name_type = 'FULLY_SPECIFIED' AND answer.locale = 'fr'
              ) regimeDebutARV ON regimeDebutARV.patient_id = v.patient_id AND regimeDebutARV.latestVisit = v.visit_id
    LEFT JOIN (select
                   latestConceptFillInfoForRegmeDebutLingeARV.patient_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.concept_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.latestVisit,
                   answer.name
               from
                   (
                       select
                           e.patient_id,
                           ligneArvInfo.concept_id,
                           MAX(ligneArvInfo.obs_id) AS latestObsId,
                           MAX(ligneArvInfo.obs_group_id) AS latestObsGroupId,
                           MAX(e.encounter_datetime) AS latestEncounterDateTime,
                           e.visit_id AS latestVisit
                       from
                           (select
                                o.obs_id,
                                o.obs_group_id,
                                cn.concept_id,
                                o.encounter_id
                            from obs o
                                inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = "Ligne d'ARV" AND cn.voided IS FALSE AND
                                                              cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                           ) ligneArvInfo
                           inner join obs o2
                               on o2.obs_id = ligneArvInfo.obs_group_id and o2.encounter_id = ligneArvInfo.encounter_id and o2.voided is false
                           inner join concept_name cn on o2.concept_id = cn.concept_id and cn.name = 'Régime actuel' AND cn.voided IS FALSE AND
                                                         cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
                           inner join encounter e on ligneArvInfo.encounter_id = e.encounter_id and e.voided is false
                       GROUP BY e.patient_id, e.visit_id
                   ) latestConceptFillInfoForRegmeDebutLingeARV
                   inner join obs o3 on o3.obs_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsId and
                                        o3.obs_group_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsGroupId and
                                        o3.person_id = latestConceptFillInfoForRegmeDebutLingeARV.patient_id
                   inner join concept_name answer on o3.value_coded = answer.concept_id AND answer.voided IS FALSE AND
                                                     answer.concept_name_type = 'FULLY_SPECIFIED' AND answer.locale = 'fr'
              ) regimeActualLigne ON regimeActualLigne.patient_id = v.patient_id AND regimeActualLigne.latestVisit = v.visit_id
    LEFT JOIN (select
                   latestConceptFillInfoForRegmeDebutLingeARV.patient_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.concept_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.latestVisit,
                   o3.value_datetime
               from
                   (
                       select
                           e.patient_id,
                           ligneArvInfo.concept_id,
                           MAX(ligneArvInfo.obs_id) AS latestObsId,
                           MAX(ligneArvInfo.obs_group_id) AS latestObsGroupId,
                           MAX(e.encounter_datetime) AS latestEncounterDateTime,
                           e.visit_id AS latestVisit
                       from
                           (select
                                o.obs_id,
                                o.obs_group_id,
                                cn.concept_id,
                                o.encounter_id
                            from obs o
                                inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = 'HA, Date début' AND cn.voided IS FALSE AND
                                                              cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                           ) ligneArvInfo
                           inner join obs o2
                               on o2.obs_id = ligneArvInfo.obs_group_id and o2.encounter_id = ligneArvInfo.encounter_id and o2.voided is false
                           inner join concept_name cn on o2.concept_id = cn.concept_id and cn.name = 'Régime actuel' AND cn.voided IS FALSE AND
                                                         cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
                           inner join encounter e on ligneArvInfo.encounter_id = e.encounter_id and e.voided is false
                       GROUP BY e.patient_id, e.visit_id
                   ) latestConceptFillInfoForRegmeDebutLingeARV
                   inner join obs o3 on o3.obs_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsId and
                                        o3.obs_group_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsGroupId and
                                        o3.person_id = latestConceptFillInfoForRegmeDebutLingeARV.patient_id
              ) regimeActualDate ON regimeActualDate.patient_id = v.patient_id AND regimeActualDate.latestVisit = v.visit_id
    LEFT JOIN (select
                   latestConceptFillInfoForRegmeDebutLingeARV.patient_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.concept_id,
                   latestConceptFillInfoForRegmeDebutLingeARV.latestVisit,
                   answer.name
               from
                   (
                       select
                           e.patient_id,
                           ligneArvInfo.concept_id,
                           MAX(ligneArvInfo.obs_id) AS latestObsId,
                           MAX(ligneArvInfo.obs_group_id) AS latestObsGroupId,
                           MAX(e.encounter_datetime) AS latestEncounterDateTime,
                           e.visit_id AS latestVisit
                       from
                           (select
                                o.obs_id,
                                o.obs_group_id,
                                cn.concept_id,
                                o.encounter_id
                            from obs o
                                inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = 'ARV' AND cn.voided IS FALSE AND
                                                              cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                           ) ligneArvInfo
                           inner join obs o2
                               on o2.obs_id = ligneArvInfo.obs_group_id and o2.encounter_id = ligneArvInfo.encounter_id and o2.voided is false
                           inner join concept_name cn on o2.concept_id = cn.concept_id and cn.name = 'Régime actuel' AND cn.voided IS FALSE AND
                                                         cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
                           inner join encounter e on ligneArvInfo.encounter_id = e.encounter_id and e.voided is false
                       GROUP BY e.patient_id, e.visit_id
                   ) latestConceptFillInfoForRegmeDebutLingeARV
                   inner join obs o3 on o3.obs_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsId and
                                        o3.obs_group_id = latestConceptFillInfoForRegmeDebutLingeARV.latestObsGroupId and
                                        o3.person_id = latestConceptFillInfoForRegmeDebutLingeARV.patient_id
                   inner join concept_name answer on o3.value_coded = answer.concept_id AND answer.voided IS FALSE AND
                                                     answer.concept_name_type = 'FULLY_SPECIFIED' AND answer.locale = 'fr'
              ) regimeActualARV ON regimeActualARV.patient_id = v.patient_id AND regimeActualARV.latestVisit = v.visit_id
    LEFT JOIN (select
                   latestConceptFillInfoForProphylaxie.patient_id,
                   latestConceptFillInfoForProphylaxie.concept_id,
                   latestConceptFillInfoForProphylaxie.latestVisit,
                   group_concat(answer.name) AS name
               from
                   (
                       select
                           e.patient_id,
                           ligneArvInfo.concept_id,
                           MAX(e.encounter_datetime) AS latestEncounterDateTime,
                           e.visit_id AS latestVisit
                       from
                           (select
                                o.obs_id,
                                o.obs_group_id,
                                cn.concept_id,
                                o.encounter_id
                            from obs o
                                inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = 'Prophylaxie' AND cn.voided IS FALSE AND
                                                              cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                           ) ligneArvInfo
                           inner join obs o2
                               on o2.obs_id = ligneArvInfo.obs_group_id and o2.encounter_id = ligneArvInfo.encounter_id and o2.voided is false
                           inner join concept_name cn on o2.concept_id = cn.concept_id and cn.name = 'Informations Prophylaxie' AND cn.voided IS FALSE AND
                                                         cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
                           inner join encounter e on ligneArvInfo.encounter_id = e.encounter_id and e.voided is false
                       GROUP BY e.patient_id, e.visit_id
                   ) latestConceptFillInfoForProphylaxie
                   inner join obs o3 on o3.person_id = latestConceptFillInfoForProphylaxie.patient_id and
                                        o3.concept_id = latestConceptFillInfoForProphylaxie.concept_id and o3.voided is false
                   inner join obs o4 on o3.obs_group_id = o4.obs_id and o4.person_id = latestConceptFillInfoForProphylaxie.patient_id and
                                        o4.voided is false
                   inner join encounter e2 on o3.encounter_id = e2.encounter_id and e2.encounter_datetime = latestConceptFillInfoForProphylaxie.latestEncounterDateTime and
                                              e2.visit_id = latestConceptFillInfoForProphylaxie.latestVisit and e2.voided is false
                   inner join concept_name cn on o4.concept_id = cn.concept_id and cn.name = 'Informations Prophylaxie' AND cn.voided IS FALSE AND
                                                 cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
                   inner join concept_name answer on o3.value_coded = answer.concept_id AND answer.voided IS FALSE AND
                                                     answer.concept_name_type = 'FULLY_SPECIFIED' AND answer.locale = 'fr'
               group by latestConceptFillInfoForProphylaxie.patient_id,
                   latestConceptFillInfoForProphylaxie.concept_id,
                   latestConceptFillInfoForProphylaxie.latestVisit
              ) prophylaxieInfo on prophylaxieInfo.patient_id = v.patient_id and prophylaxieInfo.latestVisit = v.visit_id
    LEFT JOIN ( 
    SELECT
    pp.patient_id,
    pp.date_enrolled AS enrolledDate,
    p.name           AS Pname,
    cn.name          AS value,
    vt.visit_id      AS visitid
FROM patient_program pp
    INNER JOIN
    (SELECT
         ARV_prog.patient_id,
         max(ARV_prog.date_enrolled) AS date_enrolled
     FROM (SELECT
               pp.patient_id,
               pp.program_id,
               pp.date_enrolled
           FROM patient_program pp INNER JOIN program p
                   ON pp.program_id = p.program_id AND p.retired IS FALSE AND pp.voided IS FALSE AND
                      p.name = 'Programme ARV') ARV_prog
     GROUP BY patient_id) latest_arv_prog
        ON latest_arv_prog.patient_id = pp.patient_id AND latest_arv_prog.date_enrolled = pp.date_enrolled
    INNER JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE

INNER JOIN program_workflow pw ON pw.program_id=pp.program_id
INNER JOIN program_workflow_state pws ON pws.program_workflow_id=pw.program_workflow_id
INNER JOIN patient_state ps ON ps.patient_program_id=pp.patient_program_id AND ps.state=pws.program_workflow_state_id
AND ps.voided=0 AND ps.end_date IS NULL
INNER JOIN concept_name cn ON cn.concept_id=pws.concept_id
INNER JOIN visit vt ON vt.patient_id = pp.patient_id
                                                   )as arvprogram on arvprogram.patient_id=p.person_id and arvprogram.visitid=v.visit_id
    LEFT JOIN (select
                   o.person_id,
                   latestEncounter.visit_id,
                   answer_concept.name
               from obs o
                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE AND o.voided IS FALSE
                   INNER JOIN (select
                                   e.visit_id,
                                   min(e.encounter_datetime) AS `encounterTime`,
                                   cn.concept_id
                               from obs o
                                   INNER join concept_name cn
                                       on o.concept_id = cn.concept_id and cn.name = 'RA, ARV Line' AND cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                               GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND
                                                                       o.concept_id = latestEncounter.concept_id
                   INNER JOIN concept_name answer_concept on o.value_coded = answer_concept.concept_id  AND answer_concept.voided IS FALSE AND
                                                             answer_concept.concept_name_type = 'FULLY_SPECIFIED' AND answer_concept.locale = 'fr'
              ) regimeDebut on regimeDebut.person_id = v.patient_id and regimeDebut.visit_id = v.visit_id
    LEFT JOIN (select
                   o.person_id,
                   latestEncounter.visit_id,
                   answer_concept.name
               from obs o
                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE AND o.voided IS FALSE
                   INNER JOIN (select
                                   e.visit_id,
                                   max(e.encounter_datetime) AS `encounterTime`,
                                   cn.concept_id
                               from obs o
                                   INNER join concept_name cn
                                       on o.concept_id = cn.concept_id and cn.name = 'RA, ARV Line' AND cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                               GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND
                                                                       o.concept_id = latestEncounter.concept_id
                   INNER JOIN concept_name answer_concept on o.value_coded = answer_concept.concept_id  AND answer_concept.voided IS FALSE AND
                                                             answer_concept.concept_name_type = 'FULLY_SPECIFIED' AND answer_concept.locale = 'fr'
              ) regimeActual on regimeActual.person_id = v.patient_id and regimeActual.visit_id = v.visit_id
    LEFT JOIN (select
                   o.person_id,
                   latestEncounter.visit_id,
                   answer_concept.name
               from obs o
                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE and o.voided is false
                   INNER JOIN (select
                                   e.visit_id,
                                   max(e.encounter_datetime) AS `encounterTime`,
                                   cn.concept_id
                               from obs o
                                   INNER join concept_name cn
                                       on o.concept_id = cn.concept_id and cn.name = 'Stade clinique OMS' AND cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                               GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND
                                                                       o.concept_id = latestEncounter.concept_id
                   INNER JOIN concept_name answer_concept on o.value_coded = answer_concept.concept_id  AND answer_concept.voided IS FALSE AND
                                                             answer_concept.concept_name_type = 'FULLY_SPECIFIED' AND answer_concept.locale = 'fr'
              ) stadeOMS on stadeOMS.person_id = v.patient_id and stadeOMS.visit_id = v.visit_id
    LEFT JOIN (select
                   o.person_id,
                   latestEncounter.visit_id,
                   o.value_numeric
               from obs o
                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE and o.voided is false
                   INNER JOIN (select
                                   e.visit_id,
                                   max(e.encounter_datetime) AS `encounterTime`,
                                   cn.concept_id
                               from obs o
                                   INNER join concept_name cn
                                       on o.concept_id = cn.concept_id and cn.name = 'Taille' AND cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                               GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND
                                                                       o.concept_id = latestEncounter.concept_id
              ) taille on taille.person_id = v.patient_id and taille.visit_id = v.visit_id
    LEFT JOIN (select
                   o.person_id,
                   latestEncounter.visit_id,
                   o.value_numeric
               from obs o
                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE and o.voided is false
                   INNER JOIN (select
                                   e.visit_id,
                                   max(e.encounter_datetime) AS `encounterTime`,
                                   cn.concept_id
                               from obs o
                                   INNER join concept_name cn
                                       on o.concept_id = cn.concept_id and cn.name = 'Poids' AND cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                               GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND
                                                                       o.concept_id = latestEncounter.concept_id
              ) poids on poids.person_id = v.patient_id and poids.visit_id = v.visit_id
    LEFT JOIN (
    SELECT
  firstAddSectionDateConceptInfo.person_id,
  firstAddSectionDateConceptInfo.visit_id,
  o3.value_datetime AS name,
   (select distinct name from concept_name where concept_id =o3.value_coded and locale='fr' and concept_name_type='FULLY_SPECIFIED') as "S1"
FROM
  (SELECT
     o2.person_id,
     latestVisitEncounterAndVisitForConcept.visit_id,
     MIN(o2.obs_id) AS firstAddSectionObsGroupId,
     latestVisitEncounterAndVisitForConcept.concept_id
   FROM
     (SELECT
        MAX(o.encounter_id) AS latestEncounter,
        o.person_id,
        o.concept_id,
        e.visit_id
      FROM obs o
        INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Informations Autres diagnostics (Suivi)') AND
                                      cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                      cn.locale = 'fr' AND o.voided IS FALSE
        INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
      GROUP BY e.visit_id) latestVisitEncounterAndVisitForConcept
     INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                          o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                          o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
     INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                e2.voided IS FALSE
   GROUP BY latestVisitEncounterAndVisitForConcept.visit_id) firstAddSectionDateConceptInfo
  INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
  INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Sc, Diagnostic') AND
                                 cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr') as diagnostic on diagnostic.person_id=v.patient_id
                                 and  diagnostic.visit_id=v.visit_id
                     
    LEFT JOIN (select
                   latestConceptFillInfoForTenir.patient_id,
                   latestConceptFillInfoForTenir.concept_id,
                   latestConceptFillInfoForTenir.latestVisit,
                   group_concat(o3.value_text) as name
               from
                   (
                       select
                           e.patient_id,
                           ligneArvInfo.concept_id,
                           MAX(e.encounter_datetime) AS latestEncounterDateTime,
                           e.visit_id AS latestVisit
                       from
                           (select
                                o.obs_id,
                                o.obs_group_id,
                                cn.concept_id,
                                o.encounter_id
                            from obs o
                                inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = 'Observations et conduite à tenir' AND cn.voided IS FALSE AND
                                                              cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                           ) ligneArvInfo
                           inner join encounter e on ligneArvInfo.encounter_id = e.encounter_id and e.voided is false
                       GROUP BY e.patient_id, e.visit_id
                   ) latestConceptFillInfoForTenir
                   inner join obs o3 on o3.person_id = latestConceptFillInfoForTenir.patient_id and
                                        o3.concept_id = latestConceptFillInfoForTenir.concept_id and o3.voided is false
                   inner join encounter e2 on o3.encounter_id = e2.encounter_id and e2.encounter_datetime = latestConceptFillInfoForTenir.latestEncounterDateTime and
                                              e2.visit_id = latestConceptFillInfoForTenir.latestVisit and e2.voided is false
               group by latestConceptFillInfoForTenir.patient_id,
                   latestConceptFillInfoForTenir.concept_id,
                   latestConceptFillInfoForTenir.latestVisit
              ) tenir on tenir.patient_id = v.patient_id and tenir.latestVisit = v.visit_id
    LEFT JOIN (select
                   latestConceptsFilled.patient_id,
                   latestConceptsFilled.concept_id,
                   latestConceptsFilled.latestVisit,
                   group_concat(answer.name) AS name
               from
                   (
                       select
                           e.patient_id,
                           ligneArvInfo.concept_id,
                           MAX(e.encounter_datetime) AS latestEncounterDateTime,
                           e.visit_id AS latestVisit
                       from
                           (select
                                o.obs_id,
                                o.obs_group_id,
                                cn.concept_id,
                                o.encounter_id
                            from obs o
                                inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = 'Infections Opportunistes' AND cn.voided IS FALSE AND
                                                              cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                           ) ligneArvInfo
                           inner join obs o2
                               on o2.obs_id = ligneArvInfo.obs_group_id and o2.encounter_id = ligneArvInfo.encounter_id and o2.voided is false
                           inner join concept_name cn on o2.concept_id = cn.concept_id and cn.name = 'Sc, Informations Infections opportunistes' AND cn.voided IS FALSE AND
                                                         cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
                           inner join encounter e on ligneArvInfo.encounter_id = e.encounter_id and e.voided is false
                       GROUP BY e.patient_id, e.visit_id
                   ) latestConceptsFilled
                   inner join obs o3 on o3.person_id = latestConceptsFilled.patient_id and
                                        o3.concept_id = latestConceptsFilled.concept_id and o3.voided is false
                   inner join obs o4 on o3.obs_group_id = o4.obs_id and o4.person_id = latestConceptsFilled.patient_id and
                                        o4.voided is false
                   inner join encounter e2 on o3.encounter_id = e2.encounter_id and e2.encounter_datetime = latestConceptsFilled.latestEncounterDateTime and
                                              e2.visit_id = latestConceptsFilled.latestVisit and e2.voided is false
                   inner join concept_name cn on o4.concept_id = cn.concept_id and cn.name = 'Sc, Informations Infections opportunistes' AND cn.voided IS FALSE AND
                                                 cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
                   inner join concept_name answer on o3.value_coded = answer.concept_id AND answer.voided IS FALSE AND
                                                     answer.concept_name_type = 'FULLY_SPECIFIED' AND answer.locale = 'fr'
               group by latestConceptsFilled.patient_id,
                   latestConceptsFilled.concept_id,
                   latestConceptsFilled.latestVisit
              ) infections on infections.patient_id = v.patient_id and infections.latestVisit = v.visit_id
    LEFT JOIN (SELECT
    pp.patient_id,
    pp.date_enrolled AS enrolledDate,
    p.name           AS Pname,
    vt.visit_id      AS visitid,
    pp.date_enrolled                                                                  AS  `tbStartDate`,
    group_concat(distinct(IF(pat.name = 'TB Type', cn.name, NULL )))                          AS `tbType`,
                   group_concat(distinct(IF(pat.name = 'Site TEP', cn.name, NULL )))                      AS `siteTEP`,
                 pp.date_completed    AS `endDate`,
                   group_concat(distinct(IF(pat.name = 'Motif début traitement', cn.name, NULL )))           AS `reason`
                  
    
FROM patient_program pp
    INNER JOIN
    (SELECT
         ARV_prog.patient_id,
         max(ARV_prog.date_enrolled) AS date_enrolled
     FROM (SELECT
               pp.patient_id,
               pp.program_id,
               pp.date_enrolled
           FROM patient_program pp INNER JOIN program p
                   ON pp.program_id = p.program_id AND p.retired IS FALSE AND pp.voided IS FALSE AND
                      p.name = 'Programme TB') ARV_prog
     GROUP BY patient_id) latest_arv_prog
        ON latest_arv_prog.patient_id = pp.patient_id AND latest_arv_prog.date_enrolled = pp.date_enrolled
    INNER JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE

INNER JOIN program_workflow pw ON pw.program_id=pp.program_id
INNER JOIN patient_program_attribute ppa ON ppa.patient_program_id = pp.patient_program_id AND ppa.voided IS FALSE
INNER JOIN program_attribute_type pat ON ppa.attribute_type_id = pat.program_attribute_type_id AND pat.retired IS FALSE
INNER JOIN program_workflow_state pws ON pws.program_workflow_id=pw.program_workflow_id
INNER JOIN patient_state ps ON ps.patient_program_id=pp.patient_program_id AND ps.state=pws.program_workflow_state_id
AND ps.voided=0 AND ps.end_date IS NULL
inner JOIN concept_name cn ON cn.concept_id=ppa.value_reference
INNER JOIN visit vt ON vt.patient_id = pp.patient_id and cn.concept_name_type='SHORT'
group by patient_id,visit_id,enrolledDate


              ) tbProgram on tbProgram.patient_id = p.person_id
    LEFT JOIN 
    (
    SELECT
                                  o.encounter_id,
                                  o.patient_id as patientid,
                                  drug.name as name,
                                  visit_id as visitid
                              from orders o
                                  INNER JOIN drug_order ON drug_order.order_id = o.order_id AND o.voided IS FALSE
                                  INNER JOIN drug ON drug_order.drug_inventory_id = drug.drug_id AND drug.retired IS FALSE
                                  inner join visit v on v.patient_id=o.patient_id
                                  
    ) as drugs on drugs.patientid=p.person_id and drugs.visitid=v.visit_id
    LEFT JOIN (SELECT
                   firstAddSection.patient_id,
                   firstAddSection.latestVisit,
                   CONCAT_WS(',', group_concat(o5.value_text), group_concat(answer.name)) AS `name`
               FROM
                   (SELECT
                        latestConceptFillInfoForTenir.patient_id,
                        latestVisit,
                        latestEncounterDateTime,
                        MIN(o4.obs_group_id) AS firstAddSectionGroupId
                    FROM
                        (select
                             e.patient_id,
                             ligneArvInfo.concept_id,
                             MAX(e.encounter_datetime) AS latestEncounterDateTime,
                             e.visit_id AS latestVisit
                         from
                             (select
                                  o.obs_id,
                                  o.obs_group_id,
                                  cn.concept_id,
                                  o.encounter_id
                              from obs o
                                  inner join concept_name cn on o.concept_id = cn.concept_id and
                                                                cn.name in ('Effets secondaires - médicaments') AND cn.voided IS FALSE AND
                                                                cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                             ) ligneArvInfo
                             inner join encounter e on ligneArvInfo.encounter_id = e.encounter_id and e.voided is false
                             inner join obs o2 on e.encounter_id = o2.encounter_id and o2.obs_group_id = ligneArvInfo.obs_id and
                                                  o2.voided is false
                         GROUP BY e.patient_id, e.visit_id
                        ) latestConceptFillInfoForTenir
                        inner join obs o3 on o3.person_id = latestConceptFillInfoForTenir.patient_id and
                                             o3.concept_id = latestConceptFillInfoForTenir.concept_id and o3.voided is false
                        inner join obs o4 on o4.obs_group_id = o3.obs_id and o4.voided is false
                        inner join encounter e2 on o3.encounter_id = e2.encounter_id and o4.encounter_id = e2.encounter_id and
                                                   e2.encounter_datetime = latestConceptFillInfoForTenir.latestEncounterDateTime and
                                                   e2.visit_id = latestConceptFillInfoForTenir.latestVisit and e2.voided is false
                    GROUP BY latestConceptFillInfoForTenir.patient_id,
                        latestConceptFillInfoForTenir.latestVisit,
                        latestConceptFillInfoForTenir.latestEncounterDateTime) firstAddSection
                   INNER JOIN obs o5 ON firstAddSection.firstAddSectionGroupId = o5.obs_group_id AND o5.voided IS FALSE
                   LEFT JOIN concept_name answer on o5.value_coded = answer.concept_id and answer.voided IS FALSE AND
                                                    answer.concept_name_type = 'SHORT' AND answer.locale = 'fr' and answer.voided IS FALSE
               GROUP BY firstAddSection.patient_id, firstAddSection.latestVisit
              ) effects1 on effects1.patient_id = v.patient_id and effects1.latestVisit = v.visit_id
    LEFT JOIN (SELECT
                   secondAddSection.patient_id,
                   secondAddSection.latestVisit,
                   secondAddSection.secondAddSectionGroupId,
                   CONCAT_WS(',', group_concat(o6.value_text), group_concat(answer.name)) AS `name`
               FROM
                   (SELECT
                        firstAddSection.patient_id,
                        firstAddSection.latestEncounterDateTime,
                        firstAddSection.latestVisit,
                        firstAddSection.concept_id,
                        firstAddSection.firstAddSectionGroupId,
                        MIN(o5.obs_group_id) AS secondAddSectionGroupId
                    FROM
                        (SELECT
                             latestConceptFillInfoForTenir.patient_id,
                             latestConceptFillInfoForTenir.concept_id,
                             latestVisit,
                             latestEncounterDateTime,
                             MIN(o4.obs_group_id) AS firstAddSectionGroupId
                         FROM
                             (SELECT
                                  e.patient_id,
                                  ligneArvInfo.concept_id,
                                  MAX(e.encounter_datetime) AS latestEncounterDateTime,
                                  e.visit_id                AS latestVisit
                              FROM
                                  (SELECT
                                       o.obs_id,
                                       o.obs_group_id,
                                       cn.concept_id,
                                       o.encounter_id
                                   FROM obs o
                                       INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND
                                                                     cn.name IN ('Effets secondaires - médicaments') AND cn.voided IS FALSE AND
                                                                     cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' AND
                                                                     o.voided IS FALSE
                                  ) ligneArvInfo
                                  INNER JOIN encounter e ON ligneArvInfo.encounter_id = e.encounter_id AND e.voided IS FALSE
                                  INNER JOIN obs o2 ON e.encounter_id = o2.encounter_id AND o2.obs_group_id = ligneArvInfo.obs_id AND
                                                       o2.voided IS FALSE
                              GROUP BY e.patient_id, e.visit_id
                             ) latestConceptFillInfoForTenir
                             INNER JOIN obs o3 ON o3.person_id = latestConceptFillInfoForTenir.patient_id AND
                                                  o3.concept_id = latestConceptFillInfoForTenir.concept_id AND o3.voided IS FALSE
                             INNER JOIN obs o4 ON o4.obs_group_id = o3.obs_id AND o4.voided IS FALSE
                             INNER JOIN encounter e2 ON o3.encounter_id = e2.encounter_id AND o4.encounter_id = e2.encounter_id AND
                                                        e2.encounter_datetime = latestConceptFillInfoForTenir.latestEncounterDateTime AND
                                                        e2.visit_id = latestConceptFillInfoForTenir.latestVisit AND e2.voided IS FALSE
                         GROUP BY latestConceptFillInfoForTenir.patient_id,
                             latestConceptFillInfoForTenir.latestVisit,
                             latestConceptFillInfoForTenir.latestEncounterDateTime) firstAddSection
                        INNER JOIN obs o5 ON firstAddSection.firstAddSectionGroupId < o5.obs_group_id AND
                                             firstAddSection.patient_id = o5.person_id AND o5.voided IS FALSE
                        INNER JOIN encounter e3 ON firstAddSection.latestEncounterDateTime = e3.encounter_datetime AND
                                                   o5.encounter_id = e3.encounter_id AND
                                                   firstAddSection.latestVisit = e3.visit_id AND e3.voided IS FALSE
                        INNER JOIN concept_name cn2 ON cn2.concept_id = o5.concept_id AND cn2.name IN ('Molecule', 'Side effects', 'Rank, Monitoring') AND cn2.voided IS FALSE AND
                                                       cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                    GROUP BY firstAddSection.patient_id, firstAddSection.latestVisit
                   )secondAddSection
                   INNER JOIN obs o6 ON o6.obs_group_id = secondAddSection.secondAddSectionGroupId AND
                                        o6.person_id = secondAddSection.patient_id AND o6.voided IS FALSE
                   LEFT JOIN concept_name answer ON o6.value_coded = answer.concept_id AND answer.voided IS FALSE AND
                                                    answer.concept_name_type = 'SHORT' AND answer.locale = 'fr' AND
                                                    answer.voided IS FALSE
               GROUP BY secondAddSection.patient_id,
                   secondAddSection.latestVisit,
                   secondAddSection.secondAddSectionGroupId
              ) effects2 on effects2.patient_id = v.patient_id and effects2.latestVisit = v.visit_id
    LEFT JOIN (SELECT
                   thirdAddSection.patient_id,
                   thirdAddSection.latestVisit,
                   thirdAddSection.thirdAddSectionGroupId,
                   CONCAT_WS(',', group_concat(o6.value_text), group_concat(answer.name)) AS `name`
               FROM
                   (SELECT
                        secondAddSection.patient_id,
                        secondAddSection.latestEncounterDateTime,
                        secondAddSection.latestVisit,
                        secondAddSection.concept_id,
                        secondAddSection.firstAddSectionGroupId,
                        secondAddSection.secondAddSectionGroupId,
                        MIN(o5.obs_group_id) AS thirdAddSectionGroupId
                    FROM
                        (SELECT
                             firstAddSection.patient_id,
                             firstAddSection.latestEncounterDateTime,
                             firstAddSection.latestVisit,
                             firstAddSection.concept_id,
                             firstAddSection.firstAddSectionGroupId,
                             MIN(o5.obs_group_id) AS secondAddSectionGroupId
                         FROM
                             (SELECT
                                  latestConceptFillInfoForTenir.patient_id,
                                  latestConceptFillInfoForTenir.concept_id,
                                  latestVisit,
                                  latestEncounterDateTime,
                                  MIN(o4.obs_group_id) AS firstAddSectionGroupId
                              FROM
                                  (SELECT
                                       e.patient_id,
                                       ligneArvInfo.concept_id,
                                       MAX(e.encounter_datetime) AS latestEncounterDateTime,
                                       e.visit_id                AS latestVisit
                                   FROM
                                       (SELECT
                                            o.obs_id,
                                            o.obs_group_id,
                                            cn.concept_id,
                                            o.encounter_id
                                        FROM obs o
                                            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND
                                                                          cn.name IN ('Effets secondaires - médicaments') AND cn.voided IS FALSE AND
                                                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' AND
                                                                          o.voided IS FALSE
                                       ) ligneArvInfo
                                       INNER JOIN encounter e ON ligneArvInfo.encounter_id = e.encounter_id AND e.voided IS FALSE
                                       INNER JOIN obs o2 ON e.encounter_id = o2.encounter_id AND o2.obs_group_id = ligneArvInfo.obs_id AND
                                                            o2.voided IS FALSE
                                   GROUP BY e.patient_id, e.visit_id
                                  ) latestConceptFillInfoForTenir
                                  INNER JOIN obs o3 ON o3.person_id = latestConceptFillInfoForTenir.patient_id AND
                                                       o3.concept_id = latestConceptFillInfoForTenir.concept_id AND o3.voided IS FALSE
                                  INNER JOIN obs o4 ON o4.obs_group_id = o3.obs_id AND o4.voided IS FALSE
                                  INNER JOIN encounter e2 ON o3.encounter_id = e2.encounter_id AND o4.encounter_id = e2.encounter_id AND
                                                             e2.encounter_datetime = latestConceptFillInfoForTenir.latestEncounterDateTime AND
                                                             e2.visit_id = latestConceptFillInfoForTenir.latestVisit AND e2.voided IS FALSE
                              GROUP BY latestConceptFillInfoForTenir.patient_id,
                                  latestConceptFillInfoForTenir.latestVisit,
                                  latestConceptFillInfoForTenir.latestEncounterDateTime) firstAddSection
                             INNER JOIN obs o5 ON firstAddSection.firstAddSectionGroupId < o5.obs_group_id AND
                                                  firstAddSection.patient_id = o5.person_id AND o5.voided IS FALSE
                             INNER JOIN encounter e3 ON firstAddSection.latestEncounterDateTime = e3.encounter_datetime AND
                                                        o5.encounter_id = e3.encounter_id AND
                                                        firstAddSection.latestVisit = e3.visit_id AND e3.voided IS FALSE
                             INNER JOIN concept_name cn2 ON cn2.concept_id = o5.concept_id AND cn2.name IN ('Molecule', 'Side effects', 'Rank, Monitoring') AND cn2.voided IS FALSE AND
                                                            cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                         GROUP BY firstAddSection.patient_id, firstAddSection.latestVisit)secondAddSection
                        INNER JOIN obs o5 ON secondAddSection.secondAddSectionGroupId < o5.obs_group_id AND
                                             secondAddSection.patient_id = o5.person_id AND o5.voided IS FALSE
                        INNER JOIN encounter e3 ON secondAddSection.latestEncounterDateTime = e3.encounter_datetime AND
                                                   o5.encounter_id = e3.encounter_id AND
                                                   secondAddSection.latestVisit = e3.visit_id AND e3.voided IS FALSE
                        INNER JOIN concept_name cn2 ON cn2.concept_id = o5.concept_id AND cn2.name IN ('Molecule', 'Side effects', 'Rank, Monitoring') AND cn2.voided IS FALSE AND
                                                       cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                    GROUP BY secondAddSection.patient_id, secondAddSection.latestVisit)thirdAddSection
                   INNER JOIN obs o6 ON o6.obs_group_id = thirdAddSection.thirdAddSectionGroupId AND
                                        o6.person_id = thirdAddSection.patient_id AND o6.voided IS FALSE
                   LEFT JOIN concept_name answer ON o6.value_coded = answer.concept_id AND answer.voided IS FALSE AND
                                                    answer.concept_name_type = 'SHORT' AND answer.locale = 'fr' AND
                                                    answer.voided IS FALSE
               GROUP BY thirdAddSection.patient_id,
                   thirdAddSection.latestVisit,
                   thirdAddSection.secondAddSectionGroupId
              ) effects3 on effects3.patient_id = v.patient_id and effects3.latestVisit = v.visit_id
    LEFT JOIN (SELECT
                   o.person_id,
                   v.visit_id,
                   o.value_numeric AS value
               FROM obs o INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND o.voided IS FALSE AND e.voided IS FALSE
                   INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided IS FALSE
                   INNER JOIN concept_view cv ON cv.concept_id = o.concept_id AND cv.retired IS FALSE AND
                                                 cv.concept_full_name IN ('Résultat(Numérique)', 'CD4')
                                                 AND o.value_numeric IS NOT NULL
                   INNER JOIN (SELECT
                                   v.visit_id,
                                   max(cd4_obs.obs_datetime) AS cd4_obsDateTime
                               FROM visit v INNER JOIN encounter e
                                       ON e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                                   INNER JOIN
                                   ((SELECT
                                         o.encounter_id,
                                         o.person_id,
                                         o.obs_datetime,
                                         o.value_numeric,
                                         o.concept_id
                                     FROM obs o INNER JOIN (SELECT o.obs_group_id
                                                            FROM obs o INNER JOIN concept_view cv_q ON o.concept_id = cv_q.concept_id
                                                                                                       AND o.voided IS FALSE AND
                                                                                                       cv_q.retired IS FALSE AND
                                                                                                       cv_q.concept_full_name IN
                                                                                                       ('Tests')
                                                                INNER JOIN concept_view cv_ans
                                                                    ON cv_ans.concept_id = o.value_coded AND cv_ans.retired IS FALSE
                                                                       AND cv_ans.concept_full_name IN ('CD4(cells/µl)')
                                                           ) parent_obs ON parent_obs.obs_group_id = o.obs_group_id
                                         INNER JOIN
                                         concept_view cv_result
                                             ON cv_result.concept_id = o.concept_id AND cv_result.retired IS FALSE AND
                                                cv_result.concept_full_name IN ('Résultat(Numérique)'))

                                    UNION
                                    (SELECT
                                         o.encounter_id,
                                         o.person_id,
                                         o.obs_datetime,
                                         o.value_numeric,
                                         o.concept_id
                                     FROM obs o INNER JOIN concept_view cv_cd4
                                             ON cv_cd4.concept_id = o.concept_id AND o.voided IS FALSE AND cv_cd4.retired IS FALSE AND
                                                cv_cd4.concept_full_name IN ('CD4') AND o.value_numeric IS NOT NULL)) cd4_obs
                                       ON cd4_obs.encounter_id = e.encounter_id
                               GROUP BY v.visit_id) latest_obs_cd4
                       ON latest_obs_cd4.cd4_obsDateTime = o.obs_datetime AND latest_obs_cd4.visit_id = v.visit_id) cd4 ON cd4.person_id = v.patient_id AND cd4.visit_id = v.visit_id
    LEFT JOIN (SELECT
                   o.person_id,
                   v.visit_id,
                   o.value_numeric AS value
               FROM obs o INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND o.voided IS FALSE AND e.voided IS FALSE
                   INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided IS FALSE
                   INNER JOIN concept_view cv ON cv.concept_id = o.concept_id AND cv.retired IS FALSE AND
                                                 cv.concept_full_name IN ('Charge Virale HIV - Value','Charge Virale - Value(Bilan de routine IPD)')
                                                 AND o.value_numeric IS NOT NULL
                   INNER JOIN (SELECT
                                   v.visit_id,
                                   max(test_obs.obs_datetime) AS test_obsDateTime
                               FROM visit v INNER JOIN encounter e
                                       ON e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                                   INNER JOIN
                                   (
                                       (SELECT
                                            o.encounter_id,
                                            o.person_id,
                                            o.obs_datetime,
                                            o.value_numeric,
                                            o.concept_id
                                        FROM obs o INNER JOIN concept_view cv_test
                                                ON cv_test.concept_id = o.concept_id AND o.voided IS FALSE AND cv_test.retired IS FALSE AND
                                                   cv_test.concept_full_name IN ('Charge Virale HIV - Value', 'Charge Virale - Value(Bilan de routine IPD)') AND o.value_numeric IS NOT NULL)) test_obs
                                       ON test_obs.encounter_id = e.encounter_id
                               GROUP BY v.visit_id) latest_obs_cv
                       ON latest_obs_cv.test_obsDateTime = o.obs_datetime AND latest_obs_cv.visit_id = v.visit_id) cv ON cv.person_id = v.patient_id AND cv.visit_id = v.visit_id
    LEFT JOIN (SELECT
                   o.person_id,
                   v.visit_id,
                   o.value_numeric AS value
               FROM obs o INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND o.voided IS FALSE AND e.voided IS FALSE
                   INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided IS FALSE
                   INNER JOIN concept_view cv ON cv.concept_id = o.concept_id AND cv.retired IS FALSE AND
                                                 cv.concept_full_name IN ('Résultat(Numérique)', 'Hemoglobine(Bilan de routine IPD)', 'Hemoglobine')
                                                 AND o.value_numeric IS NOT NULL
                   INNER JOIN (SELECT
                                   v.visit_id,
                                   max(test_obs.obs_datetime) AS test_obsDateTime
                               FROM visit v INNER JOIN encounter e
                                       ON e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                                   INNER JOIN
                                   ((SELECT
                                         o.encounter_id,
                                         o.person_id,
                                         o.obs_datetime,
                                         o.value_numeric,
                                         o.concept_id
                                     FROM obs o INNER JOIN (SELECT o.obs_group_id
                                                            FROM obs o INNER JOIN concept_view cv_q ON o.concept_id = cv_q.concept_id
                                                                                                       AND o.voided IS FALSE AND
                                                                                                       cv_q.retired IS FALSE AND
                                                                                                       cv_q.concept_full_name IN
                                                                                                       ('Tests')
                                                                INNER JOIN concept_view cv_ans
                                                                    ON cv_ans.concept_id = o.value_coded AND cv_ans.retired IS FALSE
                                                                       AND cv_ans.concept_full_name IN ('Hémoglobine (Hemocue)(g/dl)')
                                                           ) parent_obs ON parent_obs.obs_group_id = o.obs_group_id
                                         INNER JOIN
                                         concept_view cv_result
                                             ON cv_result.concept_id = o.concept_id AND cv_result.retired IS FALSE AND
                                                cv_result.concept_full_name IN ('Résultat(Numérique)'))

                                    UNION
                                    (SELECT
                                         o.encounter_id,
                                         o.person_id,
                                         o.obs_datetime,
                                         o.value_numeric,
                                         o.concept_id
                                     FROM obs o INNER JOIN concept_view cv_test
                                             ON cv_test.concept_id = o.concept_id AND o.voided IS FALSE AND cv_test.retired IS FALSE AND
                                                cv_test.concept_full_name IN ('Hemoglobine(Bilan de routine IPD)', 'Hemoglobine') AND o.value_numeric IS NOT NULL)) test_obs
                                       ON test_obs.encounter_id = e.encounter_id
                               GROUP BY v.visit_id) latest_obs_test
                       ON latest_obs_test.test_obsDateTime = o.obs_datetime AND latest_obs_test.visit_id = v.visit_id) hemoglobin ON hemoglobin.person_id = v.patient_id AND hemoglobin.visit_id = v.visit_id
    LEFT JOIN (SELECT
                   o.person_id,
                   v.visit_id,
                   o.value_numeric AS value
               FROM obs o INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND o.voided IS FALSE AND e.voided IS FALSE
                   INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided IS FALSE
                   INNER JOIN concept_view cv ON cv.concept_id = o.concept_id AND cv.retired IS FALSE AND
                                                 cv.concept_full_name IN ('Résultat(Numérique)', 'Glycémie')
                                                 AND o.value_numeric IS NOT NULL
                   INNER JOIN (SELECT
                                   v.visit_id,
                                   max(test_obs.obs_datetime) AS test_obsDateTime
                               FROM visit v INNER JOIN encounter e
                                       ON e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                                   INNER JOIN
                                   ((SELECT
                                         o.encounter_id,
                                         o.person_id,
                                         o.obs_datetime,
                                         o.value_numeric,
                                         o.concept_id
                                     FROM obs o INNER JOIN (SELECT o.obs_group_id
                                                            FROM obs o INNER JOIN concept_view cv_q ON o.concept_id = cv_q.concept_id
                                                                                                       AND o.voided IS FALSE AND
                                                                                                       cv_q.retired IS FALSE AND
                                                                                                       cv_q.concept_full_name IN
                                                                                                       ('Tests')
                                                                INNER JOIN concept_view cv_ans
                                                                    ON cv_ans.concept_id = o.value_coded AND cv_ans.retired IS FALSE
                                                                       AND cv_ans.concept_full_name IN ('Glycémie(mg/dl)')
                                                           ) parent_obs ON parent_obs.obs_group_id = o.obs_group_id
                                         INNER JOIN
                                         concept_view cv_result
                                             ON cv_result.concept_id = o.concept_id AND cv_result.retired IS FALSE AND
                                                cv_result.concept_full_name IN ('Résultat(Numérique)'))

                                    UNION
                                    (SELECT
                                         o.encounter_id,
                                         o.person_id,
                                         o.obs_datetime,
                                         o.value_numeric,
                                         o.concept_id
                                     FROM obs o INNER JOIN concept_view cv_test
                                             ON cv_test.concept_id = o.concept_id AND o.voided IS FALSE AND cv_test.retired IS FALSE AND
                                                cv_test.concept_full_name IN ('Glycémie') AND o.value_numeric IS NOT NULL)) test_obs
                                       ON test_obs.encounter_id = e.encounter_id
                               GROUP BY v.visit_id) latest_obs_test
                       ON latest_obs_test.test_obsDateTime = o.obs_datetime AND latest_obs_test.visit_id = v.visit_id) glyceme ON glyceme.person_id = v.patient_id AND glyceme.visit_id = v.visit_id
    LEFT JOIN (SELECT
                   o.person_id,
                   v.visit_id,
                   o.value_numeric AS value
               FROM obs o INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND o.voided IS FALSE AND e.voided IS FALSE
                   INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided IS FALSE
                   INNER JOIN concept_view cv ON cv.concept_id = o.concept_id AND cv.retired IS FALSE AND
                                                 cv.concept_full_name in('Créatinine(Bilan de routine IPD)','Creatinine')
                                                 
                                                 AND o.value_numeric IS NOT NULL
                   INNER JOIN (SELECT
                                   v.visit_id,
                                   max(test_obs.obs_datetime) AS test_obsDateTime
                               FROM visit v INNER JOIN encounter e
                                       ON e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                                   INNER JOIN
                                   (
                                       (SELECT
                                            o.encounter_id,
                                            o.person_id,
                                            o.obs_datetime,
                                            o.value_numeric,
                                            o.concept_id
                                        FROM obs o INNER JOIN concept_view cv_test
                                                ON cv_test.concept_id = o.concept_id AND o.voided IS FALSE AND cv_test.retired IS FALSE AND
                                                   cv_test.concept_full_name in ('Créatinine(Bilan de routine IPD)','Creatinine')
                                                    AND o.value_numeric IS NOT NULL)) test_obs
                                       ON test_obs.encounter_id = e.encounter_id
                               GROUP BY v.visit_id) as creatine) as ct on ct.person_id=p.person_id and ct.visit_id=v.visit_id
                      
    LEFT JOIN (SELECT
                   o.person_id,
                   v.visit_id,
                   o.value_numeric AS value
               FROM obs o INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND o.voided IS FALSE AND e.voided IS FALSE
                   INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided IS FALSE
                   INNER JOIN concept_view cv ON cv.concept_id = o.concept_id AND cv.retired IS FALSE AND
                                                 cv.concept_full_name IN ('GPT')
                                                 AND o.value_numeric IS NOT NULL
                   INNER JOIN (SELECT
                                   v.visit_id,
                                   max(test_obs.obs_datetime) AS test_obsDateTime
                               FROM visit v INNER JOIN encounter e
                                       ON e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                                   INNER JOIN
                                   (
                                       (SELECT
                                            o.encounter_id,
                                            o.person_id,
                                            o.obs_datetime,
                                            o.value_numeric,
                                            o.concept_id
                                        FROM obs o INNER JOIN concept_view cv_test
                                                ON cv_test.concept_id = o.concept_id AND o.voided IS FALSE AND cv_test.retired IS FALSE AND
                                                   cv_test.concept_full_name IN ('GPT') AND o.value_numeric IS NOT NULL)) test_obs
                                       ON test_obs.encounter_id = e.encounter_id
                               GROUP BY v.visit_id) latest_obs_test
                       ON latest_obs_test.test_obsDateTime = o.obs_datetime AND latest_obs_test.visit_id = v.visit_id) gpt ON gpt.person_id = v.patient_id AND gpt.visit_id = v.visit_id
    LEFT JOIN (SELECT
                   o.person_id,
                   v.visit_id,
                   cv_ans.concept_full_name AS value
               FROM obs o INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND o.voided IS FALSE AND e.voided IS FALSE
                   INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided IS FALSE
                   INNER JOIN concept_view cv ON cv.concept_id = o.concept_id AND cv.retired IS FALSE AND
                                                 cv.concept_full_name IN ('Résultat(Option)')
                   INNER JOIN concept_view cv_ans ON cv_ans.concept_id = o.value_coded AND cv_ans.retired IS FALSE
                   INNER JOIN (SELECT
                                   v.visit_id,
                                   max(test_obs.obs_datetime) AS test_obsDateTime
                               FROM visit v INNER JOIN encounter e
                                       ON e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                                   INNER JOIN
                                   ((SELECT
                                         o.encounter_id,
                                         o.person_id,
                                         o.obs_datetime,
                                         o.concept_id
                                     FROM obs o INNER JOIN (SELECT o.obs_group_id
                                                            FROM obs o INNER JOIN concept_view cv_q ON o.concept_id = cv_q.concept_id
                                                                                                       AND o.voided IS FALSE AND
                                                                                                       cv_q.retired IS FALSE AND
                                                                                                       cv_q.concept_full_name IN
                                                                                                       ('Tests')
                                                                INNER JOIN concept_view cv_ans
                                                                    ON cv_ans.concept_id = o.value_coded AND cv_ans.retired IS FALSE
                                                                       AND cv_ans.concept_full_name IN ('TB - LAM')
                                                           ) parent_obs ON parent_obs.obs_group_id = o.obs_group_id
                                         INNER JOIN
                                         concept_view cv_result
                                             ON cv_result.concept_id = o.concept_id AND cv_result.retired IS FALSE AND
                                                cv_result.concept_full_name IN ('Résultat(Option)'))

                                   ) test_obs
                                       ON test_obs.encounter_id = e.encounter_id
                               GROUP BY v.visit_id) latest_obs_test
                       ON latest_obs_test.test_obsDateTime = o.obs_datetime AND latest_obs_test.visit_id = v.visit_id) tblam ON tblam.person_id = v.patient_id AND tblam.visit_id = v.visit_id
where  date(v.date_created) between '#startDate#' AND '#endDate#'  group by v.visit_id  ;
