SELECT
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


date_format(TBStartDate,'%d-%m-%Y') AS "Date début TB",
MotifdébutTraitement AS "Motif début TB",
TBType AS "Type TB",
date_format(ARVStartDate,'%d-%m-%Y') AS "Date début ARV",
date_format(genexpertTime,'%d-%m-%Y') AS "Date resultats  Genexpert",
résultatsGenexpert AS "Résultats Genexpert",
date_format(TBLamTime,'%d-%m-%Y') AS "Date resultats TB-LAM",
TBLam AS "Resultats TB-LAM"

from
(
    SELECT
    IDForProgram,
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
        ppForARV.date_enrolled AS "ARVStartDate"

        from patient p
        inner JOIN patient_program pp  on p.patient_id = pp.patient_id AND pp.program_id = 2 AND pp.voided = 0 AND pp.date_completed is NULL
        inner JOIN patient_program_attribute ppa on pp.patient_program_id = ppa.patient_program_id

        inner JOIN program_attribute_type pat on ppa.attribute_type_id = pat.program_attribute_type_id AND ppa.voided = 0
        inner JOIN concept_name cnProgram on ppa.value_reference = cnProgram.concept_id AND cnProgram.concept_name_type = "FULLY_SPECIFIED" and cnProgram.voided = 0 AND cnProgram.locale = 'fr'

        LEFT JOIN patient_program ppForARV ON p.patient_id = ppForARV.patient_id and ppForARV.program_id =1 AND ppForARV.voided = 0
        where pat.name in ("TB Type","Motif début traitement")

        ) AS A
        GROUP BY IDForProgram,TBStartDate
) AS patientProgram

LEFT JOIN

(
    SELECT
    IDForObs,
    TBLamTime,
    case when tblam = "TB - LAM"
         THEN tblamresult
         ELSE NULL END AS "TBLam"
    from
        (
        select p.patient_id AS IDForObs,
        cn1.name AS tblam,
        cn2.name AS tblamresult,
        obsForresult.obs_datetime AS TBLamTime
        from patient p
        INNER JOIN obs obsForActivityStatus on p.patient_id = obsForActivityStatus.person_id and obsForActivityStatus.voided = 0
        INNER JOIN encounter encounterForActivityStatus on obsForActivityStatus.encounter_id = encounterForActivityStatus.encounter_id
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
                                                      concept_full_name = 'TB - LAM'
                                                  )
         and obsForActivityStatus.voided =0

        INNER JOIN obs obsForresult on obsForActivityStatus.obs_group_id = obsForresult.obs_group_id
        INNER JOIN encounter encounterForresult on obsForresult.encounter_id = encounterForresult.encounter_id
        INNER JOIN concept_name cn2 on obsForresult.value_coded = cn2.concept_id AND cn2.voided = 0
          and obsForresult.concept_id in (
                                                    select
                                                      distinct concept_id
                                                    from
                                                      concept_view
                                                    where
                                                      concept_full_name = 'Résultat(Option)'
                                                  )
          and obsForresult.value_coded in (
                                                    select
                                                      distinct concept_id
                                                    from
                                                      concept_view
                                                    where
                                                      concept_full_name in ("Positif","Négatif")
                                                  )
          and obsForresult.voided =0

          GROUP BY IDForObs,obsForActivityStatus.obs_datetime
          ) AS B

  ) AS patientTBLam on patientProgram.IDForProgram = patientTBLam.IDForObs

LEFT JOIN

(
    SELECT
    IDForGenexpert,
    genexpertTime,
    CASE WHEN Genexpert in (
                            "Genexpert (Crachat)", "Genexpert (Pus)", "Genexpert (Gastrique)",
                            "Genexpert (Ascite)", "Genexpert (Pleural)", "Genexpert (Ganglionnaire)", "Genexpert (Synovial)",
                            "Genexpert (Urine)", "Genexpert (LCR)"
                            )
    THEN Result ELSE NULL END AS "résultatsGenexpert"
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

        ) AS C

) AS patientGenexpert ON patientProgram.IDForProgram = patientGenexpert.IDForGenexpert AND  date(patientGenexpert.genexpertTime) = date(TBLamTime)

Inner join patient_identifier identifierOfPerson on patientProgram.IDForProgram = identifierOfPerson.patient_id
INNER JOIN person personForDetails ON patientProgram.IDForProgram = personForDetails.person_id
INNER JOIN person_name pnForDetails ON personForDetails.person_id  = pnForDetails.person_id

LEFT JOIN person_attribute personAttributeDetails on  patientProgram.IDForProgram = personAttributeDetails.person_id AND personAttributeDetails.voided = 0
LEFT JOIN person_attribute_type personAttributeTypeDetails ON  personAttributeDetails.person_attribute_type_id = personAttributeTypeDetails.person_attribute_type_id
LEFT JOIN concept_view cvForAttribute on personAttributeDetails.value = cvForAttribute.concept_id

WHERE DATE(TBLamTime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')

GROUP BY patientTBLam.TBLamTime,patientProgram.TBStartDate,patientGenexpert.genexpertTime
ORDER BY "Date début TB";
