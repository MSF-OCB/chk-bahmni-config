
Select
identifierOfPerson.identifier AS "ID",
group_concat( distinct ( case when personAttributeTypeDetails.name="Type de cohorte" then cvForAttribute.concept_full_name else NULL end )) as "Type cohorte",
concat( COALESCE(NULLIF(pnForDetails.given_name, ''), ''), ' ', COALESCE(NULLIF(pnForDetails.family_name, ''), '') ) AS "Nom",
concat(floor(datediff(now(), personForDetails.birthdate)/365), ' ans, ',  floor((datediff(now(), personForDetails.birthdate)%365)/30),' mois') AS "Age",
date_format(personForDetails.birthdate, '%d-%m-%Y') AS "Date de naissance",
CASE WHEN personForDetails.gender = 'M' THEN 'H'
     WHEN personForDetails.gender = 'F' THEN 'F'
     WHEN personForDetails.gender = 'O' THEN 'A'
     else personForDetails.gender END AS "Sexe",
group_concat( distinct ( case when personAttributeTypeDetails.name="Date entrée cohorte"
                              then date_format(DATE(personAttributeDetails.value), '%d-%m-%Y')
                              else NULL end )) as "Date entrée cohorte",
A.visitType AS "Type de visite",
CASE WHEN DATE(personForDetails.date_created) = DATE(A.visitStartDate)  THEN  "New Visit" ELSE NULL END AS "Nouvelle visite",
concat( COALESCE(NULLIF(personNameOfConsulatant.given_name, ''), ''), ' ', COALESCE(NULLIF(personNameOfConsulatant.family_name, ''), '') ) AS "Consultant",
value_datetime AS "Date de rendez-vous",
A.visitStartDate AS "Date debut visite",
A.visitStopDate AS "Date fin visite"

