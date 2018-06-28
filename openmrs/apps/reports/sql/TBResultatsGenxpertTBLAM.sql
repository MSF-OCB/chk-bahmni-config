Select
    identifierOfPerson.identifier AS "ID",
    group_concat( distinct ( case when personAttributeTypeDetails.name="Type de cohorte" then cvForAttribute.concept_full_name else NULL end )) as "Type cohorte",
    concat( COALESCE(NULLIF(pnForDetails.given_name, ''), ''), ' ', COALESCE(NULLIF(pnForDetails.family_name, ''), '') ) AS "Nom",
    concat(floor(datediff(now(), personForDetails.birthdate)/365), ' ans, ',  floor((datediff(now(), personForDetails.birthdate)%365)/30),' mois') AS "Age",
    date_format(personForDetails.birthdate, '%d/%m/%Y') AS "Date de naissance",
    CASE WHEN personForDetails.gender = 'M' THEN 'H'
    WHEN personForDetails.gender = 'F' THEN 'F'
    WHEN personForDetails.gender = 'O' THEN 'A'
    else personForDetails.gender END AS "Sexe",
    group_concat( distinct ( case when personAttributeTypeDetails.name="Date entrée cohorte"
    then date_format(DATE(personAttributeDetails.value), '%d/%m/%Y')
                         else NULL end )) as "Date entrée cohorte",
    date_format(TBStartDate,'%d/%m/%Y') AS "Date début TB",
    MotifdébutTraitement AS "Motif début TB",
    TBType AS "Type TB",
    date_format(ARVStartDate,'%d/%m/%Y') AS "Date début ARV",
    DATE_FORMAT(LabTestDate,"%d/%m/%Y") "Date resultats",
    max(Genexpertresult) AS "Résultats Genexpert",
    max(TBVALUE) AS "Resultats TB-LAM"
