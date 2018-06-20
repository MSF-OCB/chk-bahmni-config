
    Select 
    patientDetails.IDPatient as "ID",
    patientDetails.TypeCohorte as "Type de  Cohorte",
    
    patientDetails.Nom,
    patientDetails.Age,
    patientDetails.Datedenaissance as "Date de naissance",
    patientDetails.Sexe,
    DATE_FORMAT(patientDetails.Dateentréecohorte,'%d/%m/%Y') as "Date entrée cohorte",
    refer.C6 as "Structure de référence",
    DATE_FORMAT(admdate.name,'%d/%m/%Y') as "Date d'admission",
  
    syndrome.C4 as "Syndrome à l'admission",
    group_concat(distinct (dg.S1),'') as "1er diagnostic à la sortie",
    group_concat(DISTINCT (dg2.S2),'') as "2er diagnostic à la sortie",
     DATE_FORMAT(sortdate.name,'%d/%m/%Y') as "Date de sortie",
     modi.S1 as "Mode de sortie",
    CD.value as "CD4(cells/µl)",
    DATE_FORMAT(CD.CDDATE,'%d/%m/%Y') as "Date resultat CD4",
    CV.value as "CV(copies/ml)",
    DATE_FORMAT(CV.CVDate,'%d/%m/%Y') as "Date resultat CV"


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
     select 
 dg.PID ,
 null as AdmissionDate,
 null as C1,
 null as C2,
 Null as C3,
 null as C4,
 Null as D1,Null as D2 ,
 NULL AS C5,
 NULL AS C6,
 NULL AS C7,
  visitid,
 
 obsDate,
 group_concat(distinct(dg.C10),'') as "C10"  
              from (
              select  obsForActivityStatus.person_id as PID,
                NULL AS 'AdmissionDate',
            NULL AS C1,
            NULL AS C2,
            NULL AS C3,
            Case when (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded) = 'Autres (57)' 
            Then (Select obsForOthers.value_text from obs obsForOthers where obsForOthers.obs_group_id = obsForActivityStatus.obs_group_id and obsForOthers.concept_id = (
            select concept_id from concept_name where name ="Diagnostics à l'admission non listé" and concept_name_type='FULLY_SPECIFIED' and locale='fr') and obsForOthers.voided = 0  )
            ELSE
            (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
             END As 'C10' ,
             NULL AS 'D1',
             NULL AS 'D2',
             NULL AS C5,
             NULL AS C6,
             NULL AS C7,
             null as C4,
             date(obsForActivityStatus.obs_datetime) as 'obsDate',
             vt.visit_id as visitid

            from 
             obs obsForActivityStatus 
            INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
            inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
              Where obsForActivityStatus.concept_id in (
                                                        select
                                                          distinct concept_id
                                                        from
                                                          concept_view
                                                        where
                                                          concept_full_name = "Diagnostics à l'admission"
                                                      )
              and obsForActivityStatus.value_coded in (
                                                        Select answer_concept from concept_answer where concept_id = 
                                                        (select
                                                          distinct concept_id
                                                        from
                                                          concept_view
                                                        where
                                                          concept_full_name in ("Diagnostics à l'admission"))
                                                          
                                                      ) 
                                                      AND   obsForActivityStatus.voided = 0) as dg group by dg.PID,dg.obsDate) as dgg
                                                      on dgg.PID=patientDetails.person_id and dgg.visitid=v.visit_id
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
            INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.name IN ('Formulaire de sortie') AND
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
      INNER JOIN concept_name cn2 ON cn2.concept_id = o3.concept_id AND cn2.name IN ('Mode de sortie') AND
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr') as modi on modi.person_id=patientDetails.person_id
                                     and modi.visitid=v.visit_id
                                     
                 
                  left join
                  (
                    select  obsForActivityStatus.person_id,
                NULL AS 'AdmissionDate',
            NULL AS C1,
            NULL AS C2,
            NULL AS C3,
            Case when (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded) = 'Autres' 
            Then (Select obsForOthers.value_text from obs obsForOthers where obsForOthers.obs_group_id = obsForActivityStatus.obs_group_id and obsForOthers.concept_id = (
            select concept_id from concept_name where name ='Si autre, preciser' and locale='fr' and concept_name_type='FULLY_SPECIFIED') and obsForOthers.voided = 0  )
            ELSE
            (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
             END As 'C4',
             NULL AS 'D1',
             NULL AS 'D2',
             NULL AS C5,
             NULL AS C6,
             NULL AS C7,
             date(obsForActivityStatus.obs_datetime) as 'obsDate',
              vt.visit_id as visit
          

            from 
             obs obsForActivityStatus 
            INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                  inner join encounter et on et.encounter_id=obsForActivityStatus.encounter_id
                 inner join visit vt on vt.visit_id=et.visit_id
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
      secondAddSectionDateConceptInfo.visit_id as visit ,
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
            latestVisitEncounterAndVisitForConcept.visit_id ,
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
                                                                                              ) as dg2 on dg2.person_id=patientDetails.person_id 
                                                                                              and dg2.visit=v.visit_id
                                                          
                 
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
        ON cvt.concept_id = oTest.concept_id AND cvt.concept_full_name in('Charge Virale HIV - Value') AND oTest.voided IS FALSE AND
           cvt.retired IS FALSE
    GROUP BY visit_id
    ) as CV on CV.patient_id=patientDetails.person_id and CV.visitid=v.visit_id
    left join
    (
     SELECT
      o.person_id,
      
      o.value_numeric AS value,
      o.obs_datetime as CDDATE,
      
      e.visit_id as visitid
    FROM obs o
      INNER JOIN encounter e ON e.encounter_id = o.encounter_id AND o.voided IS FALSE AND e.voided IS FALSE
      INNER JOIN visit v ON v.visit_id = e.visit_id AND v.voided IS FALSE
      INNER JOIN concept_view cv ON cv.concept_id = o.concept_id AND
                                    cv.retired IS FALSE AND
                                    cv.concept_full_name IN
                                    ('Résultat(Numérique)', '	CD4(cells/µl)') AND
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
                           o.obs_datetime ,
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
                                                               cv_ans.concept_full_name IN ('CD4(cells/µl)')
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
                                cv_test.concept_full_name IN ('CD4') AND
                                o.value_numeric IS NOT NULL
                       )
                     ) test_obs ON test_obs.encounter_id = e.encounter_id
                   GROUP BY v.visit_id
                 ) latest_obs_test ON latest_obs_test.test_obsDateTime = o.obs_datetime AND
                                      latest_obs_test.visit_id = v.visit_id
                                      
                                    
                                    
    )as CD on CD.person_id=patientDetails.person_id and CD.visitid=v.visit_id
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
      firstAddSectionDateConceptInfo.person_id as ID,
      firstAddSectionDateConceptInfo.visit_id as visitid,
      o3.value_datetime AS name,
      o3.obs_datetime
    FROM
      (SELECT
         o2.person_id,
         latestVisitEncounterAndVisitForConcept.visit_id,
         MIN(o2.obs_id) AS firstAddSectionObsGroupId,
         latestVisitEncounterAndVisitForConcept.concept_id
       FROM
         (SELECT
            max(o.encounter_id) AS latestEncounter,
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
                                     cn2.voided IS FALSE AND cn2.concept_name_type = 'FULLY_SPECIFIED' AND cn2.locale = 'fr'
                                    ) as admdate on admdate.ID=
                                     patientDetails.person_id and admdate.visitid=v.visit_id and date(admdate.name) between date('#startDate#') and Date('#endDate#')
                                     group by v.visit_id,patientDetails.IDPatient;
                                    
                                                                    