from (
                        Select Distinct obsToGetConsultantName.person_id,
                        obsToGetConsultantName.obs_datetime,
                        'NULL' AS value_datetime,
                        obsToGetConsultantName.creator,
                        visitTypeConsutantRecord.name as 'visitType',
                        visitConsutantRecord.date_started as 'visitStartDate',
                        visitConsutantRecord.date_stopped as 'visitStopDate'


                         from obs  obsToGetConsultantName
                         inner join encounter encounterConsutantRecord
                         on encounterConsutantRecord.encounter_id = obsToGetConsultantName.encounter_id
                         Inner join visit visitConsutantRecord
                         on encounterConsutantRecord.visit_id = visitConsutantRecord.visit_id
                         Inner Join visit_type visitTypeConsutantRecord
                         on visitTypeConsutantRecord.visit_type_id = visitConsutantRecord.visit_type_id
                         Where  obsToGetConsultantName.concept_id in (
                                                                      select concept_id
                                                                      from concept_view
                                                                      where retired = 0
                                                                      AND concept_full_name
                                                                      in
                                                                      ("Date de prochain RDV",
                                                                      "Date du prochain RDV"
                                                                      )
                                                                      )
                            AND obsToGetConsultantName.person_id in (
                                                                            select person_id
                                                                            from obs
                                                                            where obs.voided =0
                                                                            AND concept_id in
                                                                                             (select concept_id
                                                                                             from concept_view
                                                                                             where retired = 0
                                                                                             AND concept_full_name in
                                                                                                                       ("Date de prochain RDV",
                                                                                                                       "Date du prochain RDV"
                                                                                                                       )
                                                                                             )
                                                                           )

                        AND obs_id not in(
                            Select
                            Distinct
                            obsToGetConsultantName.obs_id
                            from obs  obsToGetConsultantName
                            LEFT Join
                            obs obsToGetPreviousAppointmentDate
                            On obsToGetConsultantName.person_id = obsToGetPreviousAppointmentDate.person_id
                            AND obsToGetConsultantName.obs_datetime > obsToGetPreviousAppointmentDate.value_datetime
                            AND obsToGetConsultantName.obs_id != obsToGetPreviousAppointmentDate.obs_id
                            AND obsToGetPreviousAppointmentDate.value_datetime = (
                                                                                    Select max(value_datetime) from obs test
                                                                                    where test.person_id = obsToGetPreviousAppointmentDate.person_id
                                                                                    AND date(test.value_datetime) < date(obsToGetConsultantName.obs_datetime)
                                                                                    AND test.concept_id in (
                                                                                                          select concept_id
                                                                                                          from concept_view
                                                                                                          where retired = 0
                                                                                                          AND concept_full_name
                                                                                                          in
                                                                                                              ("Date de prochain RDV",
                                                                                                              "Date du prochain RDV"
                                                                                                              )
                                                                                                           )
                                                                                    AND test.voided = 0

                                                                                  )
                            AND obsToGetPreviousAppointmentDate.concept_id in (
                                                                              select concept_id
                                                                              from concept_view
                                                                              where retired = 0
                                                                              AND concept_full_name
                                                                              in
                                                                                  ("Date de prochain RDV",
                                                                                  "Date du prochain RDV"
                                                                                  )
                                                                             )
                            AND obsToGetConsultantName.concept_id in (
                                                                      select concept_id
                                                                      from concept_view
                                                                      where retired = 0
                                                                      AND concept_full_name
                                                                      in
                                                                          ("Date de prochain RDV",
                                                                          "Date du prochain RDV"
                                                                          )
                                                                     )
                            where
                            obsToGetConsultantName.voided = 0
                            And obsToGetPreviousAppointmentDate.voided = 0
                            AND obsToGetConsultantName.person_id in (
                                                                            select person_id
                                                                            from obs
                                                                            where obs.voided =0
                                                                            AND concept_id in
                                                                                             (select concept_id
                                                                                             from concept_view
                                                                                             where retired = 0
                                                                                             AND concept_full_name in
                                                                                                                       ("Date de prochain RDV",
                                                                                                                       "Date du prochain RDV"
                                                                                                                       )
                                                                                             )
                                                                           )
                            AND obsToGetPreviousAppointmentDate.person_id in (
                                                                            select person_id
                                                                            from obs
                                                                            where obs.voided =0
                                                                            AND concept_id in
                                                                                             (select concept_id
                                                                                             from concept_view
                                                                                             where retired = 0
                                                                                             AND concept_full_name in
                                                                                                                       ("Date de prochain RDV",
                                                                                                                       "Date du prochain RDV"
                                                                                                                       )
                                                                                             )
                                                                           )

                        )

                        Union all

                        Select
                        obsToGetConsultantName.person_id,
                        obsToGetConsultantName.obs_datetime,
                        obsToGetPreviousAppointmentDate.value_datetime,
                        obsToGetConsultantName.creator,
                        visitTypeConsutantRecord.name as 'visitType',
                        visitConsutantRecord.date_started as 'visitStartDate',
                        visitConsutantRecord.date_stopped as 'visitStopDate'
                        from obs  obsToGetConsultantName
                        LEFT Join
                        obs obsToGetPreviousAppointmentDate
                        On obsToGetConsultantName.person_id = obsToGetPreviousAppointmentDate.person_id
                        AND obsToGetConsultantName.obs_datetime > obsToGetPreviousAppointmentDate.value_datetime
                        AND obsToGetConsultantName.obs_id != obsToGetPreviousAppointmentDate.obs_id
                        AND obsToGetPreviousAppointmentDate.value_datetime = (
                                                                                Select max(value_datetime) from obs test
                                                                                    where test.person_id = obsToGetPreviousAppointmentDate.person_id
                                                                                    AND date(test.value_datetime) < date(obsToGetConsultantName.obs_datetime)
                                                                                    AND test.concept_id in (
                                                                                                          select concept_id
                                                                                                          from concept_view
                                                                                                          where retired = 0
                                                                                                          AND concept_full_name
                                                                                                          in
                                                                                                              ("Date de prochain RDV",
                                                                                                              "Date du prochain RDV"
                                                                                                              )
                                                                                                           )
                                                                                    AND test.voided = 0
                                                                              )
                         inner join encounter encounterConsutantRecord
                         on encounterConsutantRecord.encounter_id = obsToGetConsultantName.encounter_id
                         Inner join visit visitConsutantRecord
                         on encounterConsutantRecord.visit_id = visitConsutantRecord.visit_id
                         Inner Join visit_type visitTypeConsutantRecord
                         on visitTypeConsutantRecord.visit_type_id = visitConsutantRecord.visit_type_id
                        where
                        obsToGetConsultantName.voided = 0
                        And obsToGetPreviousAppointmentDate.voided = 0
                        AND obsToGetPreviousAppointmentDate.concept_id in (
                                                                          select concept_id
                                                                          from concept_view
                                                                          where retired = 0
                                                                          AND concept_full_name
                                                                          in
                                                                              ("Date de prochain RDV",
                                                                              "Date du prochain RDV"
                                                                              )
                                                                          )
                        AND obsToGetConsultantName.concept_id in (
                                                                  select concept_id
                                                                  from concept_view
                                                                  where retired = 0
                                                                  AND concept_full_name
                                                                  in
                                                                      ("Date de prochain RDV",
                                                                      "Date du prochain RDV"
                                                                      )
                                                                 )
                        AND obsToGetConsultantName.person_id in (
                                                                select person_id
                                                                from obs
                                                                where obs.voided =0
                                                                AND concept_id in
                                                                                 (select concept_id
                                                                                 from concept_view
                                                                                 where retired = 0
                                                                                 AND concept_full_name in
                                                                                                           ("Date de prochain RDV",
                                                                                                           "Date du prochain RDV"
                                                                                                           )
                                                                                 )
                                                               )
                        AND obsToGetPreviousAppointmentDate.person_id in (
                                                                            select person_id
                                                                            from obs
                                                                            where obs.voided =0
                                                                            AND concept_id in
                                                                                             (select concept_id
                                                                                             from concept_view
                                                                                             where retired = 0
                                                                                             AND concept_full_name in
                                                                                                                       ("Date de prochain RDV",
                                                                                                                       "Date du prochain RDV"
                                                                                                                       )
                                                                                             )
                                                                           )

    ) as A
    Inner join patient_identifier identifierOfPerson on A.person_id = identifierOfPerson.patient_id
    INNER JOIN person personForDetails ON A.person_id = personForDetails.person_id
    INNER JOIN person_name pnForDetails ON personForDetails.person_id  = pnForDetails.person_id
    INNER JOIN users ON A.creator = users.user_id
    INNER JOIN person_name personNameOfConsulatant ON personNameOfConsulatant.person_id = users.person_id
    LEFT JOIN person_attribute personAttributeDetails on  A.person_id = personAttributeDetails.person_id AND personAttributeDetails.voided = 0
    LEFT JOIN person_attribute_type personAttributeTypeDetails ON  personAttributeDetails.person_attribute_type_id = personAttributeTypeDetails.person_attribute_type_id
    LEFT JOIN concept_view cvForAttribute on personAttributeDetails.value = cvForAttribute.concept_id
 GROUP BY identifierOfPerson.identifier, visitStartDate
 ORDER BY A.visitStartDate
