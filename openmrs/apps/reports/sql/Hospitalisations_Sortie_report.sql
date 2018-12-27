SELECT pi.identifier                                                                              AS "IDPatient",
       GROUP_CONCAT(DISTINCT (CASE WHEN pat.name = 'Type de cohorte' THEN cn.name ELSE NULL END)) AS "TypeCohorte",
       CONCAT(pn.family_name, ' ', ifNULL(pn.middle_name, ''), ' ', ifNULL(pn.given_name, ''))    AS Nom,
       CONCAT(floor(datediff(now(), p.birthdate) / 365), ' ans, ',
              floor((datediff(now(), p.birthdate) % 365) / 30),
              ' mois')                                                                            AS "Age",
       CASE
         WHEN p.gENDer = 'M' THEN 'Homme'
         WHEN p.gENDer = 'F' THEN 'Femme'
         WHEN p.gender = 'O' THEN 'Autre'
         ELSE NULL END                                                                            AS Sexe,
       DATE_FORMAT(p.birthdate, '%d/%m/%Y')                                                       AS "Datedenaissance",
       GROUP_CONCAT(DISTINCT (CASE
                                WHEN pat.name = 'Date entrée cohorte' THEN date(pa.value)
                                ELSE NULL END))                                                   AS "Dateentréecohorte",
       refer.C6                                                                                   AS "Structure de référence",
       DATE_FORMAT(admdate.name, '%d/%m/%Y')                                                      AS "Date d'admission",
       syndrome.C4                                                                                AS "Syndrome à l'admission",
       GROUP_CONCAT(DISTINCT (dg.S1), '')                                                         AS "1er diagnostic à la sortie",
       GROUP_CONCAT(DISTINCT (dg2.S2), '')                                                        AS "2er diagnostic à la sortie",
       DATE_FORMAT(sortdate.name, '%d/%m/%Y')                                                     AS "Date de sortie",
       mode_sortie.S1                                                                             AS "Mode de sortie",
       mpc.name                                                                                   AS "MPC",
       cd4.VALUE                                                                                  AS "CD4(cells/µl)",
       DATE_FORMAT(cd4.CDdate, '%d/%m/%Y')                                                        AS "Date resultat CD4",
       cv.value                                                                                   AS "CV(copies/ml)",
       DATE_FORMAT(cv.CVDate, '%d/%m/%Y')                                                         AS "Date resultat CV"
