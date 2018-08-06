select
    pi.identifier AS "ID",
    group_concat(distinct(case when pad.name='Type de cohorte' then cn.name else null end))                  as "Type cohorte",
     CONCAT(pn.family_name,' ', pn.given_name)                                                               AS `Nom`,
    floor(DATEDIFF(CURDATE(), p.birthdate) / 365)                                                            AS `Age`,
    date_format(p.birthdate, '%d/%m/%Y')                                                                     as "Date de naissance",
    CASE WHEN p.gender = 'M' THEN 'H'
    WHEN p.gender = 'F' THEN 'F'
    WHEN p.gender = 'O' THEN 'A'
    else p.gender END                                                                                        AS "Sexe",
    date_format(group_concat(distinct(case when pad.name ='Date entrée cohorte' then date(pa.value) else null end)),'%d/%m/%Y')      as "Date entree cohorte",
    date_format(tbpgm.tbStartDate,'%d/%m/%Y')                                                                as "Date début TB",
    tbpgm.reason                                                                                             as "Motif début TB",
    tbpgm.tbType                                                                                             as "Type TB",
    date_format(arvpgm.enrolledDate,'%d/%m/%Y')                                                              as "Date début ARV",
    date_format(tbgenexp.dateresults,'%d/%m/%Y')                                                             as "Date resultats ",
    tbgenexp.genvalue                                                                                        as "Résultats Genexpert",
    tbgenexp.TBLAMvalue                                                                                      as "Resultats TB-LAM"

    from
        (
        SELECT
        distinct pp.patient_id,
        p.name           AS Pname,
        vt.visit_id      AS visitid,
        max(date(pp.date_enrolled))                                                                 AS  `tbStartDate`,
        group_concat(distinct(IF(pat.name = 'TB Type', cn.name, NULL )))                          AS `tbType`,
        group_concat(distinct(IF(pat.name = 'Site TEP', cn.name, NULL )))                      AS `siteTEP`,
        pp.date_completed    AS `endDate`,
        group_concat(distinct(IF(pat.name = 'Motif début traitement', cn.name, NULL )))           AS `reason`


        FROM patient_program pp
        Inner JOIN
                (/*TB Program information*/

                        SELECT
                        pp.patient_id,
                        pp.program_id,
                        max(pp.date_enrolled) as date_enrolled
                        FROM patient_program pp
                        INNER JOIN program p ON pp.program_id = p.program_id AND p.retired = 0 AND pp.voided = 0 AND p.name = 'Programme TB'
                        where pp.patient_id not in
                                                  (/*removing patient which have program end date before reporting date*/
                                                    select
                                                    case when Max(date(TBpatientProgCompletedDate.date_completed)) > Max(Date(TBpatientProgStartDate.date_enrolled))
                                                    then TBpatientProgCompletedDate.patient_id  else 0 END As patientID
                                                    from patient_program TBpatientProgCompletedDate
                                                    Join patient_program TBpatientProgStartDate
                                                    On TBpatientProgCompletedDate.patient_id = TBpatientProgStartDate.patient_id
                                                    And TBpatientProgCompletedDate.program_id = TBpatientProgStartDate.program_id
                                                    where TBpatientProgCompletedDate.date_completed is not null
                                                    and TBpatientProgCompletedDate.outcome_concept_id is not  null
                                                    AND DATE(TBpatientProgCompletedDate.date_completed) <= DATE('#endDate#')
                                                    and TBpatientProgCompletedDate.voided = 0
                                                    And TBpatientProgCompletedDate.program_id = 2
                                                    AND TBpatientProgStartDate.voided = 0
                                                    And pp.patient_id = TBpatientProgCompletedDate.patient_id
                                                    AND DATE(TBpatientProgStartDate.date_enrolled) <= DATE('#endDate#')
                                                    group by TBpatientProgCompletedDate.patient_id

                                                  )
                                                  group by pp.patient_id

                ) latest_TB_prog
        ON latest_TB_prog.patient_id = pp.patient_id AND latest_TB_prog.date_enrolled = pp.date_enrolled
        LEFT JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE
        LEFt JOIN program_workflow pw ON pw.program_id=pp.program_id
        left JOIN patient_program_attribute ppa ON ppa.patient_program_id = pp.patient_program_id AND ppa.voided IS FALSE
        LEFt JOIN program_attribute_type pat ON ppa.attribute_type_id = pat.program_attribute_type_id AND pat.retired IS FALSE
        LEFT JOIN program_workflow_state pws ON pws.program_workflow_id=pw.program_workflow_id
        LEFT JOIN patient_state ps ON ps.patient_program_id=pp.patient_program_id AND ps.state=pws.program_workflow_state_id
        AND ps.voided=0 AND ps.end_date IS NULL
        LEFT JOIN concept_name cn ON cn.concept_id=ppa.value_reference and cn.concept_name_type='SHORT'
        LEFt JOIN visit vt ON vt.patient_id = pp.patient_id
        Where p.program_id = 2
        group by patient_id
        ) as tbpgm


        inner join (/* TBLAM and Genexpert */
                    select t1.patient_id as PID,
                    group_concat(distinct(case when t1.genvalue in ('Positif','Négatif') then t1.genvalue else null end)) as "TBLAMvalue",
                    group_concat(distinct(case when t1.genvalue in ('MTB -','MTB + RIF -','MTB + RIF +','MTB + RIF indeterminé') then t1.genvalue else null end)) as genvalue,
                    (case when t1.genvalue in ('Positif','Négatif') then date(obsdate)
                          when t1.genvalue in ('MTB -','MTB + RIF -','MTB + RIF +','MTB + RIF indeterminé') then date(obsdate)
                          else null end) as "dateresults",
                    t1.visit
                     from
                        (
                        select * from
                                        (
                                        select  * from
                                            (
                                            SELECT
                                            et.patient_id ,
                                            et.visit_id as visit,
                                            GROUP_CONCAT(distinct(cva.concept_full_name)) AS genvalue,
                                            null as C1,
                                            max(oTest.obs_datetime) as obsdate,
                                            max(oTest.obs_id) as OID,
                                            max(et.encounter_id)
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
                                            group by visit,oTest.obs_datetime order by oTest.obs_id desc
                                            )X
                                            group by X.genvalue,X.patient_id order by obsdate desc
                                         )Y group by patient_id,visit
                          union all

                    select * from (
                                    select
                                    o.person_id,
                                    latestEncounter.visit_id as visit,
                                    answer_concept.name as "LAMVALUE",
                                    latestEncounter.conceptName as cname,
                                    o.obs_datetime,
                                    o.obs_id,
                                    e.encounter_id
                                    from obs o
                                    INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE and o.voided is false
                                    INNER JOIN (
                                                select
                                                e.visit_id,
                                                max(e.encounter_datetime) AS `encounterTime`,
                                                cn.concept_id,cn.name as conceptName
                                                from obs o
                                                INNER join concept_name cn
                                                on o.concept_id = cn.concept_id and cn.name = 'TB - LAM' AND cn.voided IS FALSE AND
                                                cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                                INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                                                GROUP BY e.visit_id
                                                ) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND o.concept_id = latestEncounter.concept_id
                                    INNER JOIN concept_name answer_concept on o.value_coded = answer_concept.concept_id  AND answer_concept.voided IS FALSE AND
                                    answer_concept.concept_name_type = 'FULLY_SPECIFIED' AND answer_concept.locale = 'fr'
                                  )tbgen
                             )as t1
                             group by PID,visit
                        ) as tbgenexp on tbgenexp.PID=tbpgm.patient_id


        left join (/*ARV enrollment Date*/
                    SELECT
                    pp.patient_id,
                    date(pp.date_enrolled) AS enrolledDate
                    FROM patient_program pp
                    INNER JOIN
                            (
                            SELECT
                            ARV_prog.patient_id,
                            max(ARV_prog.date_enrolled) AS date_enrolled
                            FROM (
                                    SELECT
                                    pp.patient_id,
                                    pp.program_id,
                                    pp.date_enrolled
                                    FROM patient_program pp INNER JOIN program p
                                    ON pp.program_id = p.program_id AND p.retired IS FALSE AND pp.voided = 0 AND
                                    p.name = 'Programme ARV'
                                    ) ARV_prog
                            GROUP BY patient_id
                            ) latest_arv_prog ON latest_arv_prog.patient_id = pp.patient_id AND latest_arv_prog.date_enrolled = pp.date_enrolled
                    INNER JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE
                    group by patient_id
                   ) as arvpgm on arvpgm.patient_id= tbpgm.patient_id
            inner join person p on tbpgm.patient_id=p.person_id
            inner join patient_identifier pi on pi.patient_id=tbpgm.patient_id
            inner join person_name pn on pn.person_id=p.person_id
            inner join person_attribute pa on pa.person_id=p.person_id
            inner join person_attribute_type pad on pad.person_attribute_type_id=pa.person_attribute_type_id
            inner join visit vv on vv.patient_id=pi.patient_id
            inner join concept_name cn on cn.concept_id=pa.value
            Where  date(tbgenexp.dateresults) between date('#startDate#') and Date('#endDate#')
            And Date(tbpgm.tbStartDate) <= Date(tbgenexp.dateresults)

            group by pi.identifier,tbgenexp.dateresults;
