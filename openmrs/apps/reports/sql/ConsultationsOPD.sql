select
  p.person_id,
  pi.identifier                                   AS `ID Patient`,
  cohertType.name                                 AS `Type de cohorte`,
  CONCAT(pn.family_name,' ', pn.given_name)           AS `Nom`,
  floor(DATEDIFF(CURDATE(), p.birthdate) / 365)   AS `Age`,
  p.gender                                        AS `Sexe`,
  v.date_started                                  AS `Date de visite`,
  prochainEncounter.value_datetime                AS `Date prochain RDV`,
  diagnosticEncounter.value_datetime              AS `Hist - Date diagnostic ARV`,
  regimeDebutLigne.name                           AS `Hist - Ligne ARV début`,
  regimeDebutDate.value_datetime                  AS `Hist - Date début Régime`,
  regimeDebutARV.name                             AS `Hist - Régime ARV début`,
  regimeActualLigne.name                          AS `Hist - Ligne ARV actuel`,
  regimeActualDate.value_datetime                 AS `Hist - Date début Régime actuel`,
  regimeActualARV.name                            AS `Hist - Régime ARV actuel`,
  prophylaxieInfo.name                            AS `Hist - Prophylaxie`,
  arvProgram.arvStartDate                         AS `Date début ARV`,
  regimeDebut.name                                AS `Régime début`,
  regimeActual.name                               AS `Régime actuel`,
  arvProgram.arvLine                              AS `Ligne ARV actuelle`,
  stadeOMS.name                                   AS `Stade OMS`,
  taille.value_numeric                            AS `Taille`,
  poids.value_numeric                             AS `Poids`,
  diagnostic.name                                 AS `Diagnostic`,
  tenir.name                                      AS `Observations et conduite à tenir`,
  infections.name                                 AS `Infections opportunistes`,
  tbProgram.tbType                                AS `Type de TB`,
  tbProgram.siteTEP                               AS `Site TB`,
  tbProgram.tbStartDate                           AS `Date début Traitement`,
  tbProgram.endDate                               AS `Date fin traitement`,
  tbProgram.reason                                AS `Motif début traitement TB`,
  drugs.name                                      AS `Traitement`
