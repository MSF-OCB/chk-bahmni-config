
Select patientDetails.IDPatient as "ID",
patientDetails.TypeCohorte as "Type Cohorte",
patientDetails.Nom,
patientDetails.Age,
patientDetails.Datedenaissance AS "Date de naissance",
patientDetails.Sexe,
patientDetails.Dateentréecohorte AS "Date entrée cohorte",
patientOtherDetails.Structurederéférence AS "Structure de référence",
patientDateOfAdmission.AdmissionDate AS "Date Admission",
patientOtherDetails.Syndromedadmission AS "Syndrome à l'admission",
patientOtherDetails.Diag as "Diagnostics à l'admission",
patientOtherDetails.1erdiagnostic AS "1er diagnostic à la sortie",
patientOtherDetails.2ediagnostic AS "2e diagnostic à la sortie",
patientOtherDetails.DateDeSortie AS "Date de sortie",
patientOtherDetails.Modedesortie AS "Mode de sortie",
patientOtherDetails.CD4 AS "CD4(cells/µl)",
patientOtherDetails.DateresultatCD4 AS "Date resultat CD4",
patientOtherDetails.CV AS "CV(copies/ml)",
patientOtherDetails.DateresultatCV as "Date resultat CV"
 from 
(       
    select 
            distinct pi.identifier  as "IDPatient",
                p.person_id,
              group_concat( distinct (case when pat.name='Type de cohorte' then c.name else NULL end)) as "TypeCohorte",
              concat(pn.family_name,' ',ifnull(pn.middle_name,''),' ', ifnull(pn.given_name,'')) as Nom,
              concat(floor(datediff(now(), p.birthdate)/365), ' ans, ',  floor((datediff(now(), p.birthdate)%365)/30),' mois') as "Age",
              case when p.gender='M' then 'Homme' when p.gender='F' then 'Femme' else null end as Sexe,
              date_format(p.birthdate, '%d/%m/%Y') as "Datedenaissance",
              date_format(p.date_created,'%d/%m/%Y') as "Dateenregistrement",
              group_concat( distinct  (  case when pat.name='Date entrée cohorte' then  date(pa.value)  else  null end )) As "Dateentréecohorte"
               from  patient_identifier pi
               join person p on p.person_id=pi.patient_id
               join person_name pn on pn.person_id=p.person_id
               left join person_attribute pa on p.person_id=pa.person_id and pa.voided=0
               left join person_attribute_type pat on  pa.person_attribute_type_id=pat.person_attribute_type_id
               left join person_address pad on pad.person_id=p.person_id
               left join concept_name c on c.concept_id=pa.value and c.voided = 0 and c.locale_preferred=1
              group by pi.identifier
) AS patientDetails
       Inner Join 