FROM (/* get date de sortie details for each visit of patients  */
       SELECT firstAddSectiONDateconceptInfo.person_id,
              firstAddSectiONDateconceptInfo.visit_id AS visitid,
              o3.value_datetime                       AS name
       FROM (SELECT o2.person_id,
                    latestVisitEncounterANDVisitForconcept.visit_id,
                    MIN(o2.obs_id) AS firstAddSectiONObsGroupId,
                    latestVisitEncounterANDVisitForconcept.concept_id
             FROM (SELECT MAX(o.encounter_id) AS latestEncounter, o.person_id, o.concept_id, e.visit_id
                   FROM obs o
                          INNER JOIN concept_name cn
                                     ON o.concept_id = cn.concept_id AND cn.name = ("CSI, Sortie IPD") AND
                                        cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                        cn.locale = 'fr' AND o.voided IS FALSE
                          INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                   GROUP BY e.visit_id) latestVisitEncounterANDVisitForconcept
                    INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterANDVisitForconcept.person_id AND
                                         o2.concept_id = latestVisitEncounterANDVisitForconcept.concept_id AND
                                         o2.encounter_id = latestVisitEncounterANDVisitForconcept.latestEncounter AND
                                         o2.voided IS FALSE
                    INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND
                                               e2.visit_id = latestVisitEncounterANDVisitForconcept.visit_id AND
                                               e2.voided IS FALSE
             GROUP BY latestVisitEncounterANDVisitForconcept.visit_id) firstAddSectiONDateconceptInfo
              INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectiONDateconceptInfo.firstAddSectiONObsGroupId AND
                                   o3.voided IS FALSE
              INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name = ('Date de sortie') AND
                                             cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND
                                             cn2.locale = 'fr' AND
                                             DATE(o3.value_datetime) BETWEEN Date('#startDate#') and Date('#endDate#')) AS sortdate
       INNER JOIN (/* get date de admission details for each visit of patients  */
  SELECT firstAddSectiONDateconceptInfo.person_id AS ID,
         firstAddSectiONDateconceptInfo.visit_id  AS visitid,
         o3.value_datetime                        AS name,
         o3.obs_datetime
  FROM (SELECT o2.person_id,
               latestVisitEncounterANDVisitForconcept.visit_id,
               MIN(o2.obs_id) AS firstAddSectiONObsGroupId,
               latestVisitEncounterANDVisitForconcept.concept_id
        FROM (SELECT max(o.encounter_id) AS latestEncounter, o.person_id, o.concept_id, e.visit_id
              FROM obs o
                     INNER JOIN concept_name cn
                                ON o.concept_id = cn.concept_id AND
                                   cn.name = ("TR, Admission - Informations générales") AND
                                   cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                   cn.locale = 'fr' AND o.voided IS FALSE
                     INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
              GROUP BY e.visit_id) latestVisitEncounterANDVisitForconcept
               INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterANDVisitForconcept.person_id AND
                                    o2.concept_id = latestVisitEncounterANDVisitForconcept.concept_id AND
                                    o2.encounter_id = latestVisitEncounterANDVisitForconcept.latestEncounter AND
                                    o2.voided IS FALSE
               INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND
                                          e2.visit_id = latestVisitEncounterANDVisitForconcept.visit_id AND
                                          e2.voided IS FALSE
        GROUP BY latestVisitEncounterANDVisitForconcept.visit_id) firstAddSectiONDateconceptInfo
         INNER JOIN obs o3
                    ON o3.obs_group_id = firstAddSectiONDateconceptInfo.firstAddSectiONObsGroupId AND
                       o3.voided IS FALSE
         INNER JOIN concept_name cn2
                    ON cn2.concept_id = o3.concept_id AND cn2.name IN ("IPD AdmissiON, Date d'admissiON") AND
                       cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND
                       cn2.locale = 'fr') AS admdate
                  ON admdate.ID = sortdate.person_id AND admdate.visitid = sortdate.visitid
       LEFT JOIN patient_identifier pi ON pi.patient_id = sortdate.person_id
       LEFT JOIN person p ON p.person_id = sortdate.person_id
       LEFT JOIN person_name pn ON pn.person_id = p.person_id
       LEFT JOIN person_attribute pa ON sortdate.person_id = pa.person_id AND pa.voided = 0
       LEFT JOIN person_attribute_type pat ON pa.person_attribute_type_id = pat.person_attribute_type_id
       LEFT JOIN concept_name cn ON cn.concept_id = pa.value AND cn.voided = 0 AND cn.locale_preferred = 1
       LEFT JOIN (/* get structure de référence details for each visit of patients */
  SELECT obsForActivityStatus.person_id,
         (SELECT concept_short_name
          FROM concept_view
          WHERE concept_id = obsForActivityStatus.value_coded) AS 'C6',
         DATE(obsForActivityStatus.obs_datetime)               AS 'ObsDate',
         vt.visit_id                                           AS visit
  FROM obs obsForActivityStatus
         INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
         INNER JOIN visit vt ON vt.visit_id = et.visit_id
         INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id AND
                                       cv.concept_full_name = "Référé en IPD par(FOSA)"
         INNER JOIN concept_answer ca
                    ON ca.concept_id = cv.concept_id AND obsForActivityStatus.value_coded = ca.answer_concept AND
                       cv.concept_full_name IN ("Référé en IPD par(FOSA)")
                      AND obsForActivityStatus.voided = 0) AS refer
                 ON refer.person_id = sortdate.person_id AND refer.visit = sortdate.visitid
       LEFT JOIN (/* get mode d'entrée details for latest encounter of each visit of patients  */
  SELECT firstAddSectionDateConceptInfo.person_id,
         firstAddSectionDateConceptInfo.visit_id AS visitid,
         o3.value_datetime                       AS NAME,
         (SELECT DISTINCT NAME
          FROM concept_name
          WHERE concept_id = o3.value_coded
            AND locale = 'fr'
            AND concept_name_type = 'SHORT')     AS "S1"
  FROM (SELECT o2.person_id,
               latestVisitEncounterAndVisitForConcept.visit_id,
               MIN(o2.obs_id) AS firstAddSectionObsGroupId,
               latestVisitEncounterAndVisitForConcept.concept_id
        FROM (SELECT MAX(o.encounter_id) AS latestEncounter, o.person_id, o.concept_id, e.visit_id
              FROM obs o
                     INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND
                                                   cn.name IN ("CSI, Issue de la consultation") AND
                                                   cn.voided IS FALSE AND
                                                   cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                   cn.locale = 'fr' AND o.voided IS FALSE
                     INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
              GROUP BY e.visit_id) latestVisitEncounterAndVisitForConcept
               INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                    o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                    o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND
                                    o2.voided IS FALSE
               INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND
                                          e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                          e2.voided IS FALSE
        GROUP BY latestVisitEncounterAndVisitForConcept.visit_id) firstAddSectionDateConceptInfo
         INNER JOIN obs o3
                    ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND
                       o3.voided IS FALSE
                      AND o3.concept_id = (SELECT concept_id
                                           FROM concept_name cn2
                                           WHERE cn2.name IN ("CSI, Mode de sortie")
                                             AND cn2.voided IS FALSE
                                             AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                                             AND cn2.locale = 'fr')) AS mode_sortie
                 ON mode_sortie.person_id = sortdate.person_id
                   AND mode_sortie.visitid = sortdate.visitid
       LEFT JOIN (/* get syndrome à l'admission details for each visit of patients  */
  SELECT obsForActivityStatus.person_id,
         CASE
           WHEN (SELECT concept_short_name
                 FROM concept_view
                 WHERE concept_id = obsForActivityStatus.value_coded) = 'Autres'
             THEN (SELECT obsForOthers.value_text
                   FROM obs obsForOthers
                   WHERE obsForOthers.obs_group_id = obsForActivityStatus.obs_group_id
                     AND obsForOthers.concept_id = (SELECT concept_id
                                                    FROM concept_name
                                                    WHERE NAME = 'Si autre, preciser'
                                                      AND locale = 'fr'
                                                      AND concept_name_type = 'FULLY_SPECIFIED')
                     AND obsForOthers.voided = 0)
           ELSE (SELECT concept_short_name
                 FROM concept_view
                 WHERE concept_id = obsForActivityStatus.value_coded)
           END                                   AS 'C4',
         DATE(obsForActivityStatus.obs_datetime) AS 'obsDate',
         vt.visit_id                             AS visit
  FROM obs obsForActivityStatus
         INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
         INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
         INNER JOIN visit vt ON vt.visit_id = et.visit_id
         INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id AND
                                       cv.concept_full_name = "Syndrome d'admission"
         INNER JOIN concept_answer ca
                    ON ca.concept_id = cv.concept_id AND obsForActivityStatus.value_coded = ca.answer_concept AND
                       cv.concept_full_name = "Syndrome d'admission"
                      AND obsForActivityStatus.voided = 0) AS syndrome
                 ON syndrome.person_id = sortdate.person_id AND syndrome.visit = sortdate.visitid
       LEFT JOIN (/* get 1er diagnostic à la sortie details for each visit of patients  */
  SELECT firstAddSectionDateConceptInfo.person_id,
         firstAddSectionDateConceptInfo.visit_id       AS visitid,
         o3.value_datetime                             AS NAME,
         (SELECT DISTINCT NAME
          FROM concept_name
          WHERE concept_id = o3.value_coded
            AND locale = 'fr'
            AND concept_name_type = 'FULLY_SPECIFIED') AS "S1"
  FROM (SELECT o2.person_id,
               latestVisitEncounterAndVisitForConcept.visit_id,
               MIN(o2.obs_id) AS firstAddSectionObsGroupId,
               latestVisitEncounterAndVisitForConcept.concept_id
        FROM (SELECT MAX(o.encounter_id) AS latestEncounter, o.person_id, o.concept_id, e.visit_id
              FROM obs o
                     INNER JOIN concept_name cn
                                ON o.concept_id = cn.concept_id AND cn.name IN ('Syndrome et Diagnostic') AND
                                   cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                   cn.locale = 'fr' AND o.voided IS FALSE
                     INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
              GROUP BY e.visit_id) latestVisitEncounterAndVisitForConcept
               INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                    o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                    o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND
                                    o2.voided IS FALSE
               INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND
                                          e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                          e2.voided IS FALSE
        GROUP BY latestVisitEncounterAndVisitForConcept.visit_id) firstAddSectionDateConceptInfo
         INNER JOIN obs o3
                    ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND
                       o3.voided IS FALSE AND o3.concept_id = (SELECT concept_id
                                                               FROM concept_name cn2
                                                               WHERE cn2.name = ('Fds, Diagnostic')
                                                                 AND cn2.voided IS FALSE
                                                                 AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                                                                 AND cn2.locale = 'fr')) AS dg
                 ON dg.person_id = sortdate.person_id
                   AND dg.visitid = sortdate.visitid
       LEFT JOIN (/* get MPC details for each visit of patients  */
  SELECT o.person_id AS PID, latestEncounter.visit_id AS visitid, answer_concept.name AS NAME
  FROM obs o
         INNER JOIN encounter e
                    ON o.encounter_id = e.encounter_id AND e.voided IS FALSE AND o.voided IS FALSE
         INNER JOIN (SELECT e.visit_id, max(e.encounter_datetime) AS `encounterTime`, cn.concept_id
                     FROM obs o
                            INNER JOIN concept_name cn
                                       ON o.concept_id = cn.concept_id AND cn.name = 'MPC(Sorte)' AND
                                          cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' AND
                                          o.voided IS FALSE
                            INNER JOIN encounter e
                                       ON o.encounter_id = e.encounter_id AND e.voided IS FALSE
                     GROUP BY e.visit_id) latestEncounter
                    ON latestEncounter.encounterTime = e.encounter_datetime AND
                       o.concept_id = latestEncounter.concept_id
         INNER JOIN concept_name answer_concept
                    ON o.value_coded = answer_concept.concept_id AND answer_concept.voided IS FALSE AND
                       answer_concept.concept_name_type = 'FULLY_SPECIFIED' AND
                       answer_concept.locale = 'fr') AS mpc
                 ON mpc.PID = sortdate.person_id AND mpc.visitid = sortdate.visitid
       LEFT JOIN (/* get 2er diagnostic à la sortie details for each visit of patients  */
  SELECT secondAddSectionDateConceptInfo.person_id,
         secondAddSectionDateConceptInfo.visit_id      AS visit,
         o3.value_datetime                             AS NAME,
         (SELECT DISTINCT NAME
          FROM concept_name
          WHERE concept_id = o3.value_coded
            AND locale = 'fr'
            AND concept_name_type = 'FULLY_SPECIFIED') AS "S2"
  FROM (SELECT firstAddSectionDateConceptInfo.person_id,
               firstAddSectionDateConceptInfo.concept_id,
               firstAddSectionDateConceptInfo.latestEncounter,
               firstAddSectionDateConceptInfo.visit_id,
               MIN(o3.obs_id) AS secondAddSectionObsGroupId
        FROM (SELECT o2.person_id,
                     latestVisitEncounterAndVisitForConcept.visit_id,
                     MIN(o2.obs_id) AS firstAddSectionObsGroupId,
                     latestVisitEncounterAndVisitForConcept.concept_id,
                     latestVisitEncounterAndVisitForConcept.latestEncounter
              FROM (SELECT MAX(o.encounter_id) AS latestEncounter, o.person_id, o.concept_id, e.visit_id
                    FROM obs o
                           INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND
                                                         cn.name IN ('Syndrome et Diagnostic') AND
                                                         cn.voided IS FALSE AND
                                                         cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                         cn.locale = 'fr' AND o.voided IS FALSE
                           INNER JOIN encounter e
                                      ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                    GROUP BY e.visit_id) latestVisitEncounterAndVisitForConcept
                     INNER JOIN obs o2
                                ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                   o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                   o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND
                                   o2.voided IS FALSE
                     INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND
                                                e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                                e2.voided IS FALSE
              GROUP BY latestVisitEncounterAndVisitForConcept.visit_id) firstAddSectionDateConceptInfo
               INNER JOIN obs o3
                          ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND
                             o3.concept_id = firstAddSectionDateConceptInfo.concept_id AND
                             o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter AND
                             o3.voided IS FALSE
        GROUP BY firstAddSectionDateConceptInfo.visit_id) secondAddSectionDateConceptInfo
         INNER JOIN obs o3
                    ON o3.obs_group_id = secondAddSectionDateConceptInfo.secondAddSectionObsGroupId AND
                       o3.voided IS FALSE AND o3.concept_id = (SELECT concept_id
                                                               FROM concept_name cn2
                                                               WHERE cn2.name = ('Fds, Diagnostic')
                                                                 AND cn2.voided IS FALSE
                                                                 AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                                                                 AND cn2.locale = 'fr')) AS dg2
                 ON dg2.person_id = sortdate.person_id
                   AND dg2.visit = sortdate.visitid
       LEFT JOIN (/* get charge virale details for each visit of patients  */
  SELECT et.visit_id              AS visitid,
         et.patient_id,
         Max(oTest.value_numeric) AS VALUE,
         oTest.obs_datetime       AS CVDate
  FROM obs oTest
         INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
         INNER JOIN concept_view cvt ON cvt.concept_id = oTest.concept_id AND
                                        cvt.concept_full_name IN ('Charge Virale HIV - Value') AND
                                        oTest.voided IS FALSE AND
                                        cvt.retired IS FALSE
  GROUP BY visit_id) AS cv ON cv.patient_id = sortdate.person_id AND cv.visitid = sortdate.visitid
       LEFT JOIN (/* get cd4 details for each visit of patients  */
  SELECT cd4_obs.vid AS vid, cd4_obs.obsdate AS CDDate, cd4_obs.pid AS PID, cd4_obs.value AS VALUE
  FROM (SELECT v.visit_id        AS vid,
               cd4.obs_datetime  AS obsdate,
               cd4.person_id     AS PID,
               cd4.value_numeric AS VALUE
        FROM visit v
               INNER JOIN encounter e
                          ON e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
               INNER JOIN (SELECT o.encounter_id,
                                  o.person_id,
                                  o.obs_datetime,
                                  o.value_numeric,
                                  o.concept_id
                           FROM obs o
                                  INNER JOIN concept_view cd4_val
                                             ON cd4_val.concept_id = o.concept_id AND o.voided IS FALSE AND
                                                cd4_val.retired IS FALSE AND
                                                cd4_val.concept_full_name IN ("CD4(cells/µl)") AND
                                                o.value_numeric IS NOT NULL
                           UNION
                           (SELECT o.encounter_id,
                                   o.person_id,
                                   o.obs_datetime,
                                   o.value_numeric,
                                   o.concept_id
                            FROM obs o
                                   INNER JOIN concept_view cd4_val
                                              ON cd4_val.concept_id = o.concept_id AND o.voided IS FALSE AND
                                                 cd4_val.retired IS FALSE AND
                                                 cd4_val.concept_full_name IN
                                                 ("CD4(Bilan de routine IPD)", "CD4") AND
                                                 o.value_numeric IS NOT NULL)) cd4
                          ON cd4.encounter_id = e.encounter_id
        ORDER BY obsdate DESC) cd4_obs
  GROUP BY vid) cd4 ON cd4.pid = sortdate.person_id AND cd4.vid = sortdate.visitid
GROUP BY pi.identifier, sortdate.visitid;
