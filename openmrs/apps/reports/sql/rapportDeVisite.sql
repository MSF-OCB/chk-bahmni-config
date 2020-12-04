SELECT
pi.identifier AS 'ID',
typeDCohorte.concept_full_name AS 'Type cohorte',
concat(FLOOR(datediff(now(), p.birthdate) / 365), ' ans, ', FLOOR((datediff(now(), p.birthdate) % 365) / 30),' mois') AS 'Age',
date_format(p.birthdate, '%d/%m/%Y') AS 'Date de naissance',
CASE
WHEN p.gender = 'M' THEN 'H'
WHEN p.gender = 'F' THEN 'F'
WHEN p.gender = 'O' THEN 'A' ELSE p.gender END AS 'Sexe',
date_format(dateEntreeCohore.value, '%d/%m/%Y') AS 'Date entree cohorte',
vt.name  AS 'Type de visite',
CASE
WHEN DATE(p.date_created) = DATE(v.date_started) THEN 'Nouvelle visite' ELSE NULL END AS 'Nouvelle visite',
(CASE WHEN vt.name IN('LAB VISIT') THEN NULL ELSE consultant_name.names END) AS 'Consultant',
date_format(prev_appt_date.value_datetime, '%d/%m/%Y') AS 'Date de rendez-vous',
DATE_format(v.date_started, '%d/%m/%Y') AS 'Date debut visite',
DATE_format(v.date_stopped, '%d/%m/%Y') AS 'Date fin visite',
modeDeSortie.modeDeSortie AS "Mode de sortie",
phqScoreValue.phqValue AS "Session PHQ-Cons",
phqScoreValue.scoreValue AS "Score Dep.-Cons"
FROM
visit v
INNER JOIN visit_type vt ON vt.visit_type_id = v.visit_type_id AND vt.retired IS FALSE AND vt.name = 'OPD'
INNER JOIN patient_identifier pi ON pi.patient_id = v.patient_id AND pi.voided IS FALSE
INNER JOIN person p ON p.person_id = pi.patient_id AND p.voided IS FALSE
INNER JOIN person_name pn ON pn.person_id = pi.patient_id AND pn.voided IS FALSE
LEFT JOIN (
            SELECT
            person_id,
            cv.concept_full_name
            FROM
            person_attribute pa
            INNER JOIN person_attribute_type pat ON pat.person_attribute_type_id = pa.person_attribute_type_id
            AND pa.voided IS FALSE
            AND pat.retired IS FALSE
            INNER JOIN concept_view cv ON cv.concept_id = pa.value
            AND cv.retired IS FALSE
            WHERE  pat.name = 'Type de cohorte'
          ) typeDCohorte ON typeDCohorte.person_id = pi.patient_id
LEFT JOIN (
            SELECT
            person_id,
            pa.value
            FROM
            person_attribute pa
            INNER JOIN person_attribute_type pat ON pat.person_attribute_type_id = pa.person_attribute_type_id
            AND pa.voided IS FALSE
            AND pat.retired IS FALSE
            WHERE  pat.name = 'Date entrée cohorte'
          ) dateEntreeCohore ON dateEntreeCohore.person_id = pi.patient_id
LEFT JOIN (/*getting consulation name*/
            SELECT
            v.patient_id,
            v.visit_id,
            GROUP_CONCAT(DISTINCT (concat_ws(' ', pn.given_name, pn.family_name))) AS 'names'
            FROM
            visit v
            INNER JOIN encounter e ON e.visit_id = v.visit_id
            INNER JOIN obs o ON o.encounter_id = e.encounter_id AND o.person_id = v.patient_id
            INNER JOIN encounter_provider ep ON ep.encounter_id = e.encounter_id
            INNER JOIN provider pr ON pr.provider_id = ep.provider_id
            INNER JOIN person_name pn ON pn.person_id = pr.person_id
            GROUP BY patient_id, v.visit_id
          ) consultant_name ON consultant_name.visit_id = v.visit_id
