SELECT
  pi.identifier AS "ID Patient",
  group_concat(
    DISTINCT (
      CASE WHEN pat.name = 'Type de cohorte' THEN cn.name ELSE NULL END
    )
  ) AS "TypeCohorte",
  date_format(admdate.name, '%d/%m/%Y') AS "Date d'admission",
  concat(
    pn.family_name,
    ' ',
    ifnull(pn.middle_name, ''),
    ' ',
    ifnull(pn.given_name, '')
  ) AS "Nom",
  concat(
    FLOOR(datediff(now(), p.birthdate) / 365),
    ' ans, ',
    FLOOR((datediff(now(), p.birthdate) % 365) / 30),
    ' mois'
  ) AS "Age",
  CASE WHEN p.gender = 'M' THEN 'Homme' WHEN p.gender = 'F' THEN 'Femme' WHEN p.gender = 'O' THEN 'Autre' ELSE NULL END AS "Sexe",
  pad.COUNTY_DISTRICT AS "Commune de provenance",
  refer.C6 AS "Référé en IPD par (FOSA)",
  fosa.C6 AS "FOSA de suivi ARV",
  syndrome.C4 AS "Syndrome à l'admission",
  syndrome.OtherComment AS "Autre Syndrome",
  malade.C4 AS "Malade arrivé mort",
  Date_format(hosp1.name, '%d/%m/%Y') AS "Hospi antérieures - Date admission",
  stade.C4 AS "Stade OMS",
  glas.gasvalue AS "Glasgow",
  genexpert.value AS "GenXpert",
  TBLAM.Name AS "TB-LAM",
  crag2.value AS "Crag Sang",
  crag.value AS "Crag (LCR)",
  syp.value AS "Syphills",
  hep.value AS "Hépatite B",
  hemo.value AS "Hemoglobine",
  gly.value AS "Glycémie",
  creat.value AS "Créatinine",
  gpt.value AS "GPT",
  Date_format(hiv.name, '%d/%m/%Y') AS "Date diagnostic VIH",
  hist.C4 AS "Histoire ARV",
  si.C4 AS "Si interrompu",
  aveg.C4 AS "Arrêt des ARV pendant plus d'un mois",
  arvnew.ligneARV AS "Ligne ARV en cours",
  Date_format(arvnew.Datedébutligne, '%d/%m/%Y') AS "Date début de la ligne",
  Date_format(arvnew.DatedébutARV, '%d/%m/%Y') AS "Date début ARV",
  (
    CASE WHEN lig.Ligne IN (
      "1ere",
      "2e",
      "3e",
      "1ere alternative",
      "2e alternative",
      "3e alternative",
      "Autres"
    ) THEN lig.Ligne WHEN lig.Ligne = "NoPhase" THEN NULL ELSE "Pas sous ARV" END
  ) AS "Ligne ARV sortie",
  SY.S1 AS "Syndrome sortie 1",
  group_concat(DISTINCT (dg.S1), '') AS "Diagnostic principal sortie",
  SY2.S2 AS "Syndrome sortie 2",
  group_concat(DISTINCT (dg2.S2), '') AS "Diagnostic sortie 2",
  siautre.name AS "Autre diagnostic",
  CD.value AS "CD4 Admission",
  Date_format(CD.CDDate, '%d/%m/%Y') AS "CD4 Date",
  CV.value AS "CV Admission",
  date_format(CV.CVDate, '%d/%m/%Y') AS "CV Date",
  tben.C4 AS "TB en cours de titement à l'admission",
  elementTB.C4 AS "Elements de diagnostic TB",
  tbnew.TbPrecedents AS "TB Précédentes",
  tbnew.Annee AS "Année diagnostic",
  traitmentTBCommence.treatmentAnswer AS "Traitement TB Commencé IPD?",
  DATE_FORMAT(traitmentTBCommence.dateDebut, '%d/%m/%Y') AS "Date début Traitement TB IPD",
  DATE_FORMAT(tbDateEnrolled.date_enrolled, '%d/%m/%Y') AS "Date début TB",
  date_format(sortdate.name, '%d/%m/%Y') AS "Date de sortie",
  modeDeSortie.name AS "Mode de sortie",
  misSousARV.misSousARVAnswer AS "Mis sous ARV en hospitalisation"
