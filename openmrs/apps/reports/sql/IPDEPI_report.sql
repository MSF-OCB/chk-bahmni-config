
    SELECT
    patientDetails.IDPatient AS "ID Patient",
    patientDetails.TypeCohorte AS "Type de  Cohorte",
    date_format(admdate.admissionDate,'%d/%m/%Y') AS "Date d'admission",
    patientDetails.Nom,
    patientDetails.Age,
    patientDetails.Sexe,
    patientDetails.Commune as"Commune de provenance",
    refer.C6 AS "Référé en IPD par (FOSA)",
    fosa.C6 AS "FOSA de suivi ARV",
    syndrome.C4 AS "Syndrome à l'admission",
    syndrome.OtherComment AS "Autre Syndrome",
    malade.C4 AS "Malade arrivé mort",
    Date_format(hosp1.name, '%d/%m/%Y') AS "Hospi antérieures - date d'admission 1",
    Date_format(hosp2.name, '%d/%m/%Y') AS "Hospi antérieures - date d'admission 2",
    Date_format(hosp3.name, '%d/%m/%Y') AS "Hospi antérieures - date d'admission 3",
    stade.C4 AS "Stade OMS",
    glas.gasvalue AS "Glasgow",
    genexpert.value AS "GenXpert",
    TBLAM.Name AS "TB-LAM",
    syp.value AS "Syphills",
    crag2.value AS "Crag Sang",
    crag.value AS "Crag (LCR)",
    hep.value AS "Hépatite B",
    hemo.value AS "Hemoglobine",
    gly.value AS "Glycémie",
    creat.value AS "Créatinine",
    gpt.value AS "GPT",
    Date_format(hiv.name, '%d/%m/%Y') AS "Date diagnostic VIH",
    hist.C4 AS "Histoire ARV",
    si.C4 AS "Si interrompu",
    arvnew.LigneARV AS "Ligne ARV en cours",
    Date_format(arvnew.Datedébutligne, '%d/%m/%Y') AS "Date début de la ligne",
    Date_format(arvnew.DatedébutARV, '%d/%m/%Y') AS "Date début ARV",
    aveg.C4 AS "Arrêt des ARV pendant plus d'un mois",
    tben.C4 AS "TB en cours de traitement à l'admission",
    elementTB.C4 AS "Elements de diagnostic TB",
    tbnew.TbPrecedents  AS "TB Précédentes",
    tbnew.Annediagnostic AS "Année diagnostic",
    date_format(sortdate.name, '%d/%m/%Y') AS "Date de sortie",
    (CASE  WHEN lig.Ligne in ("1ere","2e","3e","1ere alternative","2e alternative","3e alternative","Autres") THEN lig.Ligne
          WHEN lig.Ligne = "NoPhase" then NULL
          ELSE "Pas sous ARV" END) AS "Ligne ARV sortie",
     SY.S1 AS "Syndrome sortie 1",
    group_concat(distinct (dg.S1),'') AS "Diagnostic principal sortie",
    SY2.S2 AS "Syndrome sortie 2",
    group_concat(DISTINCT (dg2.S2),'') AS "Diagnostic sortie 2",
    siautre.name AS "Autre diagnostic" ,
    CD.value AS "CD4 Admission",
    Date_format(CD.CDDate, '%d/%m/%Y') AS "CD4 Date",
    CV.value AS "CV Admission",
    date_format(CV.CVDate, '%d/%m/%Y') AS "CV Date"


    FROM
          (
          SELECT
          distinct pi.identifier  AS "IDPatient",
          p.person_id AS "Person_ID",
          group_concat( distinct (CASE WHEN pat.name='Type de cohorte' then c.name else NULL end)) AS "TypeCohorte",
          concat(pn.family_name,' ',ifnull(pn.middle_name,''),' ', ifnull(pn.given_name,'')) AS Nom,
          concat(floor(datediff(now()   , p.birthdate)/365), ' ans, ',  floor((datediff(now(), p.birthdate)%365)/30),' mois') AS "Age",
          CASE WHEN p.gender='M' then 'Homme'
          WHEN p.gender='F' then 'Femme'
          WHEN p.gender='O' then 'Autre'
          else null end AS Sexe,
          date_format(p.birthdate, '%d/%m/%Y') AS "Datedenaissance",
          date_format(p.date_created,'%d/%m/%Y') AS "Dateenregistrement",
          group_concat( distinct  (  CASE WHEN pat.name='Date entrée cohorte' then  date(pa.value)  else  null end )) As "Dateentréecohorte",
          pad.COUNTY_DISTRICT AS "Commune"
          FROM  patient_identifier pi
          INNER JOIN person p ON p.person_id=pi.patient_id
          INNER JOIN visit vda ON vda.patient_id=p.person_id
          INNER JOIN person_name pn ON pn.person_id=p.person_id
          LEFT JOIN person_attribute pa ON p.person_id=pa.person_id AND pa.voided=0
          LEFT JOIN person_attribute_type pat ON  pa.person_attribute_type_id=pat.person_attribute_type_id
          LEFT JOIN person_address pad ON pad.person_id=p.person_id
          LEFT JOIN concept_name c ON c.concept_id=pa.value AND c.voided = 0 AND c.locale_preferred=1
          GROUP BY pi.identifier,vda.visit_id
          ) AS patientDetails
    INNER JOIN visit v ON v.patient_id = patientDetails.person_id
    INNER JOIN encounter e ON e.visit_id =v.visit_id
    INNER JOIN obs o ON o.encounter_id=e.encounter_id  AND v.voided IS FALSE
    LEFT JOIN
             (
              SELECT
              obsForActivityStatus.person_id,
              NULL AS 'AdmissionDate',
              NULL AS C1,
              NULL AS C2,
              NULL AS C3,
              NULL AS C4,
              NULL AS 'D1',
              NULL AS 'D2',
              NULL AS 'C5',
              (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded) AS 'C6',
              NULL AS C7,
              Date(obsForActivityStatus.obs_datetime) AS 'ObsDate',
              vt.visit_id AS visit

              FROM
              obs obsForActivityStatus
              INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
              INNER JOIN visit vt ON vt.visit_id=et.visit_id
              INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
              WHERE obsForActivityStatus.concept_id IN (
                                                        SELECT
                                                        distinct concept_id
                                                        FROM
                                                        concept_view
                                                        WHERE
                                                        concept_full_name = "Référé en IPD par(FOSA)"
                                                       )
              AND obsForActivityStatus.value_coded IN (
                                                        SELECT   answer_concept FROM concept_answer  WHERE concept_id =
                                                        (SELECT
                                                        distinct concept_id
                                                        FROM
                                                        concept_view
                                                        WHERE
                                                        concept_full_name IN ("Référé en IPD par(FOSA)"))
                                                      )
              AND   obsForActivityStatus.voided = 0
             ) AS refer ON refer.person_id=patientDetails.person_id AND refer.visit=v.visit_id
     LEFT JOIN
             (
              SELECT
              obsForActivityStatus.person_id,
              NULL AS 'AdmissionDate',
              NULL AS C1,
              NULL AS C2,
              NULL AS C3,
              NULL AS C4,
              NULL AS 'D1',
              NULL AS 'D2',
              NULL AS 'C5',
              (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded) AS 'C6',
              NULL AS C7,
              Date(obsForActivityStatus.obs_datetime) AS 'ObsDate',
              vt.visit_id AS visit

              FROM
              obs obsForActivityStatus
              INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
              INNER JOIN visit vt ON vt.visit_id=et.visit_id
              INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
              WHERE obsForActivityStatus.concept_id IN (
                                                        SELECT
                                                        distinct concept_id
                                                        FROM
                                                        concept_view
                                                        WHERE
                                                        concept_full_name = "FOSA de suivi ARV"
                                                       )
              AND obsForActivityStatus.value_coded IN (
                                                        SELECT   answer_concept FROM concept_answer
                                                        WHERE concept_id =
                                                        (SELECT
                                                        distinct concept_id
                                                        FROM
                                                        concept_view
                                                        WHERE
                                                        concept_full_name IN ("FOSA de suivi ARV"))
                                                      )
              AND   obsForActivityStatus.voided = 0
              ) AS fosa ON fosa.person_id=patientDetails.person_id AND fosa.visit=v.visit_id
     LEFT JOIN
              (
                SELECT   obsForActivityStatus.person_id,
                NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                Case WHEN (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded) = 'Autres'
                Then (SELECT  obsForOthers.value_text FROM obs obsForOthers WHERE obsForOthers.obs_group_id = obsForActivityStatus.obs_group_id AND obsForOthers.concept_id = (
                SELECT  distinct concept_id FROM concept_name WHERE name ='Si autre, preciser' AND locale='fr'
                AND concept_name_type='FULLY_SPECIFIED') AND obsForOthers.voided = 0  ) END AS 'OtherComment',

                (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded) As 'C4',
                NULL AS 'D1',
                NULL AS 'D2',
                NULL AS C5,
                NULL AS C6,
                NULL AS C7,
                date(obsForActivityStatus.obs_datetime) AS 'obsDate',
                vt.visit_id AS visit

                FROM
                obs obsForActivityStatus
                INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
                INNER JOIN visit vt ON vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
                WHERE obsForActivityStatus.concept_id IN (
                                                          SELECT
                                                            distinct concept_id
                                                          FROM
                                                            concept_view
                                                           WHERE
                                                            concept_full_name = "Syndrome d'admission"
                                                        )
                AND obsForActivityStatus.value_coded IN (
                                                          SELECT  answer_concept FROM concept_answer
                                                          WHERE concept_id =
                                                          (SELECT
                                                            distinct concept_id
                                                          FROM
                                                            concept_view
                                                           WHERE
                                                            concept_full_name IN ("Syndrome d'admission"))

                                                        )
                AND   obsForActivityStatus.voided = 0
              ) AS syndrome ON syndrome.person_id=patientDetails.person_id AND syndrome.visit=v.visit_id

    LEFT JOIN
              (
                SELECT   obsForActivityStatus.person_id,
                NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded)
                As 'C4',
                NULL AS 'D1',
                NULL AS 'D2',
                NULL AS C5,
                NULL AS C6,
                NULL AS C7,
                date(obsForActivityStatus.obs_datetime) AS 'obsDate',
                vt.visit_id AS visit
                FROM
                obs obsForActivityStatus
                INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
                INNER JOIN visit vt ON vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
                WHERE obsForActivityStatus.concept_id IN (
                                                          SELECT
                                                            distinct concept_id
                                                          FROM
                                                            concept_view
                                                           WHERE
                                                            concept_full_name = "Malade arrivé mort"
                                                        )
                AND obsForActivityStatus.value_coded IN (
                                                          SELECT  answer_concept FROM concept_answer
                                                          WHERE concept_id =
                                                          (SELECT
                                                            distinct concept_id
                                                          FROM
                                                            concept_view
                                                           WHERE
                                                            concept_full_name IN ("Malade arrivé mort"))

                                                        )
                AND   obsForActivityStatus.voided = 0
              ) AS malade ON malade.person_id=patientDetails.person_id AND malade.visit=v.visit_id

    LEFT JOIN
              (
              SELECT
              firstAddSectionDateConceptInfo.person_id,
              firstAddSectionDateConceptInfo.visit_id AS visit,
              o3.value_datetime AS name
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
                              FROM obs o
                              INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
                              AND cn.name IN ('IPD Admission Section, Hospitalisations antérieures')
                              AND cn.voided IS FALSE
                              AND cn.concept_name_type = 'FULLY_SPECIFIED'
                              AND cn.locale = 'fr' AND o.voided IS FALSE
                              INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                              GROUP BY e.visit_id
                            ) latestVisitEncounterAndVisitForConcept
                        INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
                        AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id
                        AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                        INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
                        AND e2.voided IS FALSE
                        GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                      ) firstAddSectionDateConceptInfo
            INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
            INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('IPD Admission, Date admission') AND
            cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

            ) AS hosp1 ON hosp1.person_id=patientDetails.person_id AND  hosp1.visit=v.visit_id
    LEFT JOIN
              (
              SELECT
              secondAddSectionDateConceptInfo.person_id,
              secondAddSectionDateConceptInfo.visit_id AS visit ,
              o3.value_datetime AS name
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
                                        FROM obs o
                                        INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('IPD Admission Section, Hospitalisations antérieures') AND
                                                                     cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                                     cn.locale = 'fr' AND o.voided IS FALSE
                                        INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                        GROUP BY e.visit_id
                                      ) latestVisitEncounterAndVisitForConcept
                                INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id
                                AND o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                                INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND e2.voided IS FALSE
                                GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                              ) firstAddSectionDateConceptInfo
                    INNER JOIN obs o3 ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId
                    AND o3.concept_id = firstAddSectionDateConceptInfo.concept_id
                    AND o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter
                    AND o3.voided IS FALSE
                    GROUP BY firstAddSectionDateConceptInfo.visit_id
                    ) secondAddSectionDateConceptInfo
              INNER JOIN obs o3 ON o3.obs_group_id = secondAddSectionDateConceptInfo.secondAddSectionObsGroupId AND o3.voided IS FALSE
              INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('IPD Admission, Date admission') AND
                                             cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
              ) AS hosp2 ON hosp2.person_id=patientDetails.person_id AND hosp2.visit=v.visit_id
    LEFT JOIN
              (
                SELECT
                thirdAddSectionDateConceptInfo.person_id,
                thirdAddSectionDateConceptInfo.visit_id AS visit,
                o3.value_datetime AS name
                FROM
                      (
                        SELECT
                        secondAddSectionDateConceptInfo.person_id,
                        secondAddSectionDateConceptInfo.concept_id,
                        secondAddSectionDateConceptInfo.latestEncounter,
                        secondAddSectionDateConceptInfo.visit_id,
                        MIN(o3.obs_id) AS thirdAddSectionObsGroupId
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
                                                        FROM obs o
                                                        INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('IPD Admission Section, Hospitalisations antérieures') AND
                                                                                      cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                                                      cn.locale = 'fr' AND o.voided IS FALSE
                                                        INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                                        GROUP BY e.visit_id
                                                    ) latestVisitEncounterAndVisitForConcept
                                              INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                                                  o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                                                  o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                                              INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                                                        e2.voided IS FALSE
                                              GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                                        ) firstAddSectionDateConceptInfo
                              INNER JOIN obs o3 ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND
                                                   o3.concept_id = firstAddSectionDateConceptInfo.concept_id AND
                                                   o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter AND o3.voided IS FALSE
                              GROUP BY firstAddSectionDateConceptInfo.visit_id
                              ) secondAddSectionDateConceptInfo
                      INNER JOIN obs o3 ON o3.obs_id > secondAddSectionDateConceptInfo.secondAddSectionObsGroupId AND
                                          o3.concept_id = secondAddSectionDateConceptInfo.concept_id AND
                                          o3.encounter_id = secondAddSectionDateConceptInfo.latestEncounter AND o3.voided IS FALSE
                      GROUP BY secondAddSectionDateConceptInfo.visit_id
                      ) thirdAddSectionDateConceptInfo
                  INNER JOIN obs o3 ON o3.obs_group_id = thirdAddSectionDateConceptInfo.thirdAddSectionObsGroupId AND o3.voided IS FALSE
                  INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('IPD Admission, Date admission') AND
                                                 cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

              ) AS hosp3 ON hosp3.person_id=patientDetails.person_id AND hosp3.visit=v.visit_id
    LEFT JOIN
              (
                  SELECT
                  obsForActivityStatus.person_id,
                  NULL AS 'AdmissionDate',
                  NULL AS C1,
                  NULL AS C2,
                  NULL AS C3,
                  (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                  NULL AS 'D1',
                  NULL AS 'D2',
                  NULL AS C5,
                  NULL AS C6,
                  NULL AS C7,
                  date(obsForActivityStatus.obs_datetime) AS 'obsDate',
                  vt.visit_id  AS visit

                  FROM
                  obs obsForActivityStatus
                  INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
                  INNER JOIN visit vt ON vt.visit_id=et.visit_id
                  INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
                  WHERE obsForActivityStatus.concept_id IN (
                                                            SELECT
                                                              distinct concept_id
                                                            FROM
                                                              concept_view
                                                             WHERE
                                                              concept_full_name = "Stade clinique OMS"
                                                          )
                  AND obsForActivityStatus.value_coded IN (
                                                            SELECT  answer_concept FROM concept_answer WHERE concept_id =
                                                            (SELECT
                                                              distinct concept_id
                                                            FROM
                                                              concept_view
                                                             WHERE
                                                              concept_full_name IN ("Stade clinique OMS"))

                                                          )
                                                          AND   obsForActivityStatus.voided = 0
                  ) AS stade  ON stade.person_id=patientDetails.person_id AND stade.visit=v.visit_id
    LEFT JOIN
                  (

                    SELECT
                    obsq.person_id AS "personid",
                    NULL AS 'AdmissionDate',
                    NULL AS C1,
                    obsq.value_numeric AS "gasvalue" ,
                    Null As C3,
                    NULL AS C4,
                    NULL AS 'D1',
                    NULL AS 'D2',
                    NULL AS C5,
                    NULL AS C6,
                    NULL AS C7,
                    Date(obsq.obs_datetime) AS "Obs_Date",
                    vt.visit_id AS visit
                    FROM obs obsq
                    INNER JOIN encounter et ON et.encounter_id=obsq.encounter_id
                    INNER JOIN visit vt ON vt.visit_id=et.visit_id
                    WHERE obsq.concept_id IN (
                                                SELECT  concept_id FROM concept_name WHERE name ="IPD Admission, SNC Glasgow(/15)"
                                                AND concept_name_type='FULLY_SPECIFIED' AND locale='fr'
                                             )
                    AND obsq.voided = 0

                  ) AS glas ON glas.personid=patientDetails.person_id AND glas.visit=v.visit_id
    LEFT JOIN
                  (
                    SELECT
                    et.visit_id AS visit,
                    et.patient_id,
                    GROUP_CONCAT(cva.concept_full_name) AS value
                    FROM obs oTest
                    INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
                    INNER JOIN concept_view cvt
                    ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name IN
                                                 ('Genexpert (Crachat)', 'Genexpert (Pus)', 'Genexpert (Gastrique)', 'Genexpert (Ascite)', 'Genexpert (Pleural)', 'Genexpert (Ganglionnaire)', 'Genexpert (Synovial)', 'Genexpert (Urine)', 'Genexpert (LCR)', 'Genexpert (LCR - Bilan de routine IPD)', 'Genexpert (Ascite - Bilan de routine IPD)', 'Genexpert (Urine - Bilan de routine IPD)', 'Genexpert (Synovial - Bilan de routine IPD)', 'Genexpert (Crachat - Bilan de routine IPD)', 'Genexpert (Pleural - Bilan de routine IPD)', 'Genexpert (Pus - Bilan de routine IPD)', 'Genexpert (Ganglionnaire - Bilan de routine IPD)', 'Genexpert (Gastrique - Bilan de routine IPD)')
                    AND oTest.voided IS FALSE AND
                    cvt.retired IS FALSE
                    INNER JOIN concept_view cva ON cva.concept_id = oTest.value_coded AND cva.retired IS FALSE
                    GROUP BY visit_id) AS genexpert ON genexpert.patient_id=patientDetails.person_id AND genexpert.visit=v.visit_id
   LEFT JOIN
                    (
                    SELECT
                    o.person_id,
                    latestEncounter.visit_id AS visitid,
                    answer_concept.name AS Name
                    FROM obs o
                    INNER JOIN encounter e ON o.encounter_id = e.encounter_id AND e.voided IS FALSE AND o.voided is false
                    INNER JOIN (SELECT
                    e.visit_id,
                    max(e.encounter_datetime) AS `encounterTime`,
                    cn.concept_id
                    FROM obs o
                    INNER JOIN concept_name cn
                    ON o.concept_id = cn.concept_id AND cn.name = 'TB - LAM' AND cn.voided IS FALSE AND
                    cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' AND o.voided IS FALSE
                    INNER JOIN encounter e ON o.encounter_id = e.encounter_id AND e.voided IS FALSE
                    GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND
                    o.concept_id = latestEncounter.concept_id
                    INNER JOIN concept_name answer_concept ON o.value_coded = answer_concept.concept_id  AND answer_concept.voided IS FALSE AND
                    answer_concept.concept_name_type = 'FULLY_SPECIFIED' AND answer_concept.locale = 'fr'
                    ) AS TBLAM ON TBLAM.person_id=v.patient_id AND v.visit_id=TBLAM.visitid

   LEFT JOIN
                    (
                    SELECT
                    et.visit_id AS visitid ,
                    et.patient_id,
                    MAX(cvta.concept_full_name)    AS value
                    FROM obs oTest
                    INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
                    INNER JOIN concept_view cvt
                    ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name = 'Syphilis' AND oTest.voided IS FALSE AND
                    cvt.retired IS FALSE
                    INNER JOIN concept_view cvta
                    ON cvta.concept_id = oTest.value_coded AND cvta.retired IS FALSE
                    GROUP BY et.visit_id

                    ) AS syp ON syp.patient_id=patientDetails.person_id AND syp.visitid=v.visit_id
  LEFT JOIN
                    (
                    SELECT
                    et.visit_id AS visitid,
                    et.patient_id,
                    MAX(cvta.concept_full_name)    AS value
                    FROM obs oTest
                    INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
                    INNER JOIN concept_view cvt
                    ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name = 'Crag' AND oTest.voided IS FALSE AND
                    cvt.retired IS FALSE
                    INNER JOIN concept_view cvta
                    ON cvta.concept_id = oTest.value_coded AND cvta.retired IS FALSE
                    GROUP BY et.visit_id
                    ) AS crag ON crag.patient_id=patientDetails.person_id AND crag.visitid=v.visit_id

    LEFT JOIN
                    (
                    SELECT
                    et.visit_id AS visitid,
                    et.patient_id,
                    MAX(cvta.concept_full_name)    AS value
                    FROM obs oTest
                    INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
                    INNER JOIN concept_view cvt
                    ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name = 'Crag serique' AND oTest.voided IS FALSE AND
                    cvt.retired IS FALSE
                    INNER JOIN concept_view cvta
                    ON cvta.concept_id = oTest.value_coded AND cvta.retired IS FALSE
                    GROUP BY et.visit_id
                    ) AS crag2 ON crag2.patient_id=patientDetails.person_id AND crag2.visitid=v.visit_id
    LEFT JOIN
                    (
                    SELECT
                    et.visit_id AS visitid,
                    et.patient_id,
                    MAX(cvta.concept_full_name)    AS value
                    FROM obs oTest
                    INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
                    INNER JOIN concept_view cvt
                    ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name = 'Hépatite B' AND oTest.voided IS FALSE AND
                    cvt.retired IS FALSE
                    INNER JOIN concept_view cvta
                    ON cvta.concept_id = oTest.value_coded AND cvta.retired IS FALSE
                    GROUP BY et.visit_id
                    ) AS hep ON hep.patient_id=patientDetails.person_id AND hep.visitid=v.visit_id
    LEFT JOIN
                    (
                    SELECT
                    v.visit_id AS visitid,
                    max(hemo_obs.obs_datetime) AS hemo_obsDateTime,
                    hemo_obs.person_id AS PID,
                    hemo_obs.value_numeric AS value
                    FROM
                    visit v
                    INNER JOIN encounter e ON e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                    INNER JOIN
                                (
                                SELECT
                                o.encounter_id,
                                o.person_id,
                                o.obs_datetime,
                                o.value_numeric,
                                o.concept_id
                                FROM obs o INNER JOIN concept_view hemo_val
                                ON hemo_val.concept_id = o.concept_id AND o.voided IS FALSE AND hemo_val.retired IS FALSE AND
                                hemo_val.concept_full_name IN ('Hémoglobine (Hemocue)(g/dl)') AND o.value_numeric IS NOT NULL

                                UNION

                                (
                                SELECT
                                o.encounter_id,
                                o.person_id,
                                o.obs_datetime,
                                o.value_numeric,
                                o.concept_id
                                FROM obs o INNER JOIN concept_view hemo_val
                                ON hemo_val.concept_id = o.concept_id AND o.voided IS FALSE AND hemo_val.retired IS FALSE AND
                                hemo_val.concept_full_name IN ('Hemoglobine') AND o.value_numeric IS NOT NULL)) hemo_obs
                                ON hemo_obs.encounter_id = e.encounter_id
                                GROUP BY v.visit_id
                    ) AS hemo ON hemo.PID=patientDetails.person_id AND hemo.visitid=v.visit_id
    LEFT JOIN
                    (
                    SELECT
                    v.visit_id AS visitid,
                    max(gly_obs.obs_datetime) AS gly_obsDateTime,
                    gly_obs.person_id AS PID,
                    gly_obs.value_numeric AS value
                    FROM visit v INNER JOIN encounter e
                    ON e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                    INNER JOIN
                              (
                              SELECT
                              o.encounter_id,
                              o.person_id,
                              o.obs_datetime,
                              o.value_numeric,
                              o.concept_id
                              FROM obs o INNER JOIN concept_view gly_val
                              ON gly_val.concept_id = o.concept_id AND o.voided IS FALSE AND gly_val.retired IS FALSE AND
                              gly_val.concept_full_name IN ('Glycémie(mg/dl)') AND o.value_numeric IS NOT NULL

                              UNION

                              (
                              SELECT
                              o.encounter_id,
                              o.person_id,
                              o.obs_datetime,
                              o.value_numeric,
                              o.concept_id
                              FROM obs o INNER JOIN concept_view gly_val
                              ON gly_val.concept_id = o.concept_id AND o.voided IS FALSE AND gly_val.retired IS FALSE AND
                              gly_val.concept_full_name IN ('Glycémie') AND o.value_numeric IS NOT NULL)
                              ) gly_obs
                    ON gly_obs.encounter_id = e.encounter_id
                    GROUP BY v.visit_id

                    ) AS gly ON gly.PID=patientDetails.person_id AND gly.visitid=v.visit_id
    LEFT JOIN
                    (
                      SELECT
                      et.visit_id AS visitid,
                      et.patient_id,
                      Max(oTest.value_numeric)    AS value
                      FROM obs oTest
                      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
                      INNER JOIN concept_view cvt
                      ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name = 'Creatinine' AND oTest.voided IS FALSE AND cvt.retired IS FALSE
                      GROUP BY visit_id
                    ) AS creat ON creat.patient_id=patientDetails.person_id AND creat.visitid=v.visit_id
    LEFT JOIN
                    (
                    SELECT
                    et.visit_id AS visitid,
                    et.patient_id,
                    Max(oTest.value_numeric)    AS value
                    FROM obs oTest
                    INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
                    INNER JOIN concept_view cvt
                    ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name = 'GPT' AND oTest.voided IS FALSE AND cvt.retired IS FALSE
                    GROUP BY visit_id
                    ) AS gpt ON gpt.patient_id=patientDetails.person_id AND gpt.visitid=v.visit_id
    LEFT JOIN
                    (
                    SELECT
                    firstAddSectionDateConceptInfo.person_id,
                    firstAddSectionDateConceptInfo.visit_id AS visitid,
                    o3.value_datetime AS name
                    FROM
                             (
                                SELECT
                                o2.person_id,
                                latestVisitEncounterAndVisitForConcept.visit_id ,
                                MIN(o2.obs_id) AS firstAddSectionObsGroupId,
                                latestVisitEncounterAndVisitForConcept.concept_id
                                FROM
                                            (
                                            SELECT
                                            MAX(o.encounter_id) AS latestEncounter,
                                            o.person_id,
                                            o.concept_id,
                                            e.visit_id
                                            FROM obs o
                                            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Historique ARV") AND
                                            cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                            cn.locale = 'fr' AND o.voided IS FALSE
                                            INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                            GROUP BY e.visit_id
                                            ) latestVisitEncounterAndVisitForConcept
                            INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                            o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                            o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                            INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id
                            AND e2.voided IS FALSE
                            GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                            ) firstAddSectionDateConceptInfo
                    INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                    INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Date diagnostic VIH(Ant)') AND cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                    ) AS hiv ON hiv.person_id=patientDetails.person_id AND hiv.visitid=v.visit_id
    LEFT JOIN
                  (
                  SELECT
                  obsForActivityStatus.person_id,
                  NULL AS 'AdmissionDate',
                  NULL AS C1,
                  NULL AS C2,
                  NULL AS C3,
                  (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                  NULL AS 'D1',
                  NULL AS 'D2',
                  NULL AS C5,
                  NULL AS C6,
                  NULL AS C7,
                  date(obsForActivityStatus.obs_datetime) AS 'obsDate',
                  vt.visit_id AS visit

                  FROM
                  obs obsForActivityStatus
                  INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
                  INNER JOIN visit vt ON vt.visit_id=et.visit_id
                  INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
                  WHERE obsForActivityStatus.concept_id IN (
                                                              SELECT
                                                              distinct concept_id
                                                              FROM
                                                              concept_view
                                                              WHERE
                                                              concept_full_name = "IPD Admission, Histoire ARV"
                                                          )
                  AND obsForActivityStatus.value_coded IN (
                                                            SELECT  answer_concept
                                                            FROM concept_answer
                                                            WHERE concept_id =
                                                                              (SELECT
                                                                              distinct concept_id
                                                                              FROM
                                                                              concept_view
                                                                              WHERE
                                                                              concept_full_name IN ("IPD Admission, Histoire ARV"))

                                                          )
                  AND   obsForActivityStatus.voided = 0
                  ) AS hist ON hist.person_id=patientDetails.person_id AND hist.visit=v.visit_id
   LEFT JOIN
                  (
                    SELECT
                    obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                    NULL AS C1,
                    NULL AS C2,
                    NULL AS C3,
                    (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded)
                    As 'C4',
                    NULL AS 'D1',
                    NULL AS 'D2',
                    NULL AS C5,
                    NULL AS C6,
                    NULL AS C7,
                    date(obsForActivityStatus.obs_datetime) AS 'obsDate',
                    vt.visit_id AS visitid

                    FROM
                    obs obsForActivityStatus
                    INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
                    INNER JOIN visit vt ON vt.visit_id=et.visit_id
                    INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
                  WHERE obsForActivityStatus.concept_id IN (
                                                            SELECT
                                                            distinct concept_id
                                                            FROM
                                                            concept_view
                                                            WHERE
                                                            concept_full_name = "IPD Admission, Si interrompu"
                                                          )
                  AND obsForActivityStatus.value_coded IN (
                                                            SELECT  answer_concept
                                                            FROM concept_answer
                                                            WHERE concept_id =
                                                            (SELECT
                                                            distinct concept_id
                                                            FROM
                                                            concept_view
                                                            WHERE
                                                            concept_full_name IN ("IPD Admission, Si interrompu"))
                                                          )
                                                          AND   obsForActivityStatus.voided = 0
                  ) AS si ON si.person_id=patientDetails.person_id AND si.visitid=v.visit_id

    LEFT JOIN
                  (
                  SELECT
                  obsForActivityStatus.person_id,
                  NULL AS 'AdmissionDate',
                  NULL AS C1,
                  NULL AS C2,
                  NULL AS C3,
                  (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                  NULL AS 'D1',
                  NULL AS 'D2',
                  NULL AS C5,
                  NULL AS C6,
                  NULL AS C7,
                  date(obsForActivityStatus.obs_datetime) AS 'obsDate',
                  vt.visit_id AS visitid
                  FROM
                  obs obsForActivityStatus
                  INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
                  INNER JOIN visit vt ON vt.visit_id=et.visit_id
                  INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
                  Where obsForActivityStatus.concept_id IN (
                                                              SELECT
                                                              distinct concept_id
                                                              FROM
                                                              concept_view
                                                              WHERE
                                                              concept_full_name = "IPD Admission, Ligne ARV en cours"
                                                          )
                  AND obsForActivityStatus.value_coded IN (
                                                              SELECT  answer_concept
                                                              FROM concept_answer
                                                              WHERE concept_id =
                                                              (SELECT
                                                              distinct concept_id
                                                              FROM
                                                              concept_view
                                                              WHERE
                                                              concept_full_name IN ("IPD Admission, Ligne ARV en cours"))

                                                          )
                  AND   obsForActivityStatus.voided = 0
                  ) AS ligne ON ligne.person_id=patientDetails.person_id AND ligne.visitid=v.visit_id

    LEFT JOIN
                  (
                  SELECT
                  firstAddSectionDateConceptInfo.person_id,
                  firstAddSectionDateConceptInfo.visit_id AS visitid,
                  o3.value_datetime AS name
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
                                  FROM obs o
                                  INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("IPD Admission Section, Histoire ARV") AND
                                                      cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                      cn.locale = 'fr' AND o.voided IS FALSE
                                  INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                  GROUP BY e.visit_id
                                  ) latestVisitEncounterAndVisitForConcept
                            INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                    o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                    o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                            INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                          e2.voided IS FALSE
                            GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                            ) firstAddSectionDateConceptInfo
                  INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                  INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('IPD Admission, Date début de la ligne') AND
                                 cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'


                  ) AS datelig ON datelig.person_id=patientDetails.person_id AND datelig.visitid=v.visit_id
    LEFT JOIN
                  (
                  SELECT
                  firstAddSectionDateConceptInfo.person_id,
                  firstAddSectionDateConceptInfo.visit_id AS visitid,
                  o3.value_datetime AS name
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
                                        FROM obs o
                                        INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("IPD Admission Section, Histoire ARV") AND
                                                              cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                              cn.locale = 'fr' AND o.voided IS FALSE
                                        INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                        GROUP BY e.visit_id
                                        ) latestVisitEncounterAndVisitForConcept
                            INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                      o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                      o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                            INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                            e2.voided IS FALSE
                            GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                            ) firstAddSectionDateConceptInfo
                  INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                  INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('IPD Admission, Date début ARV') AND
                                           cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  ) AS datearv ON datearv.person_id=patientDetails.person_id AND datearv.visitid=v.visit_id

                  LEFT JOIN
                  (
                  SELECT   obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,


                (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) AS 'obsDate',
                 vt.visit_id AS visitid

                FROM
                 obs obsForActivityStatus
                  INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
                 INNER JOIN visit vt ON vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
                  Where obsForActivityStatus.concept_id IN (
                                                            SELECT
                                                              distinct concept_id
                                                            FROM
                                                              concept_view
                                                             WHERE
                                                              concept_full_name = "IPD Admission, Avez-vous déjà arrêté les ARV pendant plus d'un mois"
                                                          )
                  AND obsForActivityStatus.value_coded IN (
                                                            SELECT  answer_concept FROM concept_answer WHERE concept_id =
                                                            (SELECT
                                                              distinct concept_id
                                                            FROM
                                                              concept_view
                                                             WHERE
                                                              concept_full_name IN ("IPD Admission, Avez-vous déjà arrêté les ARV pendant plus d'un mois"))

                                                          )
                                                          AND   obsForActivityStatus.voided = 0
                  ) AS aveg ON aveg.person_id=patientDetails.person_id AND aveg.visitid=v.visit_id

                  LEFT JOIN
                  (
                  SELECT   obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) AS 'obsDate',
                 vt.visit_id AS visitid

                FROM
                 obs obsForActivityStatus
                  INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
                 INNER JOIN visit vt ON vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
                  Where obsForActivityStatus.concept_id IN (
                                                            SELECT
                                                              distinct concept_id
                                                            FROM
                                                              concept_view
                                                             WHERE
                                                              concept_full_name = "IPD Admission, TB en cours de traitement à l'admission"
                                                          )
                  AND obsForActivityStatus.value_coded IN (
                                                            SELECT  answer_concept FROM concept_answer WHERE concept_id =
                                                            (SELECT
                                                              distinct concept_id
                                                            FROM
                                                              concept_view
                                                             WHERE
                                                              concept_full_name IN ("IPD Admission, TB en cours de traitement à l'admission"))

                                                          )
                                                          AND   obsForActivityStatus.voided = 0
                  ) AS tben ON tben.person_id=patientDetails.person_id AND tben.visitid=v.visit_id

   LEFT JOIN
                  (
                  SELECT
                  obsForActivityStatus.person_id,
                  NULL AS 'AdmissionDate',
                  NULL AS C1,
                  NULL AS C2,
                  NULL AS C3,
                  (SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                  NULL AS 'D1',
                  NULL AS 'D2',
                  NULL AS C5,
                  NULL AS C6,
                  NULL AS C7,
                  date(obsForActivityStatus.obs_datetime) AS 'obsDate',
                  vt.visit_id AS visitid

                  FROM
                  obs obsForActivityStatus
                  INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
                  INNER JOIN visit vt ON vt.visit_id=et.visit_id
                  INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
                  Where obsForActivityStatus.concept_id IN (
                                                            SELECT
                                                              distinct concept_id
                                                            FROM
                                                              concept_view
                                                             WHERE
                                                              concept_full_name = "IPD Admission, Elements de diagnostic TB"
                                                          )
                  AND obsForActivityStatus.value_coded IN (
                                                            SELECT  answer_concept FROM concept_answer WHERE concept_id =
                                                            (SELECT
                                                              distinct concept_id
                                                            FROM
                                                              concept_view
                                                             WHERE
                                                              concept_full_name IN ("IPD Admission, Elements de diagnostic TB"))

                                                          )
                                                          AND   obsForActivityStatus.voided = 0
                  ) AS elementTB ON elementTB.person_id=patientDetails.person_id AND elementTB.visitid=v.visit_id

   LEFT JOIN
                  (
                  SELECT
                  obsForActivityStatus.person_id,
                  NULL AS 'AdmissionDate',
                  NULL AS C1,
                  NULL AS C2,
                  NULL AS C3,


                  CASE WHEN ((SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded)="Premier episode") then 'Oui'
                  WHEN ((SELECT  concept_short_name FROM concept_view WHERE concept_id = obsForActivityStatus.value_coded)="Traité précédemment") then 'Non'
                  else null
                  end As 'C4',
                  NULL AS 'D1',
                  NULL AS 'D2',
                  NULL AS C5,
                  NULL AS C6,
                  NULL AS C7,
                  date(obsForActivityStatus.obs_datetime) AS 'obsDate',
                  vt.visit_id AS visitid

                  FROM
                  obs obsForActivityStatus
                  INNER JOIN encounter et ON et.encounter_id=obsForActivityStatus.encounter_id
                  INNER JOIN visit vt ON vt.visit_id=et.visit_id
                  INNER JOIN concept_view cn1 ON obsForActivityStatus.concept_id = cn1.concept_id
                  Where obsForActivityStatus.concept_id IN (
                                                            SELECT
                                                            distinct concept_id
                                                            FROM
                                                            concept_view
                                                            WHERE
                                                            concept_full_name = "Traitement TB Antérieur"
                                                            )
                  AND obsForActivityStatus.value_coded IN (
                                                            SELECT  answer_concept FROM concept_answer WHERE concept_id =
                                                            (SELECT
                                                            distinct concept_id
                                                            FROM
                                                            concept_view
                                                            WHERE
                                                            concept_full_name IN ("Traitement TB Antérieur"))

                                                            )
                  AND   obsForActivityStatus.voided = 0
                  ) AS tbpre ON tbpre.person_id=patientDetails.person_id AND tbpre.visitid=v.visit_id

   LEFT JOIN
                  (
                  SELECT
                  firstAddSectionDateConceptInfo.person_id,
                  firstAddSectionDateConceptInfo.visit_id AS visitid,
                  o3.value_datetime AS name
                  FROM
                          (
                          SELECT
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
                                                      INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Informations TB") AND
                                                                              cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                                              cn.locale = 'fr' AND o.voided IS FALSE
                                                      INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                                      GROUP BY e.visit_id
                                                      ) latestVisitEncounterAndVisitForConcept
                          INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                      o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                      o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                          INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                            e2.voided IS FALSE
                          GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                          ) firstAddSectionDateConceptInfo
                  INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                  INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Traitement TB Antérieur') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  ) AS anndate ON anndate.person_id=patientDetails.person_id AND anndate.visitid=v.visit_id

   LEFT JOIN
                  (
                  SELECT
                  firstAddSectionDateConceptInfo.person_id,
                  firstAddSectionDateConceptInfo.visit_id AS visitid,
                  o3.value_datetime AS name
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
                                        FROM obs o
                                        INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Formulaire de sortie") AND
                                                  cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                  cn.locale = 'fr' AND o.voided IS FALSE
                                        INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                        GROUP BY e.visit_id
                                        ) latestVisitEncounterAndVisitForConcept
                            INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                            o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                            o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                            INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                e2.voided IS FALSE
                            GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                            ) firstAddSectionDateConceptInfo
                  INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                  INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Date de sortie') AND
                       cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  ) AS sortdate ON sortdate.person_id=patientDetails.person_id AND sortdate.visitid=v.visit_id
   LEFT JOIN

                  (
                    select
                    patientID,
                    DateDebutARV,
                    (case when patientWithARVEnrolled.LigneARV then patientWithARVEnrolled.LigneARV else "NoPhase" end ) as "Ligne"
                    from
                            (
                            select
                            patientID,
                            (case when phaseOfProg in ("1ere","2e","3e","1ere alternative","2e alternative","3e alternative","Autres") then phaseOfProg else NULL end) as "LigneARV",
                            phaseDate as "DateDebutligne",
                            date(enrollmentDate) as "DateDebutARV"
                            FROM
                                (Select * FROM
                                              (SELECT * FROM
                                                            (
                                                            SELECT
                                                            ARVprog.program_id,
                                                            patientARVprog.patient_id as patientID,
                                                            patientARVprog.date_enrolled as "enrollmentDate",
                                                            patientPhaseOfProg.start_date as "phaseDate",
                                                            v.visit_id AS vid,
                                                            (case when progWorkflowState.concept_id then cn.name else null end) as "phaseOfProg"
                                                            from
                                                            patient_program patientARVprog
                                                            INNER JOIN program ARVprog on ARVprog.program_id = patientARVprog.program_id  and patientARVprog.voided = 0
                                                            LEFT JOIN patient_state patientPhaseOfProg on patientARVprog.patient_program_id  = patientPhaseOfProg.patient_program_id and patientPhaseOfProg.voided = 0
                                                            LEFT join program_workflow_state progWorkflowState on patientPhaseOfProg.state = progWorkflowState.program_workflow_state_id
                                                            left join concept_name cn on progWorkflowState.concept_id = cn.concept_id and cn.voided =0 and cn.locale='fr' and cn.concept_name_type='SHORT'
                                                            inner join visit v on v.patient_id = patientARVprog.patient_id


                                                            WHERE ARVprog.program_id = (select program_id from program where `name` = "Programme ARV") and patientARVprog.voided=0
                                                            and patientPhaseOfProg.end_date is null and patientARVprog.date_completed is null AND patientPhaseOfProg.end_date is null
                                                            GROUP BY patientARVprog.patient_id,patientPhaseOfProg.start_date
                                                            ORDER BY patientPhaseOfProg.patient_program_id DESC
                                                            )X
                                                            GROUP BY phaseOfProg,patientID
                                                            ORDER BY phaseDate DESC
                                              ) Y
                                              GROUP BY patientID
                                 ) AS arv
                            ) as patientWithARVEnrolled
                  ) AS lig ON lig.patientID=patientDetails.person_id
    LEFT JOIN
                  (
                  SELECT
                  firstAddSectionDateConceptInfo.person_id,
                  firstAddSectionDateConceptInfo.visit_id AS visitid,
                  o3.value_datetime AS name,
                  (SELECT  distinct name FROM concept_name WHERE concept_id =o3.value_coded AND locale='fr' AND concept_name_type='FULLY_SPECIFIED') AS "S1"
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
                                FROM obs o
                                INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Syndrome et Diagnostic') AND
                                                    cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                    cn.locale = 'fr' AND o.voided IS FALSE
                                INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                GROUP BY e.visit_id
                              ) latestVisitEncounterAndVisitForConcept
                        INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                        INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                      e2.voided IS FALSE
                        GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                      ) firstAddSectionDateConceptInfo
                  INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                  INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Syndrome') AND
                                 cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                  ) AS SY ON SY.person_id=patientDetails.person_id AND SY.visitid=v.visit_id



     LEFT JOIN
                (
                SELECT
                secondAddSectionDateConceptInfo.person_id,
                secondAddSectionDateConceptInfo.visit_id AS visitid,
                o3.value_datetime AS name,
                (SELECT  distinct name FROM concept_name WHERE concept_id =o3.value_coded AND locale='fr' AND concept_name_type='FULLY_SPECIFIED') AS "S2"
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
                                        FROM obs o
                                        INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Syndrome et Diagnostic') AND
                                                                   cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                                   cn.locale = 'fr' AND o.voided IS FALSE
                                        INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                        GROUP BY e.visit_id
                                        ) latestVisitEncounterAndVisitForConcept
                                INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                               o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                               o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                                INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                                     e2.voided IS FALSE
                                GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                                ) firstAddSectionDateConceptInfo
                        INNER JOIN obs o3 ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND
                                    o3.concept_id = firstAddSectionDateConceptInfo.concept_id AND
                                    o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter AND o3.voided IS FALSE
                        GROUP BY firstAddSectionDateConceptInfo.visit_id
                        ) secondAddSectionDateConceptInfo
                INNER JOIN obs o3 ON o3.obs_group_id = secondAddSectionDateConceptInfo.secondAddSectionObsGroupId AND o3.voided IS FALSE
                INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Syndrome') AND
                                   cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                ) AS SY2 ON SY2.person_id=patientDetails.person_id AND SY2.visitid=v.visit_id

    LEFT JOIN
                (
                SELECT
                firstAddSectionDateConceptInfo.person_id,
                firstAddSectionDateConceptInfo.visit_id AS visitid,
                o3.value_datetime AS name,
                (SELECT  distinct name FROM concept_name WHERE concept_id =o3.value_coded AND locale='fr' AND concept_name_type='FULLY_SPECIFIED') AS "S1"
                FROM
                            (
                            SELECT
                            o2.person_id,
                            latestVisitEncounterAndVisitForConcept.visit_id ,
                            MIN(o2.obs_id) AS firstAddSectionObsGroupId,
                            latestVisitEncounterAndVisitForConcept.concept_id
                            FROM
                                    (
                                    SELECT
                                    MAX(o.encounter_id) AS latestEncounter,
                                    o.person_id,
                                    o.concept_id,
                                    e.visit_id
                                    FROM obs o
                                    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Syndrome et Diagnostic') AND
                                                            cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                            cn.locale = 'fr' AND o.voided IS FALSE
                                    INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                    GROUP BY e.visit_id
                                    ) latestVisitEncounterAndVisitForConcept
                            INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                        o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                        o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                            INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                              e2.voided IS FALSE
                            GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                            ) firstAddSectionDateConceptInfo
                  INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                  INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Fds, Diagnostic') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                  ) AS dg ON dg.person_id=patientDetails.person_id  AND dg.visitid=v.visit_id


      LEFT JOIN
                  (
                  SELECT
                  secondAddSectionDateConceptInfo.person_id,
                  secondAddSectionDateConceptInfo.visit_id AS visitid,
                  o3.value_datetime AS name,
                  (SELECT  distinct name FROM concept_name WHERE concept_id =o3.value_coded AND locale='fr' AND concept_name_type='FULLY_SPECIFIED') AS "S2"
                  FROM
                          (
                          SELECT
                          firstAddSectionDateConceptInfo.person_id,
                          firstAddSectionDateConceptInfo.concept_id,
                          firstAddSectionDateConceptInfo.latestEncounter,
                          firstAddSectionDateConceptInfo.visit_id ,
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
                                            FROM obs o
                                            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Syndrome et Diagnostic') AND
                                             cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                             cn.locale = 'fr' AND o.voided IS FALSE
                                            INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                            GROUP BY e.visit_id
                                            ) latestVisitEncounterAndVisitForConcept
                                    INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                    o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                    o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                                    INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                    e2.voided IS FALSE
                                    GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                                    ) firstAddSectionDateConceptInfo
                          INNER JOIN obs o3 ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND
                          o3.concept_id = firstAddSectionDateConceptInfo.concept_id AND
                          o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter AND o3.voided IS FALSE
                          GROUP BY firstAddSectionDateConceptInfo.visit_id
                          ) secondAddSectionDateConceptInfo
                  INNER JOIN obs o3 ON o3.obs_group_id = secondAddSectionDateConceptInfo.secondAddSectionObsGroupId AND o3.voided IS FALSE
                  INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Fds, Diagnostic') AND
                  cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                  )   dg2 ON dg2.person_id=patientDetails.person_id    AND dg2.visitid=v.visit_id

      LEFT JOIN
                  (
                  SELECT
                  et.visit_id AS visitid,
                  et.patient_id,
                  Max(oTest.value_numeric)    AS value,
                  oTest.obs_datetime AS CVDate
                  FROM obs oTest
                  INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
                  INNER JOIN concept_view cvt
                  ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name in('Charge Virale - Value(Bilan de routine IPD)','Charge Virale HIV - Value') AND oTest.voided IS FALSE AND
                  cvt.retired IS FALSE
                  GROUP BY visit_id
                  ) AS CV ON CV.patient_id=patientDetails.person_id AND CV.visitid=v.visit_id


      LEFT JOIN
                  (/* Tb prec AND Anne diagnostic value */
                      SELECT  distinct tbg.patient_id
                      ,group_concat(DISTINCT (tbg.Tbprecedents)) AS "TbPrecedents"
                      ,GROUP_CONCAT(DISTINCT (tbg.Anne)) AS "Annediagnostic"
                      FROM (
                              SELECT  pp.patient_id,
                              (CASE WHEN pp.date_enrolled THEN "Oui" ELSE "Non" END ) AS "Tbprecedents"
                              ,year(pp.date_enrolled) AS "Anne"
                              FROM program p
                              LEFT JOIN patient_program pp ON pp.program_id = p.program_id
                              AND pp.date_completed IS NULL
                            ) tbg
                      GROUP BY patient_id

                  UNION ALL

                  SELECT  Tbpre.pid,
                  (CASE WHEN S1 IN ("Nouveau patient","Traité précédemment") then "Oui" else null end) AS "Tb Precedents",
                  totalform.name AS "Anne diagnostic"
                  FROM
                        (
                        SELECT
                        firstAddSectionDateConceptInfo.person_id AS pid,
                        firstAddSectionDateConceptInfo.visit_id AS visitid,
                        o3.value_datetime AS name,
                        (SELECT  distinct name FROM concept_name WHERE concept_id =o3.value_coded AND locale='fr' AND concept_name_type='FULLY_SPECIFIED') AS "S1"
                        FROM
                                (
                                SELECT
                                o2.person_id,
                                latestVisitEncounterAndVisitForConcept.visit_id ,
                                MIN(o2.obs_id) AS firstAddSectionObsGroupId,
                                latestVisitEncounterAndVisitForConcept.concept_id
                                FROM
                                                        (
                                                        SELECT
                                                        MAX(o.encounter_id) AS latestEncounter,
                                                        o.person_id,
                                                        o.concept_id,
                                                        e.visit_id
                                                        FROM obs o
                                                        INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Informations TB') AND
                                                                            cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                                            cn.locale = 'fr' AND o.voided IS FALSE
                                                        INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                                        GROUP BY e.visit_id
                                                        ) latestVisitEncounterAndVisitForConcept
                                INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                        o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                        o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                                INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                              e2.voided IS FALSE
                                GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                                ) firstAddSectionDateConceptInfo
                    INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                    INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ("Traitement TB Antérieur") AND
                                   cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                    )Tbpre
                    LEFT JOIN
                            (
                             SELECT
                             PID,
                             Name
                             FROM
                                  (
                                  SELECT
                                  firstAddSectionDateConceptInfo.person_id AS PID,
                                  firstAddSectionDateConceptInfo.visit_id AS visitid,
                                  o3.value_numeric AS name
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
                                              FROM obs o
                                              INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Informations TB") AND
                                                                  cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                                  cn.locale = 'fr' AND o.voided IS FALSE
                                              INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                              GROUP BY e.visit_id
                                              ) latestVisitEncounterAndVisitForConcept
                                        INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                                o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                                o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                                        INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                                      e2.voided IS FALSE
                                        GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                                        ) firstAddSectionDateConceptInfo
                                    INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                                    INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ("TB Année de depistage") AND
                                                   cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                                     )anne
                               )totalform ON totalform.PID=Tbpre.pid

                     ) AS tbnew ON  tbnew.patient_id=patientDetails.person_id
        LEFT JOIN   (


        /*getting data from programs */

        select
        pid,
        (case when phase then phase else null end) as "LigneARV",
        phaseDate as "Datedébutligne",
        date(DatedébutARV) as "DatedébutARV"

        from (
        select
        p.program_id,
        pp.patient_id as pid,
        pp.date_enrolled as "DatedébutARV",
        ps.start_date as phaseDate,
        (case when pws.concept_id then cn.name else null end) as phase
        from program p
        inner join patient_program pp on pp.program_id=p.program_id and p.program_id in (select  program_id from patient_program where name ="Programme ARV") and pp.date_completed is null
        inner join patient_state ps on ps.patient_program_id=pp.patient_program_id  and ps.end_date is null
        inner join program_workflow_state pws on ps.state=pws.program_workflow_state_id
        inner join concept_name cn on pws.concept_id=cn.concept_id and cn.voided =0 and cn.locale='fr' and cn.concept_name_type='SHORT')arv


        union all

        /*Getting date from forms*/
        select Tbpre.pid,
        (case when S1 in ('1ere','2e','3e','1ere alternative','2e alternative','3e alternative','autres(Ligne)') then S1 else null end) as "LigneARV",
        totalform.name as "Datedébutligne",
        null as C4
        from(
        SELECT
        firstAddSectionDateConceptInfo.person_id as pid,
        firstAddSectionDateConceptInfo.visit_id as visitid,
        o3.value_datetime AS name,
        (select distinct name from concept_name where concept_id =o3.value_coded and locale='fr' and concept_name_type='FULLY_SPECIFIED') as "S1"
        FROM
        (SELECT
        o2.person_id,
        latestVisitEncounterAndVisitForConcept.visit_id ,
        MIN(o2.obs_id) AS firstAddSectionObsGroupId,
        latestVisitEncounterAndVisitForConcept.concept_id
        FROM
        (SELECT
        MAX(o.encounter_id) AS latestEncounter,
        o.person_id,
        o.concept_id,
        e.visit_id
        FROM obs o
        INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Regime actuel","Regime Debut") AND
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
        INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ("Ligne d'ARV") AND
        cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr')Tbpre
        left join
        (
        select PID,Name from(
        SELECT
        firstAddSectionDateConceptInfo.person_id as PID,
        firstAddSectionDateConceptInfo.visit_id as visitid,
        date(o3.value_datetime) AS name
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
        INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Regime actuel","Regime Debut") AND
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
        INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ("HA, Date début") AND
        cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr')anne
        )totalform on totalform.PID=Tbpre.pid

        ) arvnew on arvnew.pid=patientDetails.person_id

    LEFT JOIN
                (
                SELECT
                et.visit_id AS visitid,
                et.patient_id,
                Max(oTest.value_numeric)    AS value,
                oTest.obs_datetime AS CDDate
                FROM obs oTest
                INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
                INNER JOIN concept_view cvt
                ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name in('CD4(Bilan de routine IPD)','CD4') AND oTest.voided IS FALSE AND
                cvt.retired IS FALSE
                GROUP BY visit_id
                ) AS CD ON CD.patient_id=patientDetails.person_id AND CD.visitid=v.visit_id
    LEFT JOIN
                (
                SELECT
                firstAddSectionDateConceptInfo.person_id,
                firstAddSectionDateConceptInfo.visit_id AS visitid,
                o3.value_text AS name
                FROM
                        (
                        SELECT
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
                                  INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Syndrome à la sortie") AND
                                                            cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                            cn.locale = 'fr' AND o.voided IS FALSE
                                  INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                  GROUP BY e.visit_id
                                  ) latestVisitEncounterAndVisitForConcept
                        INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                                      o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                                      o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                        INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                                            e2.voided IS FALSE
                        GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                        ) firstAddSectionDateConceptInfo
                INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Si autre, veuillez préciser') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                 ) AS siautre ON siautre.person_id = patientDetails.person_id AND siautre.visitid=v.visit_id
    INNER JOIN
                (
                SELECT
                firstAddSectionDateConceptInfo.person_id,
                firstAddSectionDateConceptInfo.visit_id AS visitid,
                o3.value_datetime  AS "admissionDate"
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
                                  FROM obs o
                                  INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Admission IPD Form") AND
                                      cn.voided IS FALSE AND cn.concept_name_type = 'FULLY_SPECIFIED' AND
                                      cn.locale = 'fr' AND o.voided IS FALSE
                                  INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND e.voided IS FALSE
                                  GROUP BY e.visit_id
                                  ) latestVisitEncounterAndVisitForConcept
                          INNER JOIN obs o2 ON o2.person_id = latestVisitEncounterAndVisitForConcept.person_id AND
                          o2.concept_id = latestVisitEncounterAndVisitForConcept.concept_id AND
                          o2.encounter_id = latestVisitEncounterAndVisitForConcept.latestEncounter AND o2.voided IS FALSE
                          INNER JOIN encounter e2 ON o2.encounter_id = e2.encounter_id AND e2.visit_id = latestVisitEncounterAndVisitForConcept.visit_id AND
                          e2.voided IS FALSE
                          GROUP BY latestVisitEncounterAndVisitForConcept.visit_id
                          ) firstAddSectionDateConceptInfo
                INNER JOIN obs o3 ON o3.obs_group_id = firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND o3.voided IS FALSE
                INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ("IPD Admission, Date d'admission") AND
                cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                ) AS admdate ON admdate.person_id = patientDetails.person_id AND admdate.visitid=v.visit_id
                AND date(admdate.admissionDate) between DATE('#startDate#') AND DATE('#endDate#')
                GROUP BY v.visit_id,patientDetails.IDPatient;