from person p
  INNER JOIN person_name pn ON p.person_id = pn.person_id AND p.voided IS FALSE AND pn.voided IS FALSE
  INNER JOIN patient_identifier pi ON pi.patient_id = pn.person_id AND pi.voided IS FALSE
  INNER JOIN
  (select
     pa.person_id,
     cn.name
   from person_attribute pa
     INNER JOIN person_attribute_type pat on pa.person_attribute_type_id = pat.person_attribute_type_id
                                             AND pat.retired IS FALSE AND pa.voided IS FALSE and
                                             pat.name = 'Type de cohorte'
     INNER JOIN concept_name cn
       ON cn.concept_id = pa.value and cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
          cn.locale = 'fr') cohertType ON
                                         cohertType.person_id = pi.patient_id

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
                               on o.concept_id = cn.concept_id and cn.name = 'Date diagnostic ARV' AND cn.voided IS FALSE AND
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
                      inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = 'Ligne d\'ARV' AND cn.voided IS FALSE AND
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
                      inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = 'Ligne d\'ARV' AND cn.voided IS FALSE AND
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
  LEFT JOIN (SELECT
               pp.patient_id,
               pp.date_enrolled         AS  `arvStartDate`,
               ppcn.name                AS `arvLine`
             from patient_program pp
               INNER JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE AND date_completed IS NULL AND voided IS FALSE
               INNER JOIN concept_name cn ON p.concept_id = cn.concept_id AND cn.name = 'Programme ARV'
                                             AND cn.voided IS FALSE AND cn.concept_name_type='FULLY_SPECIFIED'
                                             AND cn.locale = 'fr'
               INNER JOIN patient_program_attribute ppa ON ppa.patient_program_id = pp.patient_program_id AND ppa.voided IS FALSE
               INNER JOIN program_attribute_type pat ON ppa.attribute_type_id = pat.program_attribute_type_id AND pat.retired IS FALSE
                                                        AND pat.name = 'ARV Line(Programme)'
               INNER JOIN concept_name ppcn ON ppa.value_reference = ppcn.concept_id AND ppcn.concept_name_type='SHORT'
                                               AND ppcn.locale = 'fr'
            ) arvProgram on arvProgram.patient_id = p.person_id
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
                      inner join concept_name cn on o.concept_id = cn.concept_id and cn.name = 'Sc, Diagnostic' AND cn.voided IS FALSE AND
                                                    cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                   ) ligneArvInfo
                   inner join obs o2
                     on o2.obs_id = ligneArvInfo.obs_group_id and o2.encounter_id = ligneArvInfo.encounter_id and o2.voided is false
                   inner join concept_name cn on o2.concept_id = cn.concept_id and cn.name = 'Information Diagnostique' AND cn.voided IS FALSE AND
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
               inner join concept_name cn on o4.concept_id = cn.concept_id and cn.name = 'Information Diagnostique' AND cn.voided IS FALSE AND
                                             cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr'
               inner join concept_name answer on o3.value_coded = answer.concept_id AND answer.voided IS FALSE AND
                                                 answer.concept_name_type = 'FULLY_SPECIFIED' AND answer.locale = 'fr'
             group by latestConceptsFilled.patient_id,
               latestConceptsFilled.concept_id,
               latestConceptsFilled.latestVisit
            ) diagnostic on diagnostic.patient_id = v.patient_id and diagnostic.latestVisit = v.visit_id
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
               pp.date_enrolled                                                                  AS  `tbStartDate`,
               group_concat(IF(pat.name = 'TB Type', ppcn.name, NULL ))                          AS `tbType`,
               group_concat(IF(pat.name = 'Site TEP', ppcn.name, NULL ))                         AS `siteTEP`,
               group_concat(IF(pat.name = 'End Date for Program', ppa.value_reference, NULL ))   AS `endDate`,
               group_concat(IF(pat.name = 'Motif début traitement', ppcn.name, NULL ))           AS `reason`
             from patient_program pp
               INNER JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE AND date_completed IS NULL AND voided IS FALSE
               INNER JOIN concept_name cn ON p.concept_id = cn.concept_id AND cn.name = 'Programme TB'
                                             AND cn.voided IS FALSE AND cn.concept_name_type='FULLY_SPECIFIED'
                                             AND cn.locale = 'fr'
               INNER JOIN patient_program_attribute ppa ON ppa.patient_program_id = pp.patient_program_id AND ppa.voided IS FALSE
               INNER JOIN program_attribute_type pat ON ppa.attribute_type_id = pat.program_attribute_type_id AND pat.retired IS FALSE
                                                        AND pat.name in ('TB Type', 'Site TEP', 'End Date for Program', 'Motif début traitement')
               LEFT JOIN concept_name ppcn ON ppa.value_reference = ppcn.concept_id AND ppcn.concept_name_type='SHORT'
                                              AND ppcn.locale = 'fr'
             GROUP BY pp.patient_id
            ) tbProgram on tbProgram.patient_id = p.person_id
  LEFT JOIN (SELECT e.patient_id,
               e.encounter_id,
               e.visit_id,
               group_concat(orderedDrugs.name) AS name
             FROM encounter e
               INNER JOIN (SELECT
                             visit_id,
                             patient_id,
                             max(encounter_datetime) AS  `datetime`
                           from encounter
                           GROUP BY visit_id, patient_id) latestEncounter ON latestEncounter.datetime = e.encounter_datetime
                                                                             AND latestEncounter.patient_id = e.patient_id
                                                                             AND latestEncounter.visit_id = e.visit_id AND e.voided IS FALSE
               LEFT JOIN (SELECT
                            o.encounter_id,
                            o.patient_id,
                            drug.name
                          from orders o
                            INNER JOIN drug_order ON drug_order.order_id = o.order_id AND o.voided IS FALSE
                            INNER JOIN drug ON drug_order.drug_inventory_id = drug.drug_id AND drug.retired IS FALSE) orderedDrugs
                 ON orderedDrugs.patient_id = e.patient_id AND orderedDrugs.encounter_id = e.encounter_id
             GROUP BY e.patient_id, e.encounter_id, e.visit_id
            ) drugs on drugs.patient_id = v.patient_id and drugs.visit_id = v.visit_id
where v.date_created BETWEEN '#startDate#' AND '#endDate#';