FROM
  (
    /* get date de admission details for each visit of patients  */
    SELECT
      firstAddSectionDateConceptInfo.person_id AS person_id,
      firstAddSectionDateConceptInfo.visit_id AS visitid,
      o3.value_datetime AS NAME,
      o3.obs_datetime
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
              max(o.encounter_id) AS latestEncounter,
              o.person_id,
              o.concept_id,
              e.visit_id
            FROM
              obs o
              INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
              AND cn.name IN ("CSI, Sortie IPD")
              AND cn.voided IS FALSE
              AND cn.concept_name_type = 'FULLY_SPECIFIED'
              AND cn.locale = 'fr'
              AND o.voided IS FALSE
              INNER JOIN encounter e ON e.encounter_id = o.encounter_id
              AND e.voided IS FALSE
            GROUP BY
              e.visit_id
          ) latestVisitEncounterAndVisitForConcept
          INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
          AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
          AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
          AND o2.voided IS FALSE
          INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
          AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
          AND e2.voided IS FALSE
        GROUP BY
          latestVisitEncounterAndVisitForConcept.visit_id
      ) firstAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
      AND o3.voided IS FALSE
      AND o3.concept_id = (
        SELECT
          concept_id
        FROM
          concept_name cn2
        WHERE
          cn2.name IN ("Date de sortie")
          AND cn2.voided IS FALSE
          AND cn2.concept_name_type = 'FULLY_SPECIFIED'
          AND cn2.locale = 'fr'
      ) AND DATE(o3.value_datetime) BETWEEN DATE('#startDate#') and Date('#endDate#')
  ) AS admdate
  LEFT JOIN patient_identifier pi ON pi.patient_id = admdate.person_id
  LEFT JOIN person p ON p.person_id = admdate.person_id
  LEFT JOIN person_name pn ON pn.person_id = admdate.person_id
  LEFT JOIN person_address pad ON pad.person_id = admdate.person_id
  LEFT JOIN person_attribute pa ON admdate.person_id = pa.person_id
  AND pa.voided = 0
  LEFT JOIN person_attribute_type pat ON pa.person_attribute_type_id = pat.person_attribute_type_id
  LEFT JOIN concept_name cn ON cn.concept_id = pa.value
  AND cn.voided = 0
  AND cn.locale_preferred = 1
  LEFT JOIN (
    /* get structure de référence details for each visit of patients */
    SELECT
      obsForActivityStatus.person_id,
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C6',
      DATE(obsForActivityStatus.obs_datetime) AS 'ObsDate',
      vt.visit_id AS visit
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id
      AND cv.concept_full_name = "Référé en IPD par(FOSA)"
      INNER JOIN concept_answer ca ON ca.concept_id = cv.concept_id
      AND obsForActivityStatus.value_coded = ca.answer_concept
      AND cv.concept_full_name IN ("Référé en IPD par(FOSA)")
      AND obsForActivityStatus.voided = 0
  ) AS refer ON refer.person_id = admdate.person_id
  AND refer.visit = admdate.visitid
  LEFT JOIN (
    /* get mode d'entrée details for latest encounter of each visit of patients  */
    SELECT
      obsForActivityStatus.person_id,
      CASE WHEN (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) = 'Autres' THEN (
        SELECT
          obsForOthers.value_text
        FROM
          obs obsForOthers
        WHERE
          obsForOthers.obs_group_id = obsForActivityStatus.obs_group_id
          AND obsForOthers.concept_id = (
            SELECT
              concept_id
            FROM
              concept_name
            WHERE
              NAME = 'Si autre, preciser'
              AND locale = 'fr'
              AND concept_name_type = 'FULLY_SPECIFIED'
          )
          AND obsForOthers.voided = 0
      ) END AS 'OtherComment',
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C4',
      DATE(obsForActivityStatus.obs_datetime) AS 'obsDate',
      vt.visit_id AS visit
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
      INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id
      AND cv.concept_full_name = "Syndrome d'admission"
      INNER JOIN concept_answer ca ON ca.concept_id = cv.concept_id
      AND obsForActivityStatus.value_coded = ca.answer_concept
      AND cv.concept_full_name = "Syndrome d'admission"
      AND obsForActivityStatus.voided = 0
  ) AS syndrome ON syndrome.person_id = admdate.person_id
  AND syndrome.visit = admdate.visitid
  LEFT JOIN (
    /* get malade mort details on arrival*/
    SELECT
      obsForActivityStatus.person_id,
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C4',
      DATE(obsForActivityStatus.obs_datetime) AS 'obsDate',
      vt.visit_id AS visit
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
      INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id
      AND cv.concept_full_name = "Malade arrivé mort"
      INNER JOIN concept_answer ca ON ca.concept_id = cv.concept_id
      AND obsForActivityStatus.value_coded = ca.answer_concept
      AND cv.concept_full_name = "Malade arrivé mort"
      AND obsForActivityStatus.voided = 0
  ) AS malade ON malade.person_id = admdate.person_id
  AND malade.visit = admdate.visitid
  LEFT JOIN (
    /* get fosa details for latest encounter of each visit of patients  */
    SELECT
      obsForActivityStatus.person_id,
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C6',
      DATE(obsForActivityStatus.obs_datetime) AS 'ObsDate',
      vt.visit_id AS visit
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
      INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id
      AND cv.concept_full_name = "FOSA de suivi ARV"
      INNER JOIN concept_answer ca ON ca.concept_id = cv.concept_id
      AND obsForActivityStatus.value_coded = ca.answer_concept
      AND cv.concept_full_name = "FOSA de suivi ARV"
      AND obsForActivityStatus.voided = 0
  ) AS fosa ON fosa.person_id = admdate.person_id
  AND fosa.visit = admdate.visitid
  LEFT JOIN (
    /* get Hospi antérieures - date d'admission 1 details for latest encounter of each visit of patients  */
    SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id AS visit,
      o3.value_datetime AS NAME
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
              AND cn.name IN ('TR, Admission - Informations générales')
              AND cn.voided IS FALSE
              AND cn.concept_name_type = 'FULLY_SPECIFIED'
              AND cn.locale = 'fr'
              AND o.voided IS FALSE
              INNER JOIN encounter e ON e.encounter_id = o.encounter_id
              AND e.voided IS FALSE
            GROUP BY
              e.visit_id
          ) latestVisitEncounterAndVisitForConcept
          INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
          AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
          AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
          AND o2.voided IS FALSE
          INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
          AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
          AND e2.voided IS FALSE
        GROUP BY
          latestVisitEncounterAndVisitForConcept.visit_id
      ) firstAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
      AND o3.voided IS FALSE
      AND o3.concept_id = (
        SELECT
          concept_id
        FROM
          concept_name cn2
        WHERE
          cn2.name in ('IPD Admission, Date d\'admission')
          AND cn2.voided IS FALSE
          AND cn2.concept_name_type = 'FULLY_SPECIFIED'
          AND cn2.locale = 'fr'
      )
  ) AS hosp1 ON hosp1.person_id = admdate.person_id
  AND hosp1.visit = admdate.visitid
  LEFT JOIN (
    /* get Stade OMS details for latest encounter of each visit of patients  */
    SELECT
      obsForActivityStatus.person_id,
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C4',
      DATE(obsForActivityStatus.obs_datetime) AS 'obsDate',
      vt.visit_id AS visit
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
    WHERE
      obsForActivityStatus.concept_id IN (
        SELECT
          concept_id
        FROM
          concept_view
        WHERE
          concept_full_name = "Stade clinique OMS"
      )
      AND obsForActivityStatus.value_coded IN (
        SELECT
          answer_concept
        FROM
          concept_answer
        WHERE
          concept_id = (
            SELECT
              concept_id
            FROM
              concept_view
            WHERE
              concept_full_name IN ("Stade clinique OMS")
          )
      )
      AND obsForActivityStatus.voided = 0
  ) AS stade ON stade.person_id = admdate.person_id
  AND stade.visit = admdate.visitid
  LEFT JOIN (
    /* get Glasgow details for latest encounter of each visit of patients  */
    SELECT
      obsq.person_id AS "personid",
      obsq.value_numeric AS "gasvalue",
      DATE(obsq.obs_datetime) AS "Obs_Date",
      vt.visit_id AS visit
    FROM
      obs obsq
      INNER JOIN encounter et ON et.encounter_id = obsq.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
    WHERE
      obsq.concept_id IN (
        SELECT
          concept_id
        FROM
          concept_name
        WHERE
          NAME = "IPD Admission, SNC Glasgow(/15)"
          AND concept_name_type = 'FULLY_SPECIFIED'
          AND locale = 'fr'
      )
      AND obsq.voided = 0
  ) AS glas ON glas.personid = admdate.person_id
  AND glas.visit = admdate.visitid
  LEFT JOIN (
    /* get genexpert details for latest encounter of each visit of patients  */
    SELECT
      et.visit_id AS visit,
      et.patient_id,
      GROUP_CONCAT(cva.concept_full_name) AS VALUE
    FROM
      obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id
      AND et.voided IS FALSE
      INNER JOIN concept_view cvt ON cvt.concept_id = oTest.concept_id
      AND cvt.concept_full_name IN (
        'Genexpert (Crachat)',
        'Genexpert (Pus)',
        'Genexpert (Gastrique)',
        'Genexpert (Ascite)',
        'Genexpert (Pleural)',
        'Genexpert (Ganglionnaire)',
        'Genexpert (Synovial)',
        'Genexpert (Urine)',
        'Genexpert (LCR)',
        'Genexpert (LCR - Bilan de routine IPD)',
        'Genexpert (Ascite - Bilan de routine IPD)',
        'Genexpert (Urine - Bilan de routine IPD)',
        'Genexpert (Synovial - Bilan de routine IPD)',
        'Genexpert (Crachat - Bilan de routine IPD)',
        'Genexpert (Pleural - Bilan de routine IPD)',
        'Genexpert (Pus - Bilan de routine IPD)',
        'Genexpert (Ganglionnaire - Bilan de routine IPD)',
        'Genexpert (Gastrique - Bilan de routine IPD)'
      )
      AND oTest.voided IS FALSE
      AND cvt.retired IS FALSE
      INNER JOIN concept_view cva ON cva.concept_id = oTest.value_coded
      AND cva.retired IS FALSE
    GROUP BY
      visit_id
  ) AS genexpert ON genexpert.patient_id = admdate.person_id
  AND genexpert.visit = admdate.visitid
  LEFT JOIN (
    /* get TBLAM details for latest encounter of each visit of patients  */
    SELECT
      o.person_id,
      latestEncounter.visit_id AS visitid,
      answer_concept.name AS NAME
    FROM
      obs o
      INNER JOIN encounter e ON o.encounter_id = e.encounter_id
      AND e.voided IS FALSE
      AND o.voided IS FALSE
      INNER JOIN (
        SELECT
          e.visit_id,
          max(e.encounter_datetime) AS `encounterTime`,
          cn.concept_id
        FROM
          obs o
          INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
          AND cn.name = 'TB - LAM'
          AND cn.voided IS FALSE
          AND cn.concept_name_type = 'FULLY_SPECIFIED'
          AND cn.locale = 'fr'
          AND o.voided IS FALSE
          INNER JOIN encounter e ON o.encounter_id = e.encounter_id
          AND e.voided IS FALSE
        GROUP BY
          e.visit_id
      ) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime
      AND o.concept_id = latestEncounter.concept_id
      INNER JOIN concept_name answer_concept ON o.value_coded = answer_concept.concept_id
      AND answer_concept.voided IS FALSE
      AND answer_concept.concept_name_type = 'FULLY_SPECIFIED'
      AND answer_concept.locale = 'fr'
  ) AS TBLAM ON TBLAM.person_id = admdate.person_id
  AND admdate.visitid = TBLAM.visitid
  LEFT JOIN (
    /* get Syphilis details for latest encounter of each visit of patients  */
    SELECT
      et.visit_id AS visitid,
      et.patient_id,
      MAX(cvta.concept_full_name) AS VALUE
    FROM
      obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id
      AND et.voided IS FALSE
      INNER JOIN concept_view cvt ON cvt.concept_id = oTest.concept_id
      AND cvt.concept_full_name = 'Syphilis'
      AND oTest.voided IS FALSE
      AND cvt.retired IS FALSE
      INNER JOIN concept_view cvta ON cvta.concept_id = oTest.value_coded
      AND cvta.retired IS FALSE
    GROUP BY
      et.visit_id
  ) AS syp ON syp.patient_id = admdate.person_id
  AND syp.visitid = admdate.visitid
  LEFT JOIN (
    /* get crag details for latest encounter of each visit of patients  */
    SELECT
      et.visit_id AS visitid,
      et.patient_id,
      MAX(cvta.concept_full_name) AS VALUE
    FROM
      obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id
      AND et.voided IS FALSE
      INNER JOIN concept_view cvt ON cvt.concept_id = oTest.concept_id
      AND cvt.concept_full_name = 'Crag'
      AND oTest.voided IS FALSE
      AND cvt.retired IS FALSE
      INNER JOIN concept_view cvta ON cvta.concept_id = oTest.value_coded
      AND cvta.retired IS FALSE
    GROUP BY
      et.visit_id
  ) AS crag ON crag.patient_id = admdate.person_id
  AND crag.visitid = admdate.visitid
  LEFT JOIN (
    /* get Crag serique details for latest encounter of each visit of patients  */
    SELECT
      et.visit_id AS visitid,
      et.patient_id,
      MAX(cvta.concept_full_name) AS VALUE
    FROM
      obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id
      AND et.voided IS FALSE
      INNER JOIN concept_view cvt ON cvt.concept_id = oTest.concept_id
      AND cvt.concept_full_name = 'Crag serique'
      AND oTest.voided IS FALSE
      AND cvt.retired IS FALSE
      INNER JOIN concept_view cvta ON cvta.concept_id = oTest.value_coded
      AND cvta.retired IS FALSE
    GROUP BY
      et.visit_id
  ) AS crag2 ON crag2.patient_id = admdate.person_id
  AND crag2.visitid = admdate.visitid
  LEFT JOIN (
    /* get hep B details for latest encounter of each visit of patients  */
    SELECT
      et.visit_id AS visitid,
      et.patient_id,
      MAX(cvta.concept_full_name) AS VALUE
    FROM
      obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id
      AND et.voided IS FALSE
      INNER JOIN concept_view cvt ON cvt.concept_id = oTest.concept_id
      AND cvt.concept_full_name = 'Hépatite B'
      AND oTest.voided IS FALSE
      AND cvt.retired IS FALSE
      INNER JOIN concept_view cvta ON cvta.concept_id = oTest.value_coded
      AND cvta.retired IS FALSE
    GROUP BY
      et.visit_id
  ) AS hep ON hep.patient_id = admdate.person_id
  AND hep.visitid = admdate.visitid
  LEFT JOIN (
    /* get hemoglobline details for latest encounter of each visit of patients  */
    SELECT
      hemo_obs.vid AS vid,
      hemo_obs.obsdate AS obsdate,
      hemo_obs.pid AS PID,
      hemo_obs.value AS VALUE
    FROM
      (
        SELECT
          v.visit_id AS vid,
          hemo.obs_datetime AS obsdate,
          hemo.person_id AS PID,
          hemo.value_numeric AS VALUE
        FROM
          visit v
          INNER JOIN encounter e ON e.visit_id = v.visit_id
          AND e.voided IS FALSE
          AND v.voided IS FALSE
          INNER JOIN (
            SELECT
              o.encounter_id,
              o.person_id,
              o.obs_datetime,
              o.value_numeric,
              o.concept_id
            FROM
              obs o
              INNER JOIN concept_view hemo_val ON hemo_val.concept_id = o.concept_id
              AND o.voided IS FALSE
              AND hemo_val.retired IS FALSE
              AND hemo_val.concept_full_name IN ('Hémoglobine (Hemocue)(g/dl)')
              AND o.value_numeric IS NOT NULL
            UNION
              (
                SELECT
                  o.encounter_id,
                  o.person_id,
                  o.obs_datetime,
                  o.value_numeric,
                  o.concept_id
                FROM
                  obs o
                  INNER JOIN concept_view hemo_val ON hemo_val.concept_id = o.concept_id
                  AND o.voided IS FALSE
                  AND hemo_val.retired IS FALSE
                  AND hemo_val.concept_full_name IN ('Hemoglobine')
                  AND o.value_numeric IS NOT NULL
              )
          ) hemo ON hemo.encounter_id = e.encounter_id
        ORDER BY
          obsdate DESC
      ) hemo_obs
    GROUP BY
      vid
  ) AS hemo ON hemo.PID = admdate.person_id
  AND hemo.vid = admdate.visitid
  LEFT JOIN (
    /* get glycerine details for latest encounter of each visit of patients  */
    SELECT
      glyc_obs.vid AS vid,
      glyc_obs.obsdate AS obsdate,
      glyc_obs.pid AS PID,
      glyc_obs.value AS VALUE
    FROM
      (
        SELECT
          v.visit_id AS vid,
          glyc.obs_datetime AS obsdate,
          glyc.person_id AS PID,
          glyc.value_numeric AS VALUE
        FROM
          visit v
          INNER JOIN encounter e ON e.visit_id = v.visit_id
          AND e.voided IS FALSE
          AND v.voided IS FALSE
          INNER JOIN (
            SELECT
              o.encounter_id,
              o.person_id,
              o.obs_datetime,
              o.value_numeric,
              o.concept_id
            FROM
              obs o
              INNER JOIN concept_view glyc_val ON glyc_val.concept_id = o.concept_id
              AND o.voided IS FALSE
              AND glyc_val.retired IS FALSE
              AND glyc_val.concept_full_name IN ('Glycémie(mg/dl)')
              AND o.value_numeric IS NOT NULL
            UNION
              (
                SELECT
                  o.encounter_id,
                  o.person_id,
                  o.obs_datetime,
                  o.value_numeric,
                  o.concept_id
                FROM
                  obs o
                  INNER JOIN concept_view glyc_val ON glyc_val.concept_id = o.concept_id
                  AND o.voided IS FALSE
                  AND glyc_val.retired IS FALSE
                  AND glyc_val.concept_full_name IN ('Glycémie')
                  AND o.value_numeric IS NOT NULL
              )
          ) glyc ON glyc.encounter_id = e.encounter_id
        ORDER BY
          obsdate DESC
      ) glyc_obs
    GROUP BY
      vid
  ) AS gly ON gly.PID = admdate.person_id
  AND gly.vid = admdate.visitid
  LEFT JOIN (
    /* get creatinine details for latest encounter of each visit of patients  */
    SELECT
      et.visit_id AS visitid,
      et.patient_id,
      Max(oTest.value_numeric) AS VALUE
    FROM
      obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id
      AND et.voided IS FALSE
      INNER JOIN concept_view cvt ON cvt.concept_id = oTest.concept_id
      AND cvt.concept_full_name = 'Creatinine'
      AND oTest.voided IS FALSE
      AND cvt.retired IS FALSE
    GROUP BY
      visit_id
  ) AS creat ON creat.patient_id = admdate.person_id
  AND creat.visitid = admdate.visitid
  LEFT JOIN (
    /* get GPT details for latest encounter of each visit of patients  */
    SELECT
      et.visit_id AS visitid,
      et.patient_id,
      Max(oTest.value_numeric) AS VALUE
    FROM
      obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id
      AND et.voided IS FALSE
      INNER JOIN concept_view cvt ON cvt.concept_id = oTest.concept_id
      AND cvt.concept_full_name = 'GPT'
      AND oTest.voided IS FALSE
      AND cvt.retired IS FALSE
    GROUP BY
      visit_id
  ) AS gpt ON gpt.patient_id = admdate.person_id
  AND gpt.visitid = admdate.visitid
  LEFT JOIN (
    /* get Date diagnostic VIH(Ant) details for latest encounter of each visit of patients  */
    SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id AS visitid,
      o3.value_datetime AS NAME
    FROM
      (
        SELECT
          o2.person_id,
          latestVisitEncounterAndVisitForConcept.visit_id,
          Min(o2.obs_id) AS firstAddSectionObsGroupId,
          latestVisitEncounterAndVisitForConcept.concept_id
        FROM
          (
            SELECT
              Max(o.encounter_id) AS latestEncounter,
              o.person_id,
              o.concept_id,
              e.visit_id
            FROM
              obs o
              INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
              AND cn.name IN ("historique arv")
              AND cn.voided IS FALSE
              AND cn.concept_name_type = 'FULLY_SPECIFIED'
              AND cn.locale = 'fr'
              AND o.voided IS FALSE
              INNER JOIN encounter e ON e.encounter_id = o.encounter_id
              AND e.voided IS FALSE
            GROUP BY
              e.visit_id
          ) latestVisitEncounterAndVisitForConcept
          INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
          AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
          AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestencounter
          AND o2.voided IS FALSE
          INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
          AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
          AND e2.voided IS FALSE
        GROUP BY
          latestVisitEncounterAndVisitForConcept.visit_id
      ) firstAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstaddsectionobsgroupid
      AND o3.voided IS FALSE
      AND o3.concept_id = (
        SELECT
          concept_id
        FROM
          concept_name cn2
        WHERE
          cn2.name = ('Date diagnostic VIH(Ant)')
          AND cn2.voided IS FALSE
          AND cn2.concept_name_type = 'FULLY_SPECIFIED'
          AND cn2.locale = 'fr'
      )
  ) AS hiv ON hiv.person_id = admdate.person_id
  AND hiv.visitid = admdate.visitid
  LEFT JOIN (
    /* get ARV histoire details for latest encounter of each visit of patients  */
    SELECT
      obsForActivityStatus.person_id,
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C4',
      DATE(obsForActivityStatus.obs_datetime) AS 'obsDate',
      vt.visit_id AS visit
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
      INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id
      AND cv.concept_full_name = "IPD Admission, Histoire ARV"
      INNER JOIN concept_answer ca ON ca.concept_id = cv.concept_id
      AND obsForActivityStatus.value_coded = ca.answer_concept
      AND cv.concept_full_name = "IPD Admission, Histoire ARV"
      AND obsForActivityStatus.voided = 0
  ) AS hist ON hist.person_id = admdate.person_id
  AND hist.visit = admdate.visitid
  LEFT JOIN (
    /* get Si interrompu details for latest encounter of each visit of patients  */
    SELECT
      obsForActivityStatus.person_id,
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C4',
      DATE(obsForActivityStatus.obs_datetime) AS 'obsDate',
      vt.visit_id AS visitid
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
      INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id
      AND cv.concept_full_name = "IPD Admission, Si interrompu"
      INNER JOIN concept_answer ca ON ca.concept_id = cv.concept_id
      AND obsForActivityStatus.value_coded = ca.answer_concept
      AND cv.concept_full_name = "IPD Admission, Si interrompu"
      AND obsForActivityStatus.voided = 0
  ) AS si ON si.person_id = admdate.person_id
  AND si.visitid = admdate.visitid
  LEFT JOIN (
    /* get ligne ARV en cours details for latest encounter of each visit of patients  */
    SELECT
      obsForActivityStatus.person_id,
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C4',
      DATE(obsForActivityStatus.obs_datetime) AS 'obsDate',
      vt.visit_id AS visitid
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
      INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id
      AND cv.concept_full_name = "IPD Admission, Ligne ARV en cours"
      INNER JOIN concept_answer ca ON ca.concept_id = cv.concept_id
      AND obsForActivityStatus.value_coded = ca.answer_concept
      AND cv.concept_full_name = "IPD Admission, Ligne ARV en cours"
      AND obsForActivityStatus.voided = 0
  ) AS ligne ON ligne.person_id = admdate.person_id
  AND ligne.visitid = admdate.visitid
  LEFT JOIN (
    /* get Arrêt des ARV details for latest encounter of each visit of patients  */
    SELECT
      obsForActivityStatus.person_id,
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C4',
      DATE(obsForActivityStatus.obs_datetime) AS 'obsDate',
      vt.visit_id AS visitid
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
      INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id
      AND cv.concept_full_name = "IPD Admission, Avez-vous déjà arrêté les ARV pendant plus d'un mois"
      INNER JOIN concept_answer ca ON ca.concept_id = cv.concept_id
      AND obsForActivityStatus.value_coded = ca.answer_concept
      AND cv.concept_full_name = "IPD Admission, Avez-vous déjà arrêté les ARV pendant plus d'un mois"
      AND obsForActivityStatus.voided = 0
  ) AS aveg ON aveg.person_id = admdate.person_id
  AND aveg.visitid = admdate.visitid
  LEFT JOIN (
    /* get TB en cours details for latest encounter of each visit of patients  */
    SELECT
      obsForActivityStatus.person_id,
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C4',
      DATE(obsForActivityStatus.obs_datetime) AS 'obsDate',
      vt.visit_id AS visitid
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
      INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id
      AND cv.concept_full_name = "IPD Admission, TB en cours de traimtement à l'admission"
      INNER JOIN concept_answer ca ON ca.concept_id = cv.concept_id
      AND obsForActivityStatus.value_coded = ca.answer_concept
      AND cv.concept_full_name = "IPD Admission, TB en cours de traitement à l'admission"
      AND obsForActivityStatus.voided = 0
  ) AS tben ON tben.person_id = admdate.person_id
  AND tben.visitid = admdate.visitid
  LEFT JOIN (
    /* get Elements de diagnostic TB details for latest encounter of each visit of patients  */
    SELECT
      obsForActivityStatus.person_id,
      (
        SELECT
          concept_short_name
        FROM
          concept_view
        WHERE
          concept_id = obsForActivityStatus.value_coded
      ) AS 'C4',
      DATE(obsForActivityStatus.obs_datetime) AS 'obsDate',
      vt.visit_id AS visitid
    FROM
      obs obsForActivityStatus
      INNER JOIN encounter et ON et.encounter_id = obsForActivityStatus.encounter_id
      INNER JOIN visit vt ON vt.visit_id = et.visit_id
      INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
      INNER JOIN concept_view cv ON cv.concept_id = obsForActivityStatus.concept_id
      AND cv.concept_full_name = "IPD Admission, Elements de diagnostic TB"
      INNER JOIN concept_answer ca ON ca.concept_id = cv.concept_id
      AND obsForActivityStatus.value_coded = ca.answer_concept
      AND cv.concept_full_name = "IPD Admission, Elements de diagnostic TB"
      AND obsForActivityStatus.voided = 0
  ) AS elementTB ON elementTB.person_id = admdate.person_id
  AND elementTB.visitid = admdate.visitid
  LEFT JOIN (
    /* get date de sortie details for latest encounter of each visit of patients  */
    SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id AS visitid,
      o3.value_datetime AS NAME
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
              AND cn.name IN ("Formulaire de sortie")
              AND cn.voided IS FALSE
              AND cn.concept_name_type = 'FULLY_SPECIFIED'
              AND cn.locale = 'fr'
              AND o.voided IS FALSE
              INNER JOIN encounter e ON e.encounter_id = o.encounter_id
              AND e.voided IS FALSE
            GROUP BY
              e.visit_id
          ) latestVisitEncounterAndVisitForConcept
          INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
          AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
          AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
          AND o2.voided IS FALSE
          INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
          AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
          AND e2.voided IS FALSE
        GROUP BY
          latestVisitEncounterAndVisitForConcept.visit_id
      ) firstAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
      AND o3.voided IS FALSE
      AND o3.concept_id = (
        SELECT
          concept_id
        FROM
          concept_name cn2
        WHERE
          cn2.name = ('Date de sortie')
          AND cn2.voided IS FALSE
          AND cn2.concept_name_type = 'FULLY_SPECIFIED'
          AND cn2.locale = 'fr'
      )
  ) AS sortdate ON sortdate.person_id = admdate.person_id
  AND sortdate.visitid = admdate.visitid
  LEFT JOIN (
    /* get Programme ARV details for latest encounter of each visit of patients  */
    SELECT
      patientID,
      DateDebutARV,
      (
        CASE WHEN patientWithARVEnrolled.LigneARV THEN patientWithARVEnrolled.LigneARV ELSE "NoPhase" END
      ) AS "Ligne"
    FROM
      (
        SELECT
          patientID,
          (
            CASE WHEN phaseOfProg IN (
              "1ere",
              "2e",
              "3e",
              "1ere alternative",
              "2e alternative",
              "3e alternative",
              "Autres"
            ) THEN phaseOfProg ELSE NULL END
          ) AS "LigneARV",
          phaseDate AS "DateDebutligne",
          DATE(enrollmentDate) AS "DateDebutARV"
        FROM
          (
            SELECT
              Y.program_id,
              Y.patientID,
              Y.enrollmentDate,
              Y.phaseDate,
              Y.vid,
              Y.phaseOfProg
            FROM
              (
                SELECT
                  X.program_id,
                  X.patientID,
                  X.enrollmentDate,
                  X.phaseDate,
                  X.vid,
                  X.phaseOfProg
                FROM
                  (
                    SELECT
                      ARVprog.program_id AS program_id,
                      patientARVprog.patient_id AS patientID,
                      patientARVprog.date_enrolled AS "enrollmentDate",
                      patientPhaseOfProg.start_date AS "phaseDate",
                      v.visit_id AS vid,
                      (
                        CASE WHEN progWorkflowState.concept_id THEN cn.name ELSE NULL END
                      ) AS "phaseOfProg"
                    FROM
                      patient_program patientARVprog
                      INNER JOIN program ARVprog ON ARVprog.program_id = patientARVprog.program_id
                      AND patientARVprog.voided = 0
                      LEFT JOIN patient_state patientPhaseOfProg ON patientARVprog.patient_program_id = patientPhaseOfProg.patient_program_id
                      AND patientPhaseOfProg.voided = 0
                      LEFT JOIN program_workflow_state progWorkflowState ON patientPhaseOfProg.state = progWorkflowState.program_workflow_state_id
                      LEFT JOIN concept_name cn ON progWorkflowState.concept_id = cn.concept_id
                      AND cn.voided = 0
                      AND cn.locale = 'fr'
                      AND cn.concept_name_type = 'SHORT'
                      INNER JOIN visit v ON v.patient_id = patientARVprog.patient_id
                    WHERE
                      ARVprog.program_id = (
                        SELECT
                          program_id
                        FROM
                          program
                        WHERE
                          `name` = "Programme ARV"
                      )
                      AND patientARVprog.voided = 0
                      AND patientPhaseOfProg.end_date IS NULL
                      AND patientARVprog.date_completed IS NULL
                      AND patientPhaseOfProg.end_date IS NULL
                    GROUP BY
                      patientARVprog.patient_id,
                      patientPhaseOfProg.start_date
                    ORDER BY
                      patientPhaseOfProg.patient_program_id DESC
                  ) X
                GROUP BY
                  phaseOfProg,
                  patientID
                ORDER BY
                  phaseDate DESC
              ) Y
            GROUP BY
              patientID
          ) AS arv
      ) AS patientWithARVEnrolled
  ) AS lig ON lig.patientID = admdate.person_id
  LEFT JOIN (
    /* get Syndrome et Diagnostic details for latest encounter of each visit of patients  */
    SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id AS visitid,
      o3.value_datetime AS NAME,
      (
        SELECT
          NAME
        FROM
          concept_name
        WHERE
          concept_id = o3.value_coded
          AND locale = 'fr'
          AND concept_name_type = 'FULLY_SPECIFIED'
      ) AS "S1"
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
              AND cn.name IN ('Syndrome et Diagnostic')
              AND cn.voided IS FALSE
              AND cn.concept_name_type = 'FULLY_SPECIFIED'
              AND cn.locale = 'fr'
              AND o.voided IS FALSE
              INNER JOIN encounter e ON e.encounter_id = o.encounter_id
              AND e.voided IS FALSE
            GROUP BY
              e.visit_id
          ) latestVisitEncounterAndVisitForConcept
          INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
          AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
          AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
          AND o2.voided IS FALSE
          INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
          AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
          AND e2.voided IS FALSE
        GROUP BY
          latestVisitEncounterAndVisitForConcept.visit_id
      ) firstAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
      AND o3.voided IS FALSE
      AND o3.concept_id = (
        SELECT
          concept_id
        FROM
          concept_name cn2
        WHERE
          cn2.name = ('Syndrome')
          AND cn2.voided IS FALSE
          AND cn2.concept_name_type = 'FULLY_SPECIFIED'
          AND cn2.locale = 'fr'
      )
  ) AS SY ON SY.person_id = admdate.person_id
  AND SY.visitid = admdate.visitid
  LEFT JOIN (
    /* get Syndrome et Diagnostic 2 details for latest encounter of each visit of patients  */
    SELECT
      secondAddSectionDateConceptInfo.person_id,
      secondAddSectionDateConceptInfo.visit_id AS visitid,
      o3.value_datetime AS NAME,
      (
        SELECT
          NAME
        FROM
          concept_name
        WHERE
          concept_id = o3.value_coded
          AND locale = 'fr'
          AND concept_name_type = 'FULLY_SPECIFIED'
      ) AS "S2"
    FROM
      (
        SELECT
          firstAddSectionDateConceptInfo.person_id,
          firstAddSectionDateConceptInfo.concept_id,
          firstAddSectionDateConceptInfo.latestEncounter,
          firstAddSectionDateConceptInfo.visit_id,
          MIN(o3.obs_id) AS secondAddSectionObsGroupId
        FROM
          (
            SELECT
              o2.person_id,
              latestVisitEncounterAndVisitForConcept.visit_id,
              MIN(o2.obs_id) AS firstAddSectionObsGroupId,
              latestVisitEncounterAndVisitForConcept.concept_id,
              latestVisitEncounterAndVisitForConcept.latestEncounter
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
                  AND cn.name IN ('Syndrome et Diagnostic')
                  AND cn.voided IS FALSE
                  AND cn.concept_name_type = 'FULLY_SPECIFIED'
                  AND cn.locale = 'fr'
                  AND o.voided IS FALSE
                  INNER JOIN encounter e ON e.encounter_id = o.encounter_id
                  AND e.voided IS FALSE
                GROUP BY
                  e.visit_id
              ) latestVisitEncounterAndVisitForConcept
              INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
              AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
              AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
              AND o2.voided IS FALSE
              INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
              AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
              AND e2.voided IS FALSE
            GROUP BY
              latestVisitEncounterAndVisitForConcept.visit_id
          ) firstAddSectionDateConceptInfo
          INNER JOIN obs o3 ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
          AND o3.concept_id = firstAddSectionDateConceptInfo.concept_id
          AND o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter
          AND o3.voided IS FALSE
        GROUP BY
          firstAddSectionDateConceptInfo.visit_id
      ) secondAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = secondAddSectionDateConceptInfo.secondAddSectionObsGroupId
      AND o3.voided IS FALSE
      AND o3.concept_id = (
        SELECT
          concept_id
        FROM
          concept_name cn2
        WHERE
          cn2.name = ('Syndrome')
          AND cn2.voided IS FALSE
          AND cn2.concept_name_type = 'FULLY_SPECIFIED'
          AND cn2.locale = 'fr'
      )
  ) AS SY2 ON SY2.person_id = admdate.person_id
  AND SY2.visitid = admdate.visitid
  LEFT JOIN (
    /* get 1er Diagnostic  on admission */
    SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id AS visitid,
      o3.value_datetime AS NAME,
      (
        SELECT
          NAME
        FROM
          concept_name
        WHERE
          concept_id = o3.value_coded
          AND locale = 'fr'
          AND concept_name_type = 'FULLY_SPECIFIED'
      ) AS "S1"
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
              AND cn.name IN ('Syndrome et Diagnostic')
              AND cn.voided IS FALSE
              AND cn.concept_name_type = 'FULLY_SPECIFIED'
              AND cn.locale = 'fr'
              AND o.voided IS FALSE
              INNER JOIN encounter e ON e.encounter_id = o.encounter_id
              AND e.voided IS FALSE
            GROUP BY
              e.visit_id
          ) latestVisitEncounterAndVisitForConcept
          INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
          AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
          AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
          AND o2.voided IS FALSE
          INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
          AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
          AND e2.voided IS FALSE
        GROUP BY
          latestVisitEncounterAndVisitForConcept.visit_id
      ) firstAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
      AND o3.voided IS FALSE
      AND o3.concept_id = (
        SELECT
          concept_id
        FROM
          concept_name cn2
        WHERE
          cn2.name IN ('Fds, Diagnostic')
          AND cn2.voided IS FALSE
          AND cn2.concept_name_type = 'FULLY_SPECIFIED'
          AND cn2.locale = 'fr'
      )
  ) AS dg ON dg.person_id = admdate.person_id
  AND dg.visitid = admdate.visitid
  LEFT JOIN (
    /* get 2er Diagnostic  on admission */
    SELECT
      secondAddSectionDateConceptInfo.person_id,
      secondAddSectionDateConceptInfo.visit_id AS visitid,
      o3.value_datetime AS NAME,
      (
        SELECT
          NAME
        FROM
          concept_name
        WHERE
          concept_id = o3.value_coded
          AND locale = 'fr'
          AND concept_name_type = 'FULLY_SPECIFIED'
      ) AS "S2"
    FROM
      (
        SELECT
          firstAddSectionDateConceptInfo.person_id,
          firstAddSectionDateConceptInfo.concept_id,
          firstAddSectionDateConceptInfo.latestEncounter,
          firstAddSectionDateConceptInfo.visit_id,
          MIN(o3.obs_id) AS secondAddSectionObsGroupId
        FROM
          (
            SELECT
              o2.person_id,
              latestVisitEncounterAndVisitForConcept.visit_id,
              MIN(o2.obs_id) AS firstAddSectionObsGroupId,
              latestVisitEncounterAndVisitForConcept.concept_id,
              latestVisitEncounterAndVisitForConcept.latestEncounter
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
                  AND cn.name IN ('Syndrome et Diagnostic')
                  AND cn.voided IS FALSE
                  AND cn.concept_name_type = 'FULLY_SPECIFIED'
                  AND cn.locale = 'fr'
                  AND o.voided IS FALSE
                  INNER JOIN encounter e ON e.encounter_id = o.encounter_id
                  AND e.voided IS FALSE
                GROUP BY
                  e.visit_id
              ) latestVisitEncounterAndVisitForConcept
              INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
              AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
              AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
              AND o2.voided IS FALSE
              INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
              AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
              AND e2.voided IS FALSE
            GROUP BY
              latestVisitEncounterAndVisitForConcept.visit_id
          ) firstAddSectionDateConceptInfo
          INNER JOIN obs o3 ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
          AND o3.concept_id = firstAddSectionDateConceptInfo.concept_id
          AND o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter
          AND o3.voided IS FALSE
        GROUP BY
          firstAddSectionDateConceptInfo.visit_id
      ) secondAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = secondAddSectionDateConceptInfo.secondAddSectionObsGroupId
      AND o3.voided IS FALSE
      AND o3.concept_id = (
        SELECT
          concept_id
        FROM
          concept_name cn2
        WHERE
          cn2.name IN ('Fds, Diagnostic')
          AND cn2.voided IS FALSE
          AND cn2.concept_name_type = 'FULLY_SPECIFIED'
          AND cn2.locale = 'fr'
      )
  ) dg2 ON dg2.person_id = admdate.person_id
  AND dg2.visitid = admdate.visitid
  LEFT JOIN (
    SELECT
      et.visit_id AS visitid,
      et.patient_id,
      Max(oTest.value_numeric) AS VALUE,
      oTest.obs_datetime AS CVDate
    FROM
      obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id
      AND et.voided IS FALSE
      INNER JOIN concept_view cvt ON cvt.concept_id = oTest.concept_id
      AND cvt.concept_full_name IN (
        'Charge Virale - Value(Bilan de routine IPD)',
        'Charge Virale HIV - Value'
      )
      AND oTest.voided IS FALSE
      AND cvt.retired IS FALSE
    GROUP BY
      visit_id
  ) AS CV ON CV.patient_id = admdate.person_id
  AND CV.visitid = admdate.visitid
  LEFT JOIN (
    /* get TB Précédentes details for each visit of patients  */
    SELECT
      tbPatients.person_id AS pid,
      (
        CASE WHEN ifnull(dateCreatedOnTB, '1981-01-01') > ifnull(dateCreatedForm, '1981-01-01') THEN Tbprecedents ELSE TbPrecedentsForm END
      ) AS "TbPrecedents",
      (
        CASE WHEN ifnull(dateCreatedOnTB, '1981-01-01') > ifnull(dateCreatedForm, '1981-01-01') THEN Anne ELSE AnneDiagnostic END
      ) AS "Annee",
      dateCreatedOnTB,
      dateCreatedForm
    FROM
      (
        SELECT
          person.person_id,
          tbprog.patientID,
          tbprog.dateCreatedOnTB,
          tbprog.Tbprecedents,
          tbprog.Anne,
          tbprog.phaseDate,
          tbprog.date_completed,
          tbprog.vid,
          tbprog.phaseOfProg
        FROM
          person
          LEFT JOIN (
            SELECT
              Y.patientID,
              Y.dateCreatedOnTB,
              Y.Tbprecedents,
              Y.Anne,
              Y.phaseDate,
              Y.date_completed,
              Y.vid,
              Y.phaseOfProg
            FROM
              (
                SELECT
                  X.patientID,
                  X.dateCreatedOnTB,
                  X.Tbprecedents,
                  X.Anne,
                  X.phaseDate,
                  X.date_completed,
                  X.vid,
                  X.phaseOfProg
                FROM
                  (
                    SELECT
                      patientARVprog.patient_id AS patientID,
                      IF(
                        patientARVprog.date_changed > patientARVprog.date_created,
                        patientARVprog.date_changed,
                        patientARVprog.date_created
                      ) AS "dateCreatedOnTB",
                      (
                        CASE WHEN patientARVprog.date_enrolled THEN "Oui" ELSE NULL END
                      ) AS "Tbprecedents",
                      DATE_FORMAT(patientARVprog.date_enrolled, '%Y') AS "Anne",
                      patientPhaseOfProg.start_date AS "phaseDate",
                      patientARVprog.date_completed,
                      v.visit_id AS vid,
                      (
                        CASE WHEN progWorkflowState.concept_id THEN cv.concept_full_name ELSE NULL END
                      ) AS "phaseOfProg"
                    FROM
                      patient_program patientARVprog
                      INNER JOIN program ARVprog ON ARVprog.program_id = patientARVprog.program_id
                      AND patientARVprog.voided = 0
                      LEFT JOIN patient_state patientPhaseOfProg ON patientARVprog.patient_program_id = patientPhaseOfProg.patient_program_id
                      AND patientPhaseOfProg.voided = 0
                      LEFT JOIN program_workflow_state progWorkflowState ON patientPhaseOfProg.state = progWorkflowState.program_workflow_state_id
                      LEFT JOIN concept_view cv ON progWorkflowState.concept_id = cv.concept_id
                      AND cv.retired = 0
                      INNER JOIN visit v ON v.patient_id = patientARVprog.patient_id
                    WHERE
                      ARVprog.program_id = (
                        SELECT
                          program_id
                        FROM
                          program
                        WHERE
                          `name` = "Programme TB"
                      )
                      AND patientARVprog.voided = 0
                      AND patientPhaseOfProg.end_date IS NULL
                      AND patientPhaseOfProg.end_date IS NULL
                    GROUP BY
                      patientARVprog.patient_id,
                      patientPhaseOfProg.start_date
                    ORDER BY
                      patientPhaseOfProg.patient_program_id DESC
                  ) X
                GROUP BY
                  phaseOfProg,
                  patientID
                ORDER BY
                  phaseDate DESC
              ) Y
            GROUP BY
              patientID
          ) AS tbprog ON person.person_id = tbprog.patientID
      ) AS tbPatients
      LEFT JOIN (
        SELECT
          Tbpre.pid,
          (
            CASE WHEN (
              S1 IN ("Nouveau patient")
              OR S1 IN ("Traité précédemment")
            ) THEN "Oui" ELSE NULL END
          ) AS "TbPrecedentsForm",
          totalform.name AS "AnneDiagnostic",
          dateCreatedForAnee AS "dateCreatedForm"
        FROM
          (
            SELECT
              firstAddSectionDateConceptInfo.person_id AS pid,
              firstAddSectionDateConceptInfo.visit_id AS visitid,
              o3.value_datetime AS NAME,
              (
                CASE WHEN o3.date_created > o3.obs_datetime THEN o3.date_created ELSE o3.obs_datetime END
              ) AS "obsDateCreated",
              (
                SELECT
                  NAME
                FROM
                  concept_name
                WHERE
                  concept_id = o3.value_coded
                  AND locale = 'fr'
                  AND concept_name_type = 'FULLY_SPECIFIED'
              ) AS "S1"
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
                      AND cn.name IN ('Informations TB')
                      AND cn.voided IS FALSE
                      AND cn.concept_name_type = 'FULLY_SPECIFIED'
                      AND cn.locale = 'fr'
                      AND o.voided IS FALSE
                      INNER JOIN encounter e ON e.encounter_id = o.encounter_id
                      AND e.voided IS FALSE
                    GROUP BY
                      e.visit_id
                  ) latestVisitEncounterAndVisitForConcept
                  INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
                  AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
                  AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
                  AND o2.voided = 0
                  INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
                  AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
                  AND e2.voided IS FALSE
                GROUP BY
                  latestVisitEncounterAndVisitForConcept.visit_id
              ) firstAddSectionDateConceptInfo
              INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
              AND o3.voided = 0
              AND o3.void_reason IS NULL
              INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id
              AND cn2.name IN ("Traitement TB Antérieur")
              AND cn2.voided IS FALSE
              AND cn2.concept_name_type = 'FULLY_SPECIFIED'
              AND cn2.locale = 'fr'
          ) Tbpre
          LEFT JOIN (
            SELECT
              PID,
              NAME,
              dateCreatedForAnee
            FROM
              (
                SELECT
                  firstAddSectionDateConceptInfo.person_id AS PID,
                  firstAddSectionDateConceptInfo.visit_id AS visitid,
                  o3.value_numeric AS NAME,
                  o3.obs_datetime AS "dateCreatedForAnee"
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
                          AND cn.name IN ("Informations TB")
                          AND cn.voided IS FALSE
                          AND cn.concept_name_type = 'FULLY_SPECIFIED'
                          AND cn.locale = 'fr'
                          AND o.voided IS FALSE
                          INNER JOIN encounter e ON e.encounter_id = o.encounter_id
                          AND e.voided IS FALSE
                        GROUP BY
                          e.visit_id
                      ) latestVisitEncounterAndVisitForConcept
                      INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
                      AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
                      AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
                      AND o2.voided IS FALSE
                      INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
                      AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
                      AND e2.voided IS FALSE
                    GROUP BY
                      latestVisitEncounterAndVisitForConcept.visit_id
                  ) firstAddSectionDateConceptInfo
                  INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
                  AND o3.voided IS FALSE
                  AND o3.concept_id = (
                    SELECT
                      concept_id
                    FROM
                      concept_name cn2
                    WHERE
                      cn2.name IN ("TB Année de depistage")
                      AND cn2.voided IS FALSE
                      AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                      AND cn2.locale = 'fr'
                  )
              ) anne
          ) totalform ON totalform.PID = Tbpre.pid
      ) AS tbFormValue ON tbPatients.person_id = tbFormValue.pid
    WHERE
      COALESCE(tbFormValue.pid, tbPatients.patientID) IS NOT NULL
      /*removing the patient which dont have program data and form data*/
  ) AS tbnew ON tbnew.pid = admdate.person_id
  LEFT JOIN (
    /* get arv details for each visit of patients  */
    SELECT
      arvPatients.person_id AS pid,
      (
        CASE WHEN ifnull(programPhaseCreate, '1981-01-01') > ifnull(obsDateTime, '1981-01-01') THEN phaseOfProg ELSE LigneARV END
      ) AS "ligneARV",
      (
        CASE WHEN ifnull(programPhaseCreate, '1981-01-01') > ifnull(obsDateTime, '1981-01-01') THEN phaseDate ELSE Datedébutligne END
      ) AS "Datedébutligne",
      DATE(enrollmentDate) AS "DatedébutARV"
    FROM
      (
        SELECT
          person.person_id,
          arv.program_id,
          arv.patientID,
          arv.enrollmentDate,
          arv.phaseDate,
          arv.date_completed,
          arv.vid,
          arv.programPhaseCreate,
          arv.phaseOfProg
        FROM
          person
          LEFT JOIN (
            SELECT
              Y.program_id,
              Y.patientID,
              Y.enrollmentDate,
              Y.phaseDate,
              Y.date_completed,
              Y.vid,
              Y.programPhaseCreate,
              Y.phaseOfProg
            FROM
              (
                SELECT
                  X.program_id,
                  X.patientID,
                  X.enrollmentDate,
                  X.phaseDate,
                  X.date_completed,
                  X.vid,
                  X.programPhaseCreate,
                  X.phaseOfProg
                FROM
                  (
                    SELECT
                      ARVprog.program_id AS program_id,
                      patientARVprog.patient_id AS patientID,
                      patientARVprog.date_enrolled AS "enrollmentDate",
                      patientPhaseOfProg.start_date AS "phaseDate",
                      patientARVprog.date_completed AS date_completed,
                      v.visit_id AS vid,
                      patientPhaseOfProg.date_created AS "programPhaseCreate",
                      (
                        CASE WHEN progWorkflowState.concept_id THEN cv.concept_full_name ELSE NULL END
                      ) AS "phaseOfProg"
                    FROM
                      patient_program patientARVprog
                      INNER JOIN program ARVprog ON ARVprog.program_id = patientARVprog.program_id
                      AND patientARVprog.voided = 0
                      LEFT JOIN patient_state patientPhaseOfProg ON patientARVprog.patient_program_id = patientPhaseOfProg.patient_program_id
                      AND patientPhaseOfProg.voided = 0
                      LEFT JOIN program_workflow_state progWorkflowState ON patientPhaseOfProg.state = progWorkflowState.program_workflow_state_id
                      LEFT JOIN concept_view cv ON progWorkflowState.concept_id = cv.concept_id
                      AND cv.retired = 0
                      INNER JOIN visit v ON v.patient_id = patientARVprog.patient_id
                    WHERE
                      ARVprog.program_id = (
                        SELECT
                          program_id
                        FROM
                          program
                        WHERE
                          `name` = "Programme ARV"
                      )
                      AND patientARVprog.voided = 0
                      AND patientPhaseOfProg.end_date IS NULL
                      AND patientPhaseOfProg.end_date IS NULL
                    GROUP BY
                      patientARVprog.patient_id,
                      patientPhaseOfProg.start_date
                    ORDER BY
                      patientPhaseOfProg.patient_program_id DESC
                  ) X
                GROUP BY
                  phaseOfProg,
                  patientID
                ORDER BY
                  phaseDate DESC
              ) Y
            GROUP BY
              patientID
          ) arv ON person.person_id = arv.patientID
      ) AS arvPatients
      LEFT JOIN (
        SELECT
          Tbpre.pid,
          (
            CASE WHEN S1 IN (
              '1ere',
              '2e',
              '3e',
              '1ere alternative',
              '2e alternative',
              '3e alternative',
              'Autres'
            ) THEN S1 ELSE NULL END
          ) AS "LigneARV",
          totalform.name AS "Datedébutligne",
          Tbpre.obs_datetime AS "obsDateTime"
        FROM
          (
            SELECT
              firstAddSectionDateConceptInfo.person_id AS pid,
              firstAddSectionDateConceptInfo.visit_id AS visitid,
              o3.value_datetime AS NAME,
              o3.obs_datetime,
              (
                SELECT
                  NAME
                FROM
                  concept_name
                WHERE
                  concept_id = o3.value_coded
                  AND locale = 'fr'
                  AND concept_name_type = 'SHORT'
              ) AS "S1"
            FROM
              (
                SELECT
                  o2.person_id,
                  latestVisitEncounterAndVisitForConcept.visit_id,
                  o2.obs_id AS firstAddSectionObsGroupId,
                  latestVisitEncounterAndVisitForConcept.concept_id
                FROM
                  (
                    SELECT
                      Y.latestEncounter,
                      Y.person_id,
                      Y.concept_id,
                      Y.visit_id
                    FROM
                      (
                        SELECT
                          X.latestEncounter,
                          X.person_id,
                          X.concept_id,
                          X.visit_id
                        FROM
                          (
                            SELECT
                              MAX(o.encounter_id) AS latestEncounter,
                              o.person_id AS person_id,
                              o.concept_id AS concept_id,
                              e.visit_id AS visit_id
                            FROM
                              obs o
                              INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
                              AND (
                                cn.name IN ("Regime actuel")
                                OR cn.name IN ("Regime Debut")
                              )
                              AND cn.voided IS FALSE
                              AND cn.concept_name_type = 'FULLY_SPECIFIED'
                              AND cn.locale = 'fr'
                              AND o.voided IS FALSE
                              INNER JOIN encounter e ON e.encounter_id = o.encounter_id
                              AND e.voided IS FALSE
                            GROUP BY
                              o.person_id,
                              o.encounter_id
                          ) AS X
                        ORDER BY
                          latestEncounter DESC
                      ) AS Y
                    GROUP BY
                      person_id
                  ) latestVisitEncounterAndVisitForConcept
                  INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
                  AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
                  AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
                  AND o2.voided IS FALSE
                  INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
                  AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
                  AND e2.voided IS FALSE
                GROUP BY
                  latestVisitEncounterAndVisitForConcept.visit_id
              ) firstAddSectionDateConceptInfo
              INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
              AND o3.voided IS FALSE
              AND o3.concept_id = (
                SELECT
                  concept_id
                FROM
                  concept_name cn2
                WHERE
                  cn2.name IN ("Ligne d'ARV")
                  AND cn2.voided IS FALSE
                  AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                  AND cn2.locale = 'fr'
              )
          ) Tbpre
          LEFT JOIN (
            SELECT
              PID,
              NAME
            FROM
              (
                SELECT
                  firstAddSectionDateConceptInfo.person_id AS PID,
                  firstAddSectionDateConceptInfo.visit_id AS visitid,
                  DATE(o3.value_datetime) AS NAME
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
                          Y.latestEncounter,
                          Y.person_id,
                          Y.concept_id,
                          Y.visit_id
                        FROM
                          (
                            SELECT
                              X.latestEncounter,
                              X.person_id,
                              X.concept_id,
                              X.visit_id
                            FROM
                              (
                                SELECT
                                  MAX(o.encounter_id) AS latestEncounter,
                                  o.person_id AS person_id,
                                  o.concept_id AS concept_id,
                                  e.visit_id AS visit_id
                                FROM
                                  obs o
                                  INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
                                  AND (
                                    cn.name IN ("Regime actuel")
                                    OR cn.name IN ("Regime Debut")
                                  )
                                  AND cn.voided IS FALSE
                                  AND cn.concept_name_type = 'FULLY_SPECIFIED'
                                  AND cn.locale = 'fr'
                                  AND o.voided IS FALSE
                                  INNER JOIN encounter e ON e.encounter_id = o.encounter_id
                                  AND e.voided IS FALSE
                                GROUP BY
                                  o.person_id,
                                  o.encounter_id
                              ) AS X
                            ORDER BY
                              latestEncounter DESC
                          ) AS Y
                        GROUP BY
                          person_id
                      ) latestVisitEncounterAndVisitForConcept
                      INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
                      AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
                      AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter
                      AND o2.voided IS FALSE
                      INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
                      AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
                      AND e2.voided IS FALSE
                    GROUP BY
                      latestVisitEncounterAndVisitForConcept.visit_id
                  ) firstAddSectionDateConceptInfo
                  INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
                  AND o3.voided IS FALSE
                  AND o3.concept_id = (
                    SELECT
                      concept_id
                    FROM
                      concept_name cn2
                    WHERE
                      cn2.name IN ("HA, Date début")
                      AND cn2.voided IS FALSE
                      AND cn2.concept_name_type = 'FULLY_SPECIFIED'
                      AND cn2.locale = 'fr'
                  )
              ) anne
          ) totalform ON totalform.PID = Tbpre.pid
      ) formData ON arvPatients.person_id = formData.pid
    WHERE
      COALESCE(formData.pid, arvPatients.patientID) IS NOT NULL
      /*removing the patient which dont have program data and form data*/
  ) arvnew ON arvnew.pid = admdate.person_id
  LEFT JOIN (
    /* get cd4 details for each visit of patients  */
    SELECT
      cd4_obs.vid AS vid,
      cd4_obs.obsdate AS CDDate,
      cd4_obs.pid AS PID,
      cd4_obs.value AS VALUE
    FROM
      (
        SELECT
          v.visit_id AS vid,
          cd4.obs_datetime AS obsdate,
          cd4.person_id AS PID,
          cd4.value_numeric AS VALUE
        FROM
          visit v
          INNER JOIN encounter e ON e.visit_id = v.visit_id
          AND e.voided IS FALSE
          AND v.voided IS FALSE
          INNER JOIN (
            SELECT
              o.encounter_id,
              o.person_id,
              o.obs_datetime,
              o.value_numeric,
              o.concept_id
            FROM
              obs o
              INNER JOIN concept_view cd4_val ON cd4_val.concept_id = o.concept_id
              AND o.voided IS FALSE
              AND cd4_val.retired IS FALSE
              AND cd4_val.concept_full_name IN ("CD4(cells/µl)")
              AND o.value_numeric IS NOT NULL
            UNION
              (
                SELECT
                  o.encounter_id,
                  o.person_id,
                  o.obs_datetime,
                  o.value_numeric,
                  o.concept_id
                FROM
                  obs o
                  INNER JOIN concept_view cd4_val ON cd4_val.concept_id = o.concept_id
                  AND o.voided IS FALSE
                  AND cd4_val.retired IS FALSE
                  AND cd4_val.concept_full_name IN ("CD4(Bilan de routine IPD)", "CD4")
                  AND o.value_numeric IS NOT NULL
              )
          ) cd4 ON cd4.encounter_id = e.encounter_id
        ORDER BY
          obsdate DESC
      ) cd4_obs
    GROUP BY
      vid
  ) AS CD ON CD.PID = admdate.person_id
  AND CD.vid = admdate.visitid
  LEFT JOIN (
    /* get Syndrome à la sortie details for each visit of patients  */
    SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id AS visitid,
      o3.value_text AS NAME
    FROM
      (
        SELECT
          o2.person_id,
          latestVisitEncounterAndVisitForConcept.visit_id,
          Min(o2.obs_id) AS firstAddSectionObsGroupId,
          latestVisitEncounterAndVisitForConcept.concept_id
        FROM
          (
            SELECT
              Max(o.encounter_id) AS latestEncounter,
              o.person_id,
              o.concept_id,
              e.visit_id
            FROM
              obs o
              INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
              AND cn.name IN ("syndrome � la sortie")
              AND cn.voided IS FALSE
              AND cn.concept_name_type = 'FULLY_SPECIFIED'
              AND cn.locale = 'fr'
              AND o.voided IS FALSE
              INNER JOIN encounter e ON e.encounter_id = o.encounter_id
              AND e.voided IS FALSE
            GROUP BY
              e.visit_id
          ) latestVisitEncounterAndVisitForConcept
          INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
          AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
          AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestencounter
          AND o2.voided IS FALSE
          INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id
          AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
          AND e2.voided IS FALSE
        GROUP BY
          latestVisitEncounterAndVisitForConcept.visit_id
      ) firstAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstaddsectionobsgroupid
      AND o3.voided IS FALSE
      AND o3.concept_id = (
        SELECT
          concept_id
        FROM
          concept_name cn2
        WHERE
          cn2.name IN ('Si autre, veuillez préciser')
          AND cn2.voided IS FALSE
          AND cn2.concept_name_type = 'FULLY_SPECIFIED'
          AND cn2.locale = 'fr'
      )
  ) AS siautre ON siautre.person_id = admdate.person_id
  AND siautre.visitid = admdate.visitid
  LEFT JOIN (
    SELECT
      latestSousARVCapturedEncounterPerVisit.patient_id,
      latestSousARVCapturedEncounterPerVisit.visit_id,
      obsAnswer.name as misSousARVAnswer
    FROM
      (
        -- Gives one encounter per visit, where concept 'Mis sous ARV en hospitalization' under form 'CSI, Sortie IPD' filled recently
        SELECT
          visit_id,
          patient_id,
          MAX(encounterAndVisitInfo.encounter_id) AS latestConceptCapturedEncounter
        FROM
          encounter encounterAndVisitInfo
          INNER JOIN obs on obs.encounter_id = encounterAndVisitInfo.encounter_id
          and obs.voided is false
          INNER JOIN concept_name conceptName on conceptName.concept_id = obs.concept_id
          and conceptName.voided is false
          and conceptName.concept_name_type = 'FULLY_SPECIFIED'
          and conceptName.locale = 'fr'
          and conceptName.name = 'Mis sous ARV en hospitalization'
        GROUP BY
          visit_id
      ) latestSousARVCapturedEncounterPerVisit
      INNER JOIN obs ON obs.encounter_id = latestConceptCapturedEncounter
      AND obs.voided IS FALSE
      INNER JOIN obs parentObs ON parentObs.obs_id = obs.obs_group_id
      AND parentObs.voided IS FALSE
      INNER JOIN obs mainFormObs ON mainFormObs.obs_id = parentObs.obs_group_id
      AND mainFormObs.voided IS FALSE
      INNER JOIN concept_name obsConcept ON obsConcept.concept_id = obs.concept_id
      AND obsConcept.voided IS FALSE
      AND obsConcept.concept_name_type = 'FULLY_SPECIFIED'
      AND obsConcept.locale = 'fr'
      AND obsConcept.name = 'Mis sous ARV en hospitalization'
      INNER JOIN concept_name parentConcept ON parentConcept.concept_id = parentObs.concept_id
      AND parentConcept.voided IS FALSE
      AND parentConcept.concept_name_type = 'FULLY_SPECIFIED'
      AND parentConcept.locale = 'fr'
      AND parentConcept.name = 'Arv à la sortie'
      INNER JOIN concept_name mainFormConcept ON mainFormConcept.concept_id = mainFormObs.concept_id
      AND mainFormConcept.voided IS FALSE
      AND mainFormConcept.concept_name_type = 'FULLY_SPECIFIED'
      AND mainFormConcept.locale = 'fr'
      AND mainFormConcept.name = 'CSI, Sortie IPD'
      LEFT JOIN concept_name obsAnswer ON obsAnswer.concept_id = obs.value_coded
      AND obsAnswer.voided IS FALSE
      AND obsAnswer.concept_name_type = 'FULLY_SPECIFIED'
      AND obsAnswer.locale = 'fr'
  ) AS misSousARV on misSousARV.patient_id = admdate.person_id
  AND misSousARV.visit_id = admdate.visitid
  LEFT JOIN (
    /*Mode de sortie from Consultation Sortie IPD  form*/
    SELECT
      latestModeDeSortieCapturedEncounterPerVisit.patient_id,
      latestModeDeSortieCapturedEncounterPerVisit.latestConceptCapturedEncounter,
      deSortieAnswer.name,
      visit_id
    FROM
      (
        SELECT
          visit_id,
          patient_id,
          MAX(encounterAndVisitInfo.encounter_id) AS latestConceptCapturedEncounter
        FROM
          encounter encounterAndVisitInfo
          INNER JOIN obs on obs.encounter_id = encounterAndVisitInfo.encounter_id
          and obs.voided is false
          INNER JOIN concept_name conceptName on conceptName.concept_id = obs.concept_id
          and conceptName.voided is false
          and conceptName.concept_name_type = 'FULLY_SPECIFIED'
          and conceptName.locale = 'fr'
          and conceptName.name = 'CSI, Mode de sortie'
        GROUP BY
          visit_id
      ) latestModeDeSortieCapturedEncounterPerVisit
      INNER JOIN obs deSortieObs on deSortieObs.encounter_id = latestModeDeSortieCapturedEncounterPerVisit.latestConceptCapturedEncounter
      and deSortieObs.voided is false
      INNER JOIN concept_name deSortieConcept on deSortieObs.concept_id = deSortieConcept.concept_id
      and deSortieConcept.concept_name_type = 'FULLY_SPECIFIED'
      and deSortieConcept.locale = 'fr'
      and deSortieConcept.name = 'CSI, Mode de sortie'
      and deSortieConcept.voided IS FALSE
      LEFT JOIN concept_name deSortieAnswer on deSortieObs.value_coded = deSortieAnswer.concept_id
      and deSortieAnswer.concept_name_type = 'SHORT'
      and deSortieAnswer.locale = 'fr'
      and deSortieAnswer.voided IS FALSE
  ) AS modeDeSortie ON modeDeSortie.patient_id = admdate.person_id
  AND modeDeSortie.visit_id = admdate.visitid
  LEFT JOIN (
    SELECT
      latestTreatmentCapturedEncounterPerVisit.patient_id,
      latestTreatmentCapturedEncounterPerVisit.visit_id,
      latestTreatmentCapturedEncounterPerVisit.latestConceptCapturedEncounter,
      latestFilledConceptAnswerPerEncounter.treatmentAnswer,
      latestFilledConceptAnswerPerEncounter.dateDebut
    FROM
      (
        -- Gives one encounter per visit, where concept 'Traitemtent TB commencé?', 'Date début' filled recently
        SELECT
          visit_id,
          patient_id,
          MAX(encounterAndVisitInfo.encounter_id) AS latestConceptCapturedEncounter
        FROM
          (
            -- Gives all valid encounters and corresponding visits
            SELECT
              patient_id,
              visit_id,
              encounter_id
            FROM
              encounter
            WHERE
              voided IS FALSE
          ) encounterAndVisitInfo
          INNER JOIN (
            -- Below select query gives all observations captured for concepts 'Traitemtent TB commencé?', 'Date début'
            SELECT
              encounter_id,
              concept_id
            FROM
              obs
            WHERE
              voided IS FALSE
              and concept_id IN (
                -- Below select query finds concept_ids of 'Traitemtent TB commencé?', 'Date début'
                SELECT
                  concept_id
                FROM
                  concept_name
                WHERE
                  voided IS FALSE
                  AND concept_name_type = 'FULLY_SPECIFIED'
                  AND locale = 'fr'
                  AND name IN ('Traitemtent TB commencé?', 'Date début')
              )
          ) treatmentAndDateDebutInfo ON treatmentAndDateDebutInfo.encounter_id = encounterAndVisitInfo.encounter_id
        GROUP BY
          visit_id
      ) latestTreatmentCapturedEncounterPerVisit
      INNER JOIN (
        -- Gives answers for recently filled concepts 'Traitemtent TB commencé?', 'Date début' along with encounter
        SELECT
          encounter_id,
          GROUP_CONCAT(treatmentAnswer.name) AS treatmentAnswer,
          GROUP_CONCAT(obs.value_datetime) AS dateDebut
        FROM
          obs
          INNER JOIN (
            -- Below select query finds concept_ids of 'Traitemtent TB commencé?', 'Date début'
            SELECT
              concept_id,
              name
            FROM
              concept_name
            WHERE
              voided IS FALSE
              AND concept_name_type = 'FULLY_SPECIFIED'
              AND locale = 'fr'
              AND name IN ('Traitemtent TB commencé?', 'Date début')
          ) treatmentAndDebutConcepts ON obs.concept_id = treatmentAndDebutConcepts.concept_id
          AND obs.voided IS FALSE
          LEFT JOIN concept_name treatmentAnswer ON obs.value_coded = treatmentAnswer.concept_id
          AND treatmentAnswer.locale = 'fr'
          AND treatmentAnswer.concept_name_type = 'FULLY_SPECIFIED'
          AND treatmentAnswer.voided IS FALSE
        GROUP BY
          encounter_id
      ) latestFilledConceptAnswerPerEncounter ON latestFilledConceptAnswerPerEncounter.encounter_id = latestTreatmentCapturedEncounterPerVisit.latestConceptCapturedEncounter
  ) AS traitmentTBCommence ON traitmentTBCommence.patient_id = admdate.person_id
  AND traitmentTBCommence.visit_id = admdate.visitid
  LEFT JOIN (
    -- getting date enrolled  for TB program
    SELECT
      pp.patient_id,
      pp.program_id,
      max(pp.date_enrolled) AS date_enrolled,
      pp.date_completed
    FROM
      patient_program pp
      INNER JOIN program p ON pp.program_id = p.program_id
      AND p.retired = 0
      AND pp.voided = 0
      AND p.name = 'Programme TB'
      and pp.date_completed is null
    WHERE
      pp.patient_id NOT IN (
        /*removing patient which have program end date before reporting date*/
        SELECT
          CASE WHEN Max(date(TBpatientProgCompletedDate.date_completed)) > Max(Date(TBpatientProgStartDate.date_enrolled)) THEN TBpatientProgCompletedDate.patient_id ELSE 0 END AS patientID
        FROM
          patient_program TBpatientProgCompletedDate
          JOIN patient_program TBpatientProgStartDate ON TBpatientProgCompletedDate.patient_id = TBpatientProgStartDate.patient_id
          AND TBpatientProgCompletedDate.program_id = TBpatientProgStartDate.program_id
        WHERE
          TBpatientProgCompletedDate.date_completed IS NOT NULL
          AND TBpatientProgCompletedDate.outcome_concept_id IS NOT NULL
          AND DATE(TBpatientProgCompletedDate.date_completed) <= DATE('#endDate#')
          AND TBpatientProgCompletedDate.voided = 0
          AND TBpatientProgCompletedDate.program_id = 2
          AND TBpatientProgStartDate.voided = 0
          AND pp.patient_id = TBpatientProgCompletedDate.patient_id
          AND DATE(TBpatientProgStartDate.date_enrolled) <= DATE('#endDate#')
        GROUP BY
          TBpatientProgCompletedDate.patient_id
      )
    GROUP BY
      pp.patient_id
  ) AS tbDateEnrolled on tbDateEnrolled.patient_id = admdate.person_id
GROUP BY
  pi.identifier,
  admdate.visitid;