LEFT JOIN (/*getting appointment date of the previous visit*/
            SELECT
            obs.person_id,
            obs.value_datetime,
            latest_obs.visit_id
            FROM
            obs obs
            INNER JOIN encounter en ON en.encounter_id = obs.encounter_id AND obs.voided IS FALSE AND en.voided IS FALSE
            INNER JOIN concept_view cv ON cv.concept_id = obs.concept_id
            AND cv.concept_full_name IN ("Date de prochain RDV") AND cv.retired IS FALSE
            INNER JOIN
                    (
                      SELECT
                      pv.visit_id,
                      pv.prev_visit_id,
                      MAX(o.obs_datetime) AS obsDateTime
                      FROM
                      obs o
                            INNER JOIN encounter e ON e.encounter_id = o.encounter_id
                            AND o.voided IS FALSE AND e.voided IS FALSE
                            INNER JOIN concept_view cv ON cv.concept_id = o.concept_id
                            AND cv.concept_full_name IN ("Date de prochain RDV")
                            AND cv.retired IS FALSE
                            INNER JOIN
                                    (/*Getting previous visit*/
                                      SELECT
                                      v.patient_id,
                                      v.visit_id,
                                      max(prev_visit.visit_id) AS prev_visit_id
                                      FROM
                                      visit v
                                      LEFT JOIN visit prev_visit ON DATE(v.date_started) > DATE(prev_visit.date_started)
                                      /*comparing current visit date with previous visit date*/
                                      AND v.patient_id = prev_visit.patient_id
                                      GROUP BY v.visit_id
                                    ) pv ON pv.prev_visit_id = e.visit_id
                                    GROUP BY pv.visit_id
                    ) latest_obs ON latest_obs.prev_visit_id = en.visit_id AND latest_obs.obsDateTime = obs.obs_datetime
          ) prev_appt_date ON prev_appt_date.visit_id = v.visit_id
LEFT JOIN
          (/*getting latest value of mode de sortie filled*/
            SELECT
            firstAddSectionDateConceptInfo.person_id,
            firstAddSectionDateConceptInfo.visit_id AS visitid,
            o3.value_datetime AS obs_date,
            (SELECT DISTINCT NAME FROM concept_name
                WHERE concept_id = o3.value_coded AND locale = 'fr' AND concept_name_type = 'SHORT') AS "modeDeSortie"

            FROM
                (
                SELECT
                o2.person_id,
                latestVisitEncounterAndVisitForConcept.visit_id,
                MIN(o2.obs_id) AS firstAddSectionObsGroupId,
                latestVisitEncounterAndVisitForConcept.concept_id
                FROM
                    (
                    SELECT
                        MAX(o.encounter_id) AS latestEncounter,
                        o.person_id,
                        o.concept_id,
                        e.visit_id
                    FROM
                    obs o
                    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
                            AND cn.name IN ("Informations mode de sortie(Suivi)")
                            AND cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED'
                            AND cn.locale = 'fr'
                            AND o.voided IS FALSE
                    INNER JOIN encounter e ON e.encounter_id = o.encounter_id
                            AND e.voided IS FALSE
                    GROUP BY e.visit_id
                    ) latestVisitEncounterAndVisitForConcept
                    INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
                            AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
                            AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
                            AND o2.voided IS FALSE
                    INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
                    AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
                    AND e2.voided IS FALSE
                    GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                ) firstAddSectionDateConceptInfo
            INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
                    AND o3.voided IS FALSE
                    AND o3.concept_id =
                                        (
                                        SELECT concept_id
                                        FROM concept_name cn2
                                        WHERE cn2.name IN ("Mode de sortie(Suivi)")
                                        AND cn2.voided IS FALSE
                                        AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                                        AND cn2.locale = 'fr'
                                        )
          ) AS modeDeSortie on modeDeSortie.visitid = v.visit_id AND modeDeSortie.person_id= v.patient_id
LEFT JOIN
          (/*Getting PHQ value*/
            SELECT
            obsForActivityStatus.person_id,
            (SELECT concept_short_name
            FROM concept_view
            WHERE concept_id = obsForActivityStatus.value_coded) AS 'phqValue',
            scoreValue.value_numeric as scoreValue,
            DATE(obsForActivityStatus.obs_datetime)               AS 'ObsDate',
            vt.visit_id                                           AS visit
            FROM obs obsForActivityStatus
            INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
            INNER JOIN visit vt ON vt.visit_id = et.visit_id
            INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
            INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id AND
                      cv.concept_full_name = "CO, PHQ"
            INNER JOIN concept_answer ca
            ON ca.concept_id = cv.concept_id AND obsForActivityStatus.value_coded = ca.answer_concept AND
            cv.concept_full_name = "CO, PHQ"
            AND obsForActivityStatus.voided = 0
            LEFT JOIN
            (/*Getting Score value*/
            SELECT
            o.encounter_id,
            o.person_id,
            o.obs_datetime,
            o.value_numeric,
            o.concept_id,
            e.visit_id
            FROM obs o
            INNER JOIN encounter e on o.encounter_id = e.encounter_id
            INNER JOIN concept_view hemo_val ON hemo_val.concept_id = o.concept_id AND o.voided IS FALSE
            AND hemo_val.retired IS FALSE AND hemo_val.concept_full_name IN ('CO, Score')
            ) AS scoreValue ON scoreValue.person_id = obsForActivityStatus.person_id  and scoreValue.visit_id = vt.visit_id
         GROUP BY visit
         ) AS phqScoreValue on phqScoreValue.person_id = v.patient_id AND phqScoreValue.visit = v.visit_id
WHERE DATE(v.date_started) BETWEEN DATE('#startDate#') AND DATE('#endDate#') AND v.voided = 0
ORDER BY v.date_started;
