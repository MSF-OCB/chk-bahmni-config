
    Select 
    patientDetails.IDPatient as "ID Patient",
    patientDetails.TypeCohorte as "Type de  Cohorte",
    date(admdate.name) as "Date d'admission",
    patientDetails.Nom,
    patientDetails.Age,
    patientDetails.Sexe,
    patientDetails.Commune as"Commune de provenance",
    refer.C6 as "Référé en IPD par (FOSA)",
    fosa.C6 as "FOSA de suivi ARV",
    syndrome.C4 as "Syndrome à l'admission",
    syndrome.OtherComment as "Autre Syndrome",
    malade.C4 as "Malade arrivé mort",
    date(hosp1.name) as "Hospi antérieures - date d'admission 1",
    date(hosp2.name) as "Hospi antérieures - date d'admission 2",
    date(hosp3.name) as "Hospi antérieures - date d'admission 3",
    stade.C4 as "Stade OMS",
    glas.gasvalue as "Glasgow",
    genexpert.value as "GenXpert",
    TBLAM.Name as "TB-LAM",
    syp.value as "Syphills",
    crag2.value as "Crag Sang",
    crag.value as "Crag (LCR)",
    hep.value as "Hépatite B",
    hemo.value as "Hemoglobine",
    gly.value as "Glycémie",
    creat.value as "Créatinine",
    gpt.value as "GPT",
    date(hiv.name) as "Date diagnostic VIH",
    hist.C4 as "Histoire ARV",
    si.C4 as "Si interrompu",
    ligne.C4 as "Ligne ARV en cours",
    date(datelig.name) as "Date début de la ligne",
    date(datearv.name) as "Date début ARV",
    aveg.C4 as "Arrêt des ARV pendant plus d'un mois",
    tben.C4 as "TB en cours de traitement à l'admission",
    elementTB.C4 as "Elements de diagnostic TB",
    tbpre.C4 as "TB Précédentes",
    date(anndate.name) as "Année diagnostic",
    date(sortdate.name) as "Date de sortie",
    lig.C4 as "Ligne ARV sortie",
    SY.S1 as "Syndrome sortie 1",
    group_concat(distinct (dg.S1),'') as "Diagnostic principal sortie",
    SY2.S2 as "Syndrome sortie 2",
    group_concat(DISTINCT (dg2.S2),'') as "Diagnostic sortie 2",
    siautre.name as "Autre diagnostic" ,
    CD.value as "CD4 Admission",
    date(CD.CDDate) as "CD4 Date",
    CV.value as "CV Admission",
    date(CV.CVDate) as "CV Date"


    from (
    select  
                distinct pi.identifier  as "IDPatient",
                    p.person_id as "Person_ID",
                  group_concat( distinct (case when pat.name='Type de cohorte' then c.name else NULL end)) as "TypeCohorte",
                  concat(pn.family_name,' ',ifnull(pn.middle_name,''),' ', ifnull(pn.given_name,'')) as Nom,
                  concat(floor(datediff(now()   , p.birthdate)/365), ' ans, ',  floor((datediff(now(), p.birthdate)%365)/30),' mois') as "Age",
                  case when p.gender='M' then 'Homme' when p.gender='F' then 'Femme' else null end as Sexe,
                  date_format(p.birthdate, '%d/%m/%Y') as "Datedenaissance",
                  date_format(p.date_created,'%d/%m/%Y') as "Dateenregistrement",
                  group_concat( distinct  (  case when pat.name='Date entrée cohorte' then  date(pa.value)  else  null end )) As "Dateentréecohorte",
                  pad.COUNTY_DISTRICT as "Commune"
                   from  patient_identifier pi
                   join person p on p.person_id=pi.patient_id
                   join visit vda on vda.patient_id=p.person_id
                   join person_name pn on pn.person_id=p.person_id
                   left join person_attribute pa on p.person_id=pa.person_id and pa.voided=0
                   left join person_attribute_type pat on  pa.person_attribute_type_id=pat.person_attribute_type_id
                   left join person_address pad on pad.person_id=p.person_id
                   left join concept_name c on c.concept_id=pa.value and c.voided = 0 and c.locale_preferred=1
                  group by pi.identifier,vda.visit_id
    ) AS patientDetails inner JOIN visit v ON v.patient_id = patientDetails.person_id 
    inner join encounter e on e.visit_id =v.visit_id
    inner join obs o on o.encounter_id=e.encounter_id  AND v.voided IS FALSE
    left join
    (
    select          obsForActivityStatus.person_id,
                                NULL AS 'AdmissionDate',
                                NULL AS C1,
                                NULL as C2,
                                NULL AS C3,
                                NULL AS C4,
                                NULL AS 'D1',
                                NULL AS 'D2',
                                NULL AS 'C5',
                             (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded) as 'C6',
                                NULL AS C7,
                                 Date(obsForActivityStatus.obs_datetime) as 'ObsDate',
                                 vt.visit_id as visit
                                 
                                 

                from 
                 obs obsForActivityStatus 
                 
                 inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "Référé en IPD par(FOSA)"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select  answer_concept from concept_answer  where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("Référé en IPD par(FOSA)"))
                                                              
                                                          ) 
                  AND   obsForActivityStatus.voided = 0  
                  )as refer on refer.person_id=patientDetails.person_id and refer.visit=v.visit_id 
                  left join
                  (
                  select          obsForActivityStatus.person_id,
                                NULL AS 'AdmissionDate',
                                NULL AS C1,
                                NULL as C2,
                                NULL AS C3,
                                NULL AS C4,
                                NULL AS 'D1',
                                NULL AS 'D2',
                                NULL AS 'C5',
                             (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded) as 'C6',
                                NULL AS C7,
                                 Date(obsForActivityStatus.obs_datetime) as 'ObsDate',
                                 vt.visit_id as visit

                from 
                 obs obsForActivityStatus 
                 inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "FOSA de suivi ARV"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select  answer_concept from concept_answer  where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("FOSA de suivi ARV"))
                                                              
                                                          ) 
                  AND   obsForActivityStatus.voided = 0  
                  )as fosa on fosa.person_id=patientDetails.person_id and fosa.visit=v.visit_id
                  left join
                  (
                   select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                Case when (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded) = 'Autres' 
                Then (Select obsForOthers.value_text from obs obsForOthers where obsForOthers.obs_group_id = obsForActivityStatus.obs_group_id and obsForOthers.concept_id = (
                select distinct concept_id from concept_name where name ='Si autre, preciser' and locale='fr'
                and concept_name_type='FULLY_SPECIFIED') and obsForOthers.voided = 0  ) END as 'OtherComment',
                
                (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded) As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id as visit

                from 
                 obs obsForActivityStatus 
                 inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "Syndrome d'admission"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("Syndrome d'admission"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                  )as syndrome on syndrome.person_id=patientDetails.person_id and syndrome.visit=v.visit_id
                  
                  left join 
                  (
                   select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                
                
                (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id as visit

                from 
                 obs obsForActivityStatus 
                 inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "Malade arrivé mort"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("Malade arrivé mort"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                  )as malade on malade.person_id=patientDetails.person_id and malade.visit=v.visit_id
                  
                  left join
                  (
                  SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id as visit,
      o3.value_datetime AS name
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('IPD Admission Section, Hospitalisations antérieures') AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('IPD Admission, Date admission') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  ) as hosp1 on hosp1.person_id=patientDetails.person_id and  hosp1.visit=v.visit_id
                  left join
                  (
                  SELECT
      secondAddSectionDateConceptInfo.person_id,
      secondAddSectionDateConceptInfo.visit_id as visit ,
      o3.value_datetime AS name
    FROM
      (SELECT
         firstAddSectionDateConceptInfo.person_id,
         firstAddSectionDateConceptInfo.concept_id,
         firstAddSectionDateConceptInfo.latestEncounter,
         firstAddSectionDateConceptInfo.visit_id,
         MIN(o3.obs_id) AS secondAddSectionObsGroupId
       FROM
         (SELECT
            o2.person_id,
            latestVisitEncounterAndVisitForConcept.visit_id,
            MIN(o2.obs_id) AS firstAddSectionObsGroupId,
            latestVisitEncounterAndVisitForConcept.concept_id,
            latestVisitEncounterAndVisitForConcept.latestEncounter
          FROM
            (SELECT
               MAX(o.encounter_id) AS latestEncounter,
               o.person_id,
               o.concept_id,
               e.visit_id
             FROM obs o
               INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('IPD Admission Section, Hospitalisations antérieures') AND
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
         INNER JOIN obs o3 ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND
                              o3.concept_id = firstAddSectionDateConceptInfo.concept_id AND
                              o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter AND o3.voided IS FALSE
       GROUP BY firstAddSectionDateConceptInfo.visit_id) secondAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = secondAddSectionDateConceptInfo.secondAddSectionObsGroupId AND o3.voided IS FALSE
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('IPD Admission, Date admission') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  )as hosp2 on hosp2.person_id=patientDetails.person_id and hosp2.visit=v.visit_id
                  left join
                  (
                  SELECT
      thirdAddSectionDateConceptInfo.person_id,
      thirdAddSectionDateConceptInfo.visit_id as visit,
      o3.value_datetime AS name
    FROM
      (SELECT
         secondAddSectionDateConceptInfo.person_id,
         secondAddSectionDateConceptInfo.concept_id,
         secondAddSectionDateConceptInfo.latestEncounter,
         secondAddSectionDateConceptInfo.visit_id,
         MIN(o3.obs_id) AS thirdAddSectionObsGroupId
       FROM
         (SELECT
            firstAddSectionDateConceptInfo.person_id,
            firstAddSectionDateConceptInfo.concept_id,
            firstAddSectionDateConceptInfo.latestEncounter,
            firstAddSectionDateConceptInfo.visit_id,
            MIN(o3.obs_id) AS secondAddSectionObsGroupId
          FROM
            (SELECT
               o2.person_id,
               latestVisitEncounterAndVisitForConcept.visit_id,
               MIN(o2.obs_id) AS firstAddSectionObsGroupId,
               latestVisitEncounterAndVisitForConcept.concept_id,
               latestVisitEncounterAndVisitForConcept.latestEncounter
             FROM
               (SELECT
                  MAX(o.encounter_id) AS latestEncounter,
                  o.person_id,
                  o.concept_id,
                  e.visit_id
                FROM obs o
                  INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('IPD Admission Section, Hospitalisations antérieures') AND
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
            INNER JOIN obs o3 ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND
                                 o3.concept_id = firstAddSectionDateConceptInfo.concept_id AND
                                 o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter AND o3.voided IS FALSE
          GROUP BY firstAddSectionDateConceptInfo.visit_id) secondAddSectionDateConceptInfo
         INNER JOIN obs o3 ON o3.obs_id > secondAddSectionDateConceptInfo.secondAddSectionObsGroupId AND
                              o3.concept_id = secondAddSectionDateConceptInfo.concept_id AND
                              o3.encounter_id = secondAddSectionDateConceptInfo.latestEncounter AND o3.voided IS FALSE
       GROUP BY secondAddSectionDateConceptInfo.visit_id) thirdAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = thirdAddSectionDateConceptInfo.thirdAddSectionObsGroupId AND o3.voided IS FALSE
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('IPD Admission, Date admission') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  )as hosp3 on hosp3.person_id=patientDetails.person_id and hosp3.visit=v.visit_id
                  left join
                  (
                    select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                
                
                (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id  as visit

                from 
                 obs obsForActivityStatus 
                  inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "IPD Admission, Stade OMS"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("IPD Admission, Stade OMS"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                  )as stade  on stade.person_id=patientDetails.person_id and stade.visit=v.visit_id
                  left join
                  (
                   
     select obsq.person_id as "personid",
                        NULL AS 'AdmissionDate',
                        NULL AS C1,
                        obsq.value_numeric as "gasvalue" ,
                        Null As C3,
                        NULL AS C4,
                        NULL AS 'D1',
                        NULL AS 'D2',
                        NULL AS C5,
                        NULL AS C6,
                        NULL AS C7,
                        Date(obsq.obs_datetime) as "Obs_Date",
                        vt.visit_id as visit
                        from obs obsq 
                         inner join encounter et on et.encounter_id=obsq.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                        where obsq.concept_id in (
                                                    select concept_id from concept_name where name ="IPD Admission, SNC Glasgow(/15)"
                                                    and concept_name_type='FULLY_SPECIFIED' and locale='fr'
                                                 )  
                        AND obsq.voided = 0 
                       
                  ) as glas on glas.personid=patientDetails.person_id and glas.visit=v.visit_id
                  left join 
                  (
                  SELECT
      et.visit_id as visit,
      et.patient_id,
      GROUP_CONCAT(cva.concept_full_name) AS value
    FROM obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
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
      INNER JOIN concept_view cva ON cva.concept_id = oTest.value_coded AND cva.retired IS FALSE
    GROUP BY visit_id) as genexpert on genexpert.patient_id=patientDetails.person_id and genexpert.visit=v.visit_id
    left join
  (
  SELECT
  person_id,
  o.obs_datetime,
  tbLam.visit_id as visitid,
  cva.concept_full_name as Name
FROM
  obs o
  INNER JOIN concept_view cv
    ON cv.concept_id = o.concept_id AND cv.concept_full_name = 'Résultat(Option)' AND cv.retired IS FALSE AND
       o.voided IS FALSE
  INNER JOIN
  (SELECT
     et.visit_id,
     MAX(oResult.obs_datetime) AS obs_datetime
   FROM obs oTest
     INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
     INNER JOIN concept_view cvt
       ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name = 'Tests' AND oTest.voided IS FALSE AND
          cvt.retired IS FALSE
     INNER JOIN concept_view cvta
       ON cvta.concept_id = oTest.value_coded AND cvta.concept_full_name = 'TB - LAM' AND cvta.retired IS FALSE
     LEFT JOIN obs oResult ON oResult.obs_group_id = oTest.obs_group_id AND oResult.voided IS FALSE
     INNER JOIN concept_view cvr
       ON cvr.concept_id = oResult.concept_id AND cvr.concept_full_name = 'Résultat(Option)' AND
          cvr.retired IS FALSE
   GROUP BY et.visit_id
  ) tbLam
    ON tbLam.obs_datetime = o.obs_datetime
  LEFT JOIN concept_view cva ON cva.concept_id = o.value_coded AND cva.retired IS FALSE) as TBLAM on TBLAM.person_id=v.patient_id and v.visit_id=TBLAM.visitid

  
      
      
      left join
      (
       SELECT
      et.visit_id as visitid ,
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

      )as syp on syp.patient_id=patientDetails.person_id and syp.visitid=v.visit_id
      left join
      (
      SELECT
      et.visit_id as visitid,
      et.patient_id,
     MAX(cvta.concept_full_name)    AS value
    FROM obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
      INNER JOIN concept_view cvt
        ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name = 'Crag' AND oTest.voided IS FALSE AND
           cvt.retired IS FALSE
      INNER JOIN concept_view cvta
        ON cvta.concept_id = oTest.value_coded AND cvta.retired IS FALSE
    GROUP BY et.visit_id  ) as crag on crag.patient_id=patientDetails.person_id and crag.visitid=v.visit_id

    left join
    (
    SELECT
      et.visit_id as visitid,
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
    )as crag2 on crag2.patient_id=patientDetails.person_id and crag2.visitid=v.visit_id
    left join
    (
    SELECT
      et.visit_id as visitid,
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
    )as hep on hep.patient_id=patientDetails.person_id and hep.visitid=v.visit_id
    left join
    (
    SELECT
      o.person_id,
      v.visit_id as visitid,
      o.value_numeric AS value
    FROM obs o
      INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND o.voided IS FALSE AND e.voided IS FALSE
      INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided IS FALSE
      INNER JOIN concept_view cv ON cv.concept_id = o.concept_id AND
                                    cv.retired IS FALSE AND
                                    cv.concept_full_name IN
                                    ('Résultat(Numérique)', 'Hemoglobine') AND
                                    o.value_numeric IS NOT NULL
      INNER JOIN (
                   SELECT
                     v.visit_id,
                     max(test_obs.obs_datetime) AS test_obsDateTime
                   FROM visit v
                     INNER JOIN encounter e ON
                                              e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                     INNER JOIN
                     (
                       ( SELECT
                           o.encounter_id,
                           o.person_id,
                           o.obs_datetime,
                           o.value_numeric,
                           o.concept_id
                         FROM obs o
                           INNER JOIN
                           (SELECT o.obs_group_id
                            FROM obs o
                              INNER JOIN concept_view cv_q ON
                                                             o.concept_id = cv_q.concept_id AND o.voided IS FALSE AND
                                                             cv_q.retired IS FALSE AND
                                                             cv_q.concept_full_name IN ('Tests')
                              INNER JOIN concept_view cv_ans ON
                                                               cv_ans.concept_id = o.value_coded AND cv_ans.retired IS FALSE AND
                                                               cv_ans.concept_full_name IN ('Hémoglobine (Hemocue)(g/dl)')
                           ) parent_obs ON parent_obs.obs_group_id = o.obs_group_id
                           INNER JOIN concept_view cv_result ON cv_result.concept_id = o.concept_id AND
                                                                cv_result.retired IS FALSE AND
                                                                cv_result.concept_full_name IN ('Résultat(Numérique)')
                       )
                       UNION
                       ( SELECT
                           o.encounter_id,
                           o.person_id,
                           o.obs_datetime,
                           o.value_numeric,
                           o.concept_id
                         FROM obs o INNER JOIN concept_view cv_test
                             ON cv_test.concept_id = o.concept_id AND o.voided IS FALSE AND
                                cv_test.retired IS FALSE AND
                                cv_test.concept_full_name IN ('Hemoglobine') AND
                                o.value_numeric IS NOT NULL
                       )
                     ) test_obs ON test_obs.encounter_id = e.encounter_id
                   GROUP BY v.visit_id
                 ) latest_obs_test ON latest_obs_test.test_obsDateTime = o.obs_datetime AND
                                      latest_obs_test.visit_id = v.visit_id
    )as hemo on hemo.person_id=patientDetails.person_id and hemo.visitid=v.visit_id
    left join
    (
    SELECT
      o.person_id,
      v.visit_id as visitid,
      o.value_numeric AS value
    FROM obs o
      INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND o.voided IS FALSE AND e.voided IS FALSE
      INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided IS FALSE
      INNER JOIN concept_view cv ON cv.concept_id = o.concept_id AND
                                    cv.retired IS FALSE AND
                                    cv.concept_full_name IN
                                    ('Résultat(Numérique)', 'Glycémie') AND
                                    o.value_numeric IS NOT NULL
      INNER JOIN (
                   SELECT
                     v.visit_id,
                     max(test_obs.obs_datetime) AS test_obsDateTime
                   FROM visit v
                     INNER JOIN encounter e ON
                                              e.visit_id = v.visit_id AND e.voided IS FALSE AND v.voided IS FALSE
                     INNER JOIN
                     (
                       ( SELECT
                           o.encounter_id,
                           o.person_id,
                           o.obs_datetime,
                           o.value_numeric,
                           o.concept_id
                         FROM obs o
                           INNER JOIN
                           (SELECT o.obs_group_id
                            FROM obs o
                              INNER JOIN concept_view cv_q ON
                                                             o.concept_id = cv_q.concept_id AND o.voided IS FALSE AND
                                                             cv_q.retired IS FALSE AND
                                                             cv_q.concept_full_name IN ('Tests')
                              INNER JOIN concept_view cv_ans ON
                                                               cv_ans.concept_id = o.value_coded AND cv_ans.retired IS FALSE AND
                                                               cv_ans.concept_full_name IN ('Glycémie(mg/dl)')
                           ) parent_obs ON parent_obs.obs_group_id = o.obs_group_id
                           INNER JOIN concept_view cv_result ON cv_result.concept_id = o.concept_id AND
                                                                cv_result.retired IS FALSE AND
                                                                cv_result.concept_full_name IN ('Résultat(Numérique)')
                       )
                       UNION
                       ( SELECT
                           o.encounter_id,
                           o.person_id,
                           o.obs_datetime,
                           o.value_numeric,
                           o.concept_id
                         FROM obs o INNER JOIN concept_view cv_test
                             ON cv_test.concept_id = o.concept_id AND o.voided IS FALSE AND
                                cv_test.retired IS FALSE AND
                                cv_test.concept_full_name IN ('Glycémie') AND
                                o.value_numeric IS NOT NULL
                       )
                     ) test_obs ON test_obs.encounter_id = e.encounter_id
                   GROUP BY v.visit_id
                 ) latest_obs_test ON latest_obs_test.test_obsDateTime = o.obs_datetime AND
                                      latest_obs_test.visit_id = v.visit_id
    )as gly on gly.person_id=patientDetails.person_id and gly.visitid=v.visit_id
    left join
    (
    SELECT
      et.visit_id as visitid,
      et.patient_id,
      Max(oTest.value_numeric)    AS value
    FROM obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
      INNER JOIN concept_view cvt
        ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name = 'Creatinine' AND oTest.voided IS FALSE AND
           cvt.retired IS FALSE
    GROUP BY visit_id
    ) as creat on creat.patient_id=patientDetails.person_id and creat.visitid=v.visit_id
    left join
    (
    SELECT
      et.visit_id as visitid,
      et.patient_id,
      Max(oTest.value_numeric)    AS value
    FROM obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
      INNER JOIN concept_view cvt
        ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name = 'GPT' AND oTest.voided IS FALSE AND
           cvt.retired IS FALSE
    GROUP BY visit_id
    ) as gpt on gpt.patient_id=patientDetails.person_id and gpt.visitid=v.visit_id
    left join
    (
    SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id as visitid,
      o3.value_datetime AS name
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Historique ARV") AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Date diagnostic VIH(Ant)') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  ) as hiv on hiv.person_id=patientDetails.person_id and hiv.visitid=v.visit_id
                  left join
                  (
                  select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                
                
                (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id as visit

                from 
                 obs obsForActivityStatus 
                 inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "IPD Admission, Histoire ARV"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("IPD Admission, Histoire ARV"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                  )as hist on hist.person_id=patientDetails.person_id and hist.visit=v.visit_id
                  left join
                  (
                   select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                
                
                (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id as visitid

                from 
                 obs obsForActivityStatus 
                 inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "IPD Admission, Si interrompu"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("IPD Admission, Si interrompu"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                  )as si on si.person_id=patientDetails.person_id and si.visitid=v.visit_id
                  
                  left join
                  (
                   select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                
                
                (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id as visitid
                from 
                 obs obsForActivityStatus 
                 inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "IPD Admission, Ligne ARV en cours"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("IPD Admission, Ligne ARV en cours"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                  )as ligne on ligne.person_id=patientDetails.person_id and ligne.visitid=v.visit_id
                  
                  left join
                  (
                  SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id as visitid,
      o3.value_datetime AS name
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("IPD Admission Section, Histoire ARV") AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('IPD Admission, Date début de la ligne') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  ) as datelig on datelig.person_id=patientDetails.person_id and datelig.visitid=v.visit_id
                  left join
                  (
                      SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id as visitid,
      o3.value_datetime AS name
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("IPD Admission Section, Histoire ARV") AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('IPD Admission, Date début ARV') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  ) as datearv on datearv.person_id=patientDetails.person_id and datearv.visitid=v.visit_id
                  
                  left join
                  (
                  select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                
                
                (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id as visitid

                from 
                 obs obsForActivityStatus 
                  inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "IPD Admission, Avez-vous déjà arrêté les ARV pendant plus d'un mois"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("IPD Admission, Avez-vous déjà arrêté les ARV pendant plus d'un mois"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                  )as aveg on aveg.person_id=patientDetails.person_id and aveg.visitid=v.visit_id
                  
                  left join
                  (
                  select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                
                
                (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id as visitid

                from 
                 obs obsForActivityStatus 
                  inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "IPD Admission, TB en cours de traitement à l'admission"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("IPD Admission, TB en cours de traitement à l'admission"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                  )as tben on tben.person_id=patientDetails.person_id and tben.visitid=v.visit_id
                  
                  left join
                  (
                  select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                
                
                (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id as visitid

                from 
                 obs obsForActivityStatus 
                  inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "IPD Admission, Elements de diagnostic TB"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("IPD Admission, Elements de diagnostic TB"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                  )as elementTB on elementTB.person_id=patientDetails.person_id and elementTB.visitid=v.visit_id
                  
                  left join
                  (
                  
                 select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                 
                
                case when ((Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)="Premier episode") then 'Oui' 
                when ((Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)="Traité précédemment") then 'Non'
                 else null 
                  end As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id as visitid

                from 
                 obs obsForActivityStatus 
                  inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "Traitement TB Antérieur"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("Traitement TB Antérieur"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                                                          
                                                          
                  )as tbpre on tbpre.person_id=patientDetails.person_id and tbpre.visitid=v.visit_id
                  
                  left join
                  (
                                    SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id as visitid,
      o3.value_datetime AS name
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Informations TB") AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Traitement TB Antérieur') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  ) as anndate on anndate.person_id=patientDetails.person_id and anndate.visitid=v.visit_id

    left join
    (

                                    SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id as visitid,
      o3.value_datetime AS name
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Formulaire de sortie") AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Date de sortie') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'

                  ) as sortdate on sortdate.person_id=patientDetails.person_id and sortdate.visitid=v.visit_id
                  left join
                  
                  (
                  
                  
                  select  obsForActivityStatus.person_id,
                    NULL AS 'AdmissionDate',
                NULL AS C1,
                NULL AS C2,
                NULL AS C3,
                
                
                (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
                  As 'C4',
                 NULL AS 'D1',
                 NULL AS 'D2',
                 NULL AS C5,
                 NULL AS C6,
                 NULL AS C7,
                 date(obsForActivityStatus.obs_datetime) as 'obsDate',
                 vt.visit_id as visitid

                from 
                 obs obsForActivityStatus
                  inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id 
                INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  Where obsForActivityStatus.concept_id in (
                                                            select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name = "Ligne"
                                                          )
                  and obsForActivityStatus.value_coded in (
                                                            Select answer_concept from concept_answer where concept_id = 
                                                            (select
                                                              distinct concept_id
                                                            from
                                                              concept_view
                                                            where
                                                              concept_full_name in ("Ligne"))
                                                              
                                                          ) 
                                                          AND   obsForActivityStatus.voided = 0
                  )as lig on lig.person_id=patientDetails.person_id and lig.visitid=v.visit_id
                  left join 
                  ( SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id as visitid,
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Syndrome et Diagnostic') AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Syndrome') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr') as SY on SY.person_id=patientDetails.person_id
                                     and SY.visitid=v.visit_id
                  
       
                  
                  left join
                  (
                  SELECT
      secondAddSectionDateConceptInfo.person_id,
      secondAddSectionDateConceptInfo.visit_id as visitid,
      o3.value_datetime AS name,
      (select distinct name from concept_name where concept_id =o3.value_coded and locale='fr' and concept_name_type='FULLY_SPECIFIED') as "S2"
    FROM
      (SELECT
         firstAddSectionDateConceptInfo.person_id,
         firstAddSectionDateConceptInfo.concept_id,
         firstAddSectionDateConceptInfo.latestEncounter,
         firstAddSectionDateConceptInfo.visit_id,
         MIN(o3.obs_id) AS secondAddSectionObsGroupId
       FROM
         (SELECT
            o2.person_id,
            latestVisitEncounterAndVisitForConcept.visit_id,
            MIN(o2.obs_id) AS firstAddSectionObsGroupId,
            latestVisitEncounterAndVisitForConcept.concept_id,
            latestVisitEncounterAndVisitForConcept.latestEncounter
          FROM
            (SELECT
               MAX(o.encounter_id) AS latestEncounter,
               o.person_id,
               o.concept_id,
               e.visit_id
             FROM obs o
               INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Syndrome et Diagnostic') AND
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
         INNER JOIN obs o3 ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND
                              o3.concept_id = firstAddSectionDateConceptInfo.concept_id AND
                              o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter AND o3.voided IS FALSE
       GROUP BY firstAddSectionDateConceptInfo.visit_id) secondAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = secondAddSectionDateConceptInfo.secondAddSectionObsGroupId AND o3.voided IS FALSE
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Syndrome') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr')as SY2 on SY2.person_id=patientDetails.person_id
                                     and SY2.visitid=v.visit_id
                 
                 left join
                 (
                 
    SELECT
      firstAddSectionDateConceptInfo.person_id,
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Syndrome et Diagnostic') AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Fds, Diagnostic') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr') as dg on dg.person_id=patientDetails.person_id
                                     and dg.visitid=v.visit_id
                                     
                                     
                                     left join
                                     (
                                       SELECT
      secondAddSectionDateConceptInfo.person_id,
      secondAddSectionDateConceptInfo.visit_id as visitid,
      o3.value_datetime AS name,
      (select distinct name from concept_name where concept_id =o3.value_coded and locale='fr' and concept_name_type='FULLY_SPECIFIED') as "S2"
    FROM
      (SELECT
         firstAddSectionDateConceptInfo.person_id,
         firstAddSectionDateConceptInfo.concept_id,
         firstAddSectionDateConceptInfo.latestEncounter,
         firstAddSectionDateConceptInfo.visit_id ,
         MIN(o3.obs_id) AS secondAddSectionObsGroupId
       FROM
         (SELECT
            o2.person_id,
            latestVisitEncounterAndVisitForConcept.visit_id,
            MIN(o2.obs_id) AS firstAddSectionObsGroupId,
            latestVisitEncounterAndVisitForConcept.concept_id,
            latestVisitEncounterAndVisitForConcept.latestEncounter
          FROM
            (SELECT
               MAX(o.encounter_id) AS latestEncounter,
               o.person_id,
               o.concept_id,
               e.visit_id
             FROM obs o
               INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Syndrome et Diagnostic') AND
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
         INNER JOIN obs o3 ON o3.obs_id > firstAddSectionDateConceptInfo.firstAddSectionObsGroupId AND
                              o3.concept_id = firstAddSectionDateConceptInfo.concept_id AND
                              o3.encounter_id = firstAddSectionDateConceptInfo.latestEncounter AND o3.voided IS FALSE
       GROUP BY firstAddSectionDateConceptInfo.visit_id) secondAddSectionDateConceptInfo
      INNER JOIN obs o3 ON o3.obs_group_id = secondAddSectionDateConceptInfo.secondAddSectionObsGroupId AND o3.voided IS FALSE
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Fds, Diagnostic') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                                     )   dg2 on dg2.person_id=patientDetails.person_id    and dg2.visitid=v.visit_id                                                               
                 
                  left join
                  (
                    SELECT
      et.visit_id as visitid,
      et.patient_id,
      Max(oTest.value_numeric)    AS value,
      oTest.obs_datetime as CVDate
    FROM obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
      INNER JOIN concept_view cvt
        ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name in('Charge Virale - Value(Bilan de routine IPD)','Charge Virale HIV - Value') AND oTest.voided IS FALSE AND
           cvt.retired IS FALSE
    GROUP BY visit_id
    ) as CV on CV.patient_id=patientDetails.person_id and CV.visitid=v.visit_id
    left join
    (
     SELECT
      et.visit_id as visitid,
      et.patient_id,
      Max(oTest.value_numeric)    AS value,
      oTest.obs_datetime as CDDate
    FROM obs oTest
      INNER JOIN encounter et ON et.encounter_id = oTest.encounter_id AND et.voided IS FALSE
      INNER JOIN concept_view cvt
        ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name in('CD4(Bilan de routine IPD)','CD4') AND oTest.voided IS FALSE AND
           cvt.retired IS FALSE
    GROUP BY visit_id
    ) as CD on CD.patient_id=patientDetails.person_id and CD.visitid=v.visit_id
    left join
    (
    SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id as visitid,
      o3.value_text AS name
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Syndrome à la sortie") AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Si autre, veuillez préciser') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr') as siautre on siautre.person_id=
                                     patientDetails.person_id and siautre.visitid=v.visit_id
                                     inner join
                                     (
                                     SELECT
      firstAddSectionDateConceptInfo.person_id,
      firstAddSectionDateConceptInfo.visit_id as visitid,
      o3.value_datetime  AS name
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ("Admission IPD Form") AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ("IPD Admission, Date d'admission") AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr') as admdate on admdate.person_id=
                                     patientDetails.person_id and admdate.visitid=v.visit_id and date(admdate.name) between '#startDate#' and '#endDate#'
                                     group by v.visit_id,patientDetails.IDPatient;
                                    
                                                                    