from (
        Select patientID,
        TBStartDate,
        MotifdébutTraitement,
        TBType,
        ARVStartDate,
        PID,
        tbdate as "LabTestDate",
        VALUE as "TBVALUE",
        NULL AS Genexpertresult
          from (
                SELECT
                    IDForProgram as patientID,
                    TBStartDate,
                    GROUP_CONCAT(CASE WHEN question  = "Motif début traitement"
                        THEN answer
                                 ELSE NULL END)  AS "MotifdébutTraitement",
                    GROUP_CONCAT(CASE WHEN question  = "TB Type"
                        THEN answer
                                 ELSE NULL END) AS "TBType",
                    ARVStartDate
                from
                    (
                        select
                            p.patient_id AS IDForProgram,
                            pp.date_enrolled AS "TBStartDate",
                            pat.name AS "question",
                            cnProgram.name AS "answer",
                            ppForARV.date_enrolled AS "ARVStartDate",
                            DATE(ppaForEndDate.value_reference) AS "endDate"
                        from patient p
                            INNER JOIN patient_program pp  on p.patient_id = pp.patient_id AND pp.program_id = (select program_id from program where `name` = "Programme TB")
                                                              AND pp.voided = 0 AND pp.date_completed is NULL

                            LEFT JOIN patient_program_attribute ppa on pp.patient_program_id = ppa.patient_program_id AND ppa.voided = 0

                            LEFT JOIN program_attribute_type pat on ppa.attribute_type_id = pat.program_attribute_type_id
                            LEFT JOIN concept_name cnProgram on ppa.value_reference = cnProgram.concept_id AND cnProgram.concept_name_type = "FULLY_SPECIFIED" and cnProgram.voided = 0 AND cnProgram.locale = 'fr'

                            LEFT JOIN patient_program ppForARV ON p.patient_id = ppForARV.patient_id
                                                                  and ppForARV.program_id = (select program_id from program where `name` = "Programme ARV")
                                                                  AND ppForARV.voided = 0

                            LEFT JOIN patient_program_attribute ppaForEndDate ON pp.patient_program_id = ppaForEndDate.patient_program_id
                                                                                 and ppaForEndDate.patient_program_attribute_id =  (
                                select program_attribute_type_id
                                from program_attribute_type
                                where `name` = "End Date for Program" and description = "End Date" AND retired = 0)
                        WHERE (DATE(ppaForEndDate.value_reference) > date('2018-06-30') OR ppaForEndDate.value_reference is NULL)

                    ) AS A
                GROUP BY IDForProgram,TBStartDate
            ) AS patientProgram
        Inner Join
                (
                select
                   o.person_id as PID,
                   latestEncounter.visit_id,
                   answer_concept.name as value,
                   o.obs_datetime as tbdate
               from obs o
                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE and o.voided is false
                   INNER JOIN (select
                                   e.visit_id,
                                   max(e.encounter_datetime) AS `encounterTime`,
                                   cn.concept_id
                               from obs o
                                   INNER join concept_name cn
                                       on o.concept_id = cn.concept_id and cn.name = 'TB - LAM' AND cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                               GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND
                                                                       o.concept_id = latestEncounter.concept_id
                   INNER JOIN concept_name answer_concept on o.value_coded = answer_concept.concept_id  AND answer_concept.voided IS FALSE AND
                                                             answer_concept.concept_name_type = 'FULLY_SPECIFIED' AND answer_concept.locale = 'fr'

            ) AS patientTBLam on patientProgram.patientID = patientTBLam.PID


            Union ALL   

            Select patientID,
        TBStartDate,
        MotifdébutTraitement,
        TBType,
        ARVStartDate,
        IDForGenexpert,
        genexpertTime AS LabTestDate,
        NULL AS TBLam,
        resultatsGenexpert AS Genexpertresult
         From (
                SELECT
                    IDForProgram as patientID,
                    Date(TBStartDate) as "TBStartDate",
                    GROUP_CONCAT(CASE WHEN question  = "Motif début traitement"
                        THEN answer
                                 ELSE NULL END)  AS "MotifdébutTraitement",
                    GROUP_CONCAT(CASE WHEN question  = "TB Type"
                        THEN answer
                                 ELSE NULL END) AS "TBType",
                    ARVStartDate
                from
                    (
                        select
                            p.patient_id AS IDForProgram,
                            pp.date_enrolled AS "TBStartDate",
                            pat.name AS "question",
                            cnProgram.name AS "answer",
                            ppForARV.date_enrolled AS "ARVStartDate",
                            DATE(ppaForEndDate.value_reference) AS "endDate"
                        from patient p
                            INNER JOIN patient_program pp  on p.patient_id = pp.patient_id AND pp.program_id = (select program_id from program where `name` = "Programme TB")
                                                              AND pp.voided = 0 AND pp.date_completed is NULL

                            LEFT JOIN patient_program_attribute ppa on pp.patient_program_id = ppa.patient_program_id AND ppa.voided = 0

                            LEFT JOIN program_attribute_type pat on ppa.attribute_type_id = pat.program_attribute_type_id
                            LEFT JOIN concept_name cnProgram on ppa.value_reference = cnProgram.concept_id AND cnProgram.concept_name_type = "FULLY_SPECIFIED" and cnProgram.voided = 0 AND cnProgram.locale = 'fr'

                            LEFT JOIN patient_program ppForARV ON p.patient_id = ppForARV.patient_id
                                                                  and ppForARV.program_id = (select program_id from program where `name` = "Programme ARV")
                                                                  AND ppForARV.voided = 0

                            LEFT JOIN patient_program_attribute ppaForEndDate ON pp.patient_program_id = ppaForEndDate.patient_program_id
                                                                                 and ppaForEndDate.patient_program_attribute_id =  (
                                select program_attribute_type_id
                                from program_attribute_type
                                where `name` = "End Date for Program" and description = "End Date" AND retired = 0)
                        WHERE (DATE(ppaForEndDate.value_reference) > date('#endDate#') OR ppaForEndDate.value_reference is NULL)

                    ) AS A
                GROUP BY IDForProgram,TBStartDate
            ) AS patientProgram

        Inner Join
            (
                SELECT
                    IDForGenexpert,
                    Date(genexpertTime) as "genexpertTime",
                    CASE WHEN Genexpert in (
                        "Genexpert (Crachat)", "Genexpert (Pus)", "Genexpert (Gastrique)",
                        "Genexpert (Ascite)", "Genexpert (Pleural)", "Genexpert (Ganglionnaire)", "Genexpert (Synovial)",
                        "Genexpert (Urine)", "Genexpert (LCR)"
                    )
                        THEN Result ELSE NULL END AS "resultatsGenexpert"
                FROM
                    (
                        select DISTINCT obs.person_id AS "IDForGenexpert",
                                        obs_datetime AS "genexpertTime",
                                        cnForLabTest.name AS "Genexpert",
                                        cnForLabAnswer.name AS "Result"

                        from obs
                            inner join concept_name cnForLabTest on obs.concept_id = cnForLabTest.concept_id
                            INNER JOIN concept_name cnForLabAnswer on obs.value_coded = cnForLabAnswer.concept_id
                        where obs.concept_id in (
                            select concept_id
                            from concept_view
                            where concept_full_name in (
                                "Genexpert (Crachat)", "Genexpert (Pus)", "Genexpert (Gastrique)", "Genexpert (Ascite)",
                                "Genexpert (Pleural)","Genexpert (Ganglionnaire)", "Genexpert (Synovial)",
                                "Genexpert (Urine)", "Genexpert (LCR)")
                        )

                              and obs.value_coded in (
                            SELECt concept_id
                            from concept_view
                            where concept_full_name in (
                                "MTB -","MTB + RIF -","MTB + RIF +","MTB + RIF indeterminé"
                            )
                        )
                               AND DATE(obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
                    ) AS C

            ) AS patientGenexpert ON patientProgram.patientID = patientGenexpert.IDForGenexpert

) as patientInTBWithTBLamAndGenxpert
Inner join patient_identifier identifierOfPerson on patientInTBWithTBLamAndGenxpert.patientID = identifierOfPerson.patient_id
INNER JOIN person personForDetails ON patientInTBWithTBLamAndGenxpert.patientID = personForDetails.person_id
INNER JOIN person_name pnForDetails ON personForDetails.person_id  = pnForDetails.person_id
LEFT JOIN person_attribute personAttributeDetails on  patientInTBWithTBLamAndGenxpert.patientID = personAttributeDetails.person_id AND personAttributeDetails.voided = 0
LEFT JOIN person_attribute_type personAttributeTypeDetails ON  personAttributeDetails.person_attribute_type_id = personAttributeTypeDetails.person_attribute_type_id
LEFT JOIN concept_view cvForAttribute on personAttributeDetails.value = cvForAttribute.concept_id
group by patientID,Date(LabTestDate)
Order by Date(LabTestDate),patientID;