(
            Select 
            person_id,
            Max(C1) aS "CD4",
            Case when Max(C1) is not NULL then Max(dateResultCD4) END AS "DateresultatCD4",
            Max(C2) AS "MeilleurePriseEnCharge",
            Max(C3) as "DateDeSortie",
            Max(C4) as "Syndromedadmission",
            MAX(C10) as "Diag",
            Max(D1) AS "1erdiagnostic",
            Max(D2) AS "2ediagnostic",
            MAX(C5) as "Modedesortie",
            MAX(C6) AS "Structurederéférence",
            MAX(C7) AS "CV",
            Case when Max(C7) is not NULL then Max(dateResultCD4) END AS "DateresultatCV",
            Max(dateResultCD4) as "dateResultCD4"

             from (
             /*CD4 result C1*/
                            select 
                            obsForActivityStatus.person_id,
                            NULL AS 'AdmissionDate',
                            obsForresult.value_numeric AS C1,
                            NULL as C2,
                            NULL AS C3,
                            NULL AS C4,
                            NULL AS 'D1',
                            NULL AS 'D2',
                            NULL AS C5,
                            NULL AS C6,
                            NULL AS C7,
                            Date(obsForActivityStatus.obs_datetime) AS dateResultCD4,
                            null as C10
                            from 
                             obs obsForActivityStatus 
                            INNER JOIN concept_name cn1 on obsForActivityStatus.value_coded = cn1.concept_id AND cn1.voided = 0
                              and obsForActivityStatus.concept_id in (
                              select
                                                                          distinct concept_id
                                                                        from
                                                                          concept_view
                                                                        where
                                                                          concept_full_name = 'Tests'
                                                                      )
                              and obsForActivityStatus.value_coded in (
                                                                        select
                                                                          distinct concept_id
                                                                        from
                                                                          concept_view
                                                                        where
                                                                          concept_full_name = 'CD4(cells/µl)'
                                                                      ) 
                             and obsForActivityStatus.voided =0
                             
                            INNER JOIN obs obsForresult on obsForActivityStatus.obs_group_id = obsForresult.obs_group_id


                              and obsForresult.concept_id in (
                                                                        select
                                                                          distinct concept_id
                                                                        from
                                                                          concept_view
                                                                        where
                                                                          concept_full_name = 'Résultat(Numérique)'
                                                                      )
                            and obsForresult.voided =0
                            Inner Join (
                                                Select person_id, max(obs_datetime)  as maxObsDateTime 
                                                  from 
                                                 obs obsForActivityStatus 

                                                INNER JOIN concept_name cn1 on obsForActivityStatus.value_coded = cn1.concept_id AND cn1.voided = 0
                                                  and obsForActivityStatus.concept_id in (
                                                  select
                                                                                              distinct concept_id
                                                                                            from
                                                                                              concept_view
                                                                                            where
                                                                                              concept_full_name = 'Tests'
                                                                                          )
                                                  and obsForActivityStatus.value_coded in (
                                                                                            select
                                                                                              distinct concept_id
                                                                                            from
                                                                                              concept_view
                                                                                            where
                                                                                              concept_full_name = 'CD4(cells/µl)'
                                                                                          ) 
                                                 and obsForActivityStatus.voided =0
                                                 group by obsForActivityStatus.person_id

                            ) as maxResultDatePerPatient
                            On maxResultDatePerPatient.person_id = obsForActivityStatus.person_id
                            And maxResultDatePerPatient.maxObsDateTime = obsForActivityStatus.obs_datetime
                              GROUP BY obsForActivityStatus.person_id,obsForActivityStatus.obs_datetime
                              
                              Union 
                              
                            Select  
                            obsForLabTestResultFromElis.person_id,
                            NULL AS 'AdmissionDate',
                            obsForLabTestResultFromElis.value_numeric as C1,
                            NULL as C2,
                            Null AS C3,
                            NULL AS C4,
                             NULL AS 'D1',
                            NULL AS 'D2',
                            NULL AS C5,
                            NULL AS C6,
                            NULL AS C7,
                            Date(obsForLabTestResultFromElis.obs_datetime) as 'dateResultCD4',
                            null as C10
                            from 
                             obs obsForLabTestResultFromElis 
                            Inner Join
                                        (
                                                        Select person_id,
                                                        Max(obsForLabTestResultFromElis.obs_datetime) maxDatetime 
                                                        from 
                                                         obs obsForLabTestResultFromElis 
                                                        INNER JOIN concept_name cn1 on obsForLabTestResultFromElis.concept_id = cn1.concept_id AND cn1.voided = 0
                                                          and obsForLabTestResultFromElis.concept_id in (
                                                          select
                                                                                                      distinct concept_id
                                                                                                    from
                                                                                                      concept_view
                                                                                                    where
                                                                                                      concept_full_name = 'CD4'
                                                                                                  )
                                                          Where obsForLabTestResultFromElis.voided = 0                                       
                                                      group by person_id
                                         ) AS maxResultForCd4LabTest
                            On maxResultForCd4LabTest.person_id = obsForLabTestResultFromElis.person_id
                            And maxResultForCd4LabTest.maxDatetime = obsForLabTestResultFromElis.obs_datetime
                            Where obsForLabTestResultFromElis.voided=0
                              and obsForLabTestResultFromElis.concept_id in (
                                                                                    select
                                                                                  distinct concept_id
                                                                                from
                                                                                  concept_view
                                                                                where
                                                                                  concept_full_name = 'CD4'
                                                                             )
                              AND obsForLabTestResultFromElis.value_numeric is not null 


            UNION ALL

            /*Meilleure Prise En Charge C2*/

                    select obsq.person_id as "personid",
                    NULL AS 'AdmissionDate',
                    NULL AS C1,
                    obsq.value_text as "Meilleure_prise_en_charge" ,
                    Null As C3,
                    NULL AS C4,
                    NULL AS 'D1',
                    NULL AS 'D2',
                    NULL AS C5,
                    NULL AS C6,
                    NULL AS C7,
                    Date(obsq.obs_datetime) as "Obs_Date",
                     null as C10
                    from obs obsq 
                    where obsq.concept_id in (
                                                select concept_id from concept_name where name ="Meilleure prise en charge"
                                                and concept_name_type='FULLY_SPECIFIED' and locale='fr'
                                             )  
                    AND obsq.voided = 0
                    
                    Union ALL
                    
                    /*Date De Sortie C3*/
                    
                    select obsq.person_id as 'personid',
                    NULL AS 'AdmissionDate',
                    Null as C1,
                    Null As C2,
                date(obsq.value_datetime) as C3,
                NULL AS C4,
                NULL AS 'D1',
                NULL AS 'D2',
                NULL AS C5,
                NULL AS C6,
                NULL AS C7,
                
                date(obsq.obs_datetime) as 'obsDate',
                null as C10
                from obs obsq 
                where obsq.concept_id in (
                                            select concept_id from concept_name where name ="Date de sortie"
                                            and concept_name_type='FULLY_SPECIFIED' and locale='fr'
                                         )  
                AND obsq.voided = 0
                
                Union ALL
                
                /*Syndrome d'admission C4*/
                select  obsForActivityStatus.person_id,
                NULL AS 'AdmissionDate',
            NULL AS C1,
            NULL AS C2,
            NULL AS C3,
            Case when (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded) = 'Autres' 
            Then (Select obsForOthers.value_text from obs obsForOthers where obsForOthers.obs_group_id = obsForActivityStatus.obs_group_id and obsForOthers.concept_id = (
            select concept_id from concept_name where name ='Si autre, preciser' and concept_name_type='FULLY_SPECIFIED' and locale='fr') and obsForOthers.voided = 0  )
            ELSE
            (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded)
             END As 'C4',
             NULL AS 'D1',
             NULL AS 'D2',
             NULL AS C5,
             NULL AS C6,
             NULL AS C7,
             date(obsForActivityStatus.obs_datetime) as 'obsDate',
             null as C10

            from 
             obs obsForActivityStatus 
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
                                                      
            Union ALL
            
            
             
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
             date(obsForActivityStatus.obs_datetime) as 'obsDate'

            from 
             obs obsForActivityStatus 
            INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
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
                                                      AND   obsForActivityStatus.voided = 0) as dg group by dg.PID,dg.obsDate
                                                      union all
/*Exit diagnosis D1 and D2*/
            Select      A.person_id,
            A.AdmissionDate,
            Null AS C1,
            Null AS C2,
            Null AS C3,
            Null AS C4,
            A.D1,
            A.D2,
            NULL AS C5,
            NULL AS C6,
            NULL AS C7,
            Date(encounter_datetime) as obsDate,
            null as C10
             from (
             Select A.person_id,
                                A.AdmissionDate,
                                A.Diagnosis as D1,
                                B.Diagnosis as D2,
                                A.ActivityStatusDateCreated,
                                B.obs_group_id,
                                A.ActivityStatusEncounterID,
                                A.AdmissionEncounterID,
                                A.encounter_datetime
                                 from (
                                                    select  obsForActivityStatus.person_id,
                                                    obsForActivityStatus.obs_group_id,
                                                    toGetAdmissionDateTime.value_datetime as 'AdmissionDate',
                                                    toGetAdmissionDateTime.date_created AS 'AdmissionDateCreated',
                                                    obsForActivityStatus.date_created AS 'ActivityStatusDateCreated',
                                                    Group_concat( (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded )) As 'Diagnosis',
                                                    obsForActivityStatus.encounter_id AS "ActivityStatusEncounterID",
                                                    toGetAdmissionDateTime.encounter_id  AS "AdmissionEncounterID",
                                                    patientEncounter.encounter_datetime
                                                    from 
                                                    obs obsForActivityStatus 
                                                    Inner join encounter patientEncounter
                                                    on patientEncounter.encounter_id = obsForActivityStatus.encounter_id
                                                    INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                                                    Left Join obs toGetAdmissionDateTime
                                                    on toGetAdmissionDateTime.obs_group_id = obsForActivityStatus.obs_group_id
                                                    And toGetAdmissionDateTime.concept_id = (select concept_id from concept_name where name ='IPD Admission, Date admission'
                                                    and locale='fr' and concept_name_type='FULLY_SPECIFIED')
                                                    AND toGetAdmissionDateTime.voided = 0
                                                      Where obsForActivityStatus.concept_id in (
                                                                                                select
                                                                                                  distinct concept_id
                                                                                                from
                                                                                                  concept_view
                                                                                                where
                                                                                                  concept_full_name = "IPD Admission, Diagnostics de sortie"
                                                                                              )
                                                      and obsForActivityStatus.value_coded in (
                                                                                                Select answer_concept from concept_answer where concept_id = 
                                                                                                (select
                                                                                                  distinct concept_id
                                                                                                from
                                                                                                  concept_view
                                                                                                where
                                                                                                  concept_full_name in ("IPD Admission, Diagnostics de sortie"))
                                                                                                  
                                                                                              ) 
                                                                                              AND   obsForActivityStatus.voided = 0
                                                                                             --  AND obsForActivityStatus.person_id = 9987
                                                                                              group by person_id, obs_group_id
                                ) as A
                                LEFT join
                                (
                                                    select  obsForActivityStatus.person_id,
                                                    obsForActivityStatus.obs_group_id,
                                                    toGetAdmissionDateTime.value_datetime as 'AdmissionDate',
                                                    toGetAdmissionDateTime.date_created AS 'AdmissionDateCreated',
                                                    obsForActivityStatus.date_created AS 'ActivityStatusDateCreated',
                                                    Group_concat( (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded )) As 'Diagnosis',
                                                    obsForActivityStatus.encounter_id AS "ActivityStatusEncounterID",
                                                    toGetAdmissionDateTime.encounter_id  AS "AdmissionEncounterID",
                                                    patientEncounter.encounter_datetime
                                                    from 
                                                    obs obsForActivityStatus 
                                                    Inner join encounter patientEncounter
                                                    on patientEncounter.encounter_id = obsForActivityStatus.encounter_id
                                                    INNER JOIN concept_view cn1 on obsForActivityStatus.concept_id = cn1.concept_id 
                                                    Left Join obs toGetAdmissionDateTime
                                                    on toGetAdmissionDateTime.obs_group_id = obsForActivityStatus.obs_group_id
                                                    And toGetAdmissionDateTime.concept_id =  (select concept_id from concept_name where name ='IPD Admission, Date admission'
                                                    and locale='fr' and concept_name_type='FULLY_SPECIFIED')
                                                    AND toGetAdmissionDateTime.voided = 0
                                                      Where obsForActivityStatus.concept_id in (
                                                                                                select
                                                                                                  distinct concept_id
                                                                                                from
                                                                                                  concept_view
                                                                                                where
                                                                                                  concept_full_name = "IPD Admission, Diagnostics de sortie"
                                                                                              )
                                                      and obsForActivityStatus.value_coded in (
                                                                                                Select answer_concept from concept_answer where concept_id = 
                                                                                                (select
                                                                                                  distinct concept_id
                                                                                                from
                                                                                                  concept_view
                                                                                                where
                                                                                                  concept_full_name in ("IPD Admission, Diagnostics de sortie"))
                                                                                                  
                                                                                              ) 
                                                                                              AND   obsForActivityStatus.voided = 0
                                                                                              -- AND obsForActivityStatus.person_id = 9987
                                                                                              group by person_id, obs_group_id



                                ) as B
                                On A.person_id = B.person_id
                                And A.AdmissionEncounterID = B.ActivityStatusEncounterID
                                AND A.obs_group_id != B.obs_group_id
                                Where A.AdmissionDate is not null OR B.AdmissionDate is not null
                                Order by A.AdmissionDate,
                                A.ActivityStatusDateCreated,B.obs_group_id
            ) AS A

            Union ALL
            /*Mode de sortie C5*/
            select          
                            obsq.person_id as 'personid',
                            NULL AS 'AdmissionDate',
                            NULL AS C1,
                            NULL as C2,
                            NULL AS C3,
                            NULL AS C4,
                            NULL AS 'D1',
                            NULL AS 'D2',
                (Select concept_full_name from concept_view where concept_id = obsq.value_coded) as 'C5',
                NULL AS C6,
                NULL AS C7,
                date(obsq.obs_datetime) as 'obsDate',
                null as C10
                from obs obsq 
                where obsq.concept_id in (
                                            select concept_id from concept_name where name ="Mode de sortie"
                                            and concept_name_type='FULLY_SPECIFIED' and locale='fr'
                                         )  
                AND obsq.voided = 0

            UNION ALL

            /*Structure de référence C6*/
            select          obsForActivityStatus.person_id,
                            NULL AS 'AdmissionDate',
                            NULL AS C1,
                            NULL as C2,
                            NULL AS C3,
                            NULL AS C4,
                            NULL AS 'D1',
                            NULL AS 'D2',
                            NULL AS 'C5',
                            Case when (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded) = 'Autres' 
                            Then (Select obsForOthers.value_text from obs obsForOthers where obsForOthers.obs_group_id = obsForActivityStatus.obs_group_id and obsForOthers.concept_id = (
            select concept_id from concept_name where name ='Si autre, preciser' and concept_name_type='FULLY_SPECIFIED' and locale='fr') and obsForOthers.voided = 0  ) ELSE (Select concept_short_name from concept_view where concept_id = obsForActivityStatus.value_coded) END As 'C6',
                            NULL AS C7,
                             Date(obsForActivityStatus.obs_datetime) as 'ObsDate',
                             null as C10

            from 
             obs obsForActivityStatus 
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
              
              UNION ALL
              
              /*Charge Virale HIV - Value C7*/
              select          
                    obsq.person_id as 'personid',
                    NULL AS 'AdmissionDate',
                    NULL AS C1,
                    NULL as C2,
                    NULL AS C3,
                    NULL AS C4,
                    NULL AS 'D1',
                    NULL AS 'D2',
                    NULL as 'C5',
                    NULL AS C6,
                    (obsq.value_numeric) as 'C7',
                    date(obsq.obs_datetime) as 'obsDate',
                     null as C10
                from obs obsq 
                where obsq.concept_id in (
                                            select concept_id from concept_name where name ="Charge Virale HIV - Value"
                                            and concept_name_type='FULLY_SPECIFIED' and locale='fr'
                                         )  
                AND obsq.voided = 0
                          
            ) as A

            Group by person_id,dateResultCD4
            ORder by person_id,dateResultCD4
)
AS patientOtherDetails
On patientOtherDetails.person_id = patientDetails.person_id
Inner Join (
             /*Date of Admission C8*/
                select          
                    obsq.person_id as 'personid',
                    Date(obsq.value_datetime) as 'AdmissionDate',
                    date(obsq.obs_datetime) as 'obsDate'
                from obs obsq 
                where obsq.concept_id in (
                                            select concept_id from concept_name where name ="IPD Admission, Date d'admission"
                                            and concept_name_type='FULLY_SPECIFIED' and locale='fr'
                                         )  
                AND obsq.voided = 0
                AND Date(obsq.value_datetime) between Date('#startDate#') AND Date('#endDate#')
             ) As patientDateOfAdmission
             On patientDateOfAdmission.personid = patientOtherDetails.person_id
and patientOtherDetails.dateResultCD4 = patientDateOfAdmission.obsDate
Order by patientDateOfAdmission.AdmissionDate,IDPatient;


