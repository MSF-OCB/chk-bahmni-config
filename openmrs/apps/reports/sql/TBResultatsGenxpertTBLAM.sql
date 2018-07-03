
select  
    pi.identifier                                                                                            as "ID",
    group_concat(distinct(case when pad.name='Type de cohorte' then cn.name else null end))                  as "Type cohorte",
     CONCAT(pn.family_name,' ', pn.given_name)                                                               AS `Nom`,
    floor(DATEDIFF(CURDATE(), p.birthdate) / 365)                                                            AS `Age`,
    date(p.birthdate)                                                                                        as "Date de naissance",
    CASE WHEN p.gender = 'M' THEN 'H'
    WHEN p.gender = 'F' THEN 'F'
    WHEN p.gender = 'O' THEN 'A'
    else p.gender END                                                                                        AS "Sexe",    
    group_concat(distinct(case when pad.name ='Date entrée cohorte' then date(pa.value) else null end))      as "Date entree cohorte",
    tbpgm.tbStartDate                                                                                        as "Date début TB",
    tbpgm.reason                                                                                             as "Motif début TB",
    tbpgm.tbType                                                                                             as "Type TB",
    arvpgm.enrolledDate                                                                                      as "Date début ARV",
    tbgen.dateresults                                                                                        as "Date resultats ",
    tbgen.Genexpert                                                                                          as "Résultats Genexpert",
    tbgen.TBLAM                                                                                              as "Resultats TB-LAM"
    
    
    from 
    
    (SELECT
    distinct pp.patient_id,
    date(pp.date_enrolled) AS enrolledDate,
    p.name           AS Pname,
    vt.visit_id      AS visitid,
    date(pp.date_enrolled)                                                                  AS  `tbStartDate`,
    group_concat(distinct(IF(pat.name = 'TB Type', cn.name, NULL )))                          AS `tbType`,
                   group_concat(distinct(IF(pat.name = 'Site TEP', cn.name, NULL )))                      AS `siteTEP`,
                 pp.date_completed    AS `endDate`,
                   group_concat(distinct(IF(pat.name = 'Motif début traitement', cn.name, NULL )))           AS `reason`


FROM patient_program pp
    INNER JOIN
    (SELECT
         ARV_prog.patient_id,
         max(ARV_prog.date_enrolled) AS date_enrolled
     FROM (SELECT
               pp.patient_id,
               pp.program_id,
               pp.date_enrolled
           FROM patient_program pp INNER JOIN program p
                   ON pp.program_id = p.program_id AND p.retired IS FALSE AND pp.voided IS FALSE AND
                      p.name = 'Programme TB') ARV_prog
     GROUP BY patient_id) latest_arv_prog
        ON latest_arv_prog.patient_id = pp.patient_id AND latest_arv_prog.date_enrolled = pp.date_enrolled
    INNER JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE

INNER JOIN program_workflow pw ON pw.program_id=pp.program_id
INNER JOIN patient_program_attribute ppa ON ppa.patient_program_id = pp.patient_program_id AND ppa.voided IS FALSE
INNER JOIN program_attribute_type pat ON ppa.attribute_type_id = pat.program_attribute_type_id AND pat.retired IS FALSE
INNER JOIN program_workflow_state pws ON pws.program_workflow_id=pw.program_workflow_id
INNER JOIN patient_state ps ON ps.patient_program_id=pp.patient_program_id AND ps.state=pws.program_workflow_state_id
AND ps.voided=0 AND ps.end_date IS NULL
inner JOIN concept_name cn ON cn.concept_id=ppa.value_reference
INNER JOIN visit vt ON vt.patient_id = pp.patient_id and cn.concept_name_type='SHORT' 
group by patient_id,enrolledDate) as tbpgm 


inner join (
/* TBLAM and Genexpert */

select total_1.PID,

(case when total_1.TBLAMValue in ('Positif','Négatif') then date(total_1.TBLAMDate)
   when total_1.Genvalue in ('MTB -','MTB + RIF -','MTB + RIF +','MTB + RIF indeterminé') then date(total_1.Gendate)  
 else null end) as "dateresults",
 group_concat(distinct(total_1.TBLAMValue),'') as TBLAM,
 group_concat(distinct(total_1.Genvalue),'') as Genexpert
 from
(
select 
total.person_id as "PID",
(case when total.conceptname='TB - LAM' then total.LAMVALUE else null end) as "TBLAMValue",
(case when total.conceptname='TB - LAM' then date(total.obs_datetime) else null end) as "TBLAMDate",
(case when total.conceptname in ("Genexpert (Crachat)", "Genexpert (Pus)", "Genexpert (Gastrique)",
                        "Genexpert (Ascite)", "Genexpert (Pleural)", "Genexpert (Ganglionnaire)", "Genexpert (Synovial)",
                        "Genexpert (Urine)", "Genexpert (LCR)") then total.LAMVALUE else null end) as "Genvalue",
                        (case when total.conceptname in ("Genexpert (Crachat)", "Genexpert (Pus)", "Genexpert (Gastrique)",
                        "Genexpert (Ascite)", "Genexpert (Pleural)", "Genexpert (Ganglionnaire)", "Genexpert (Synovial)",
                        "Genexpert (Urine)", "Genexpert (LCR)") then date(total.obs_datetime) else null end) as "Gendate"
from 



(select  LAMVALUE,conceptname  ,obs_Datetime,person_id from  (select
                   o.person_id,
                   latestEncounter.visit_id as visitid,
                   answer_concept.name as "LAMVALUE",
                   latestEncounter.conceptName as "conceptname",
                   o.obs_datetime,
                   null as C1
               from obs o
                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE and o.voided is false
                   INNER JOIN (select
                                   e.visit_id,
                                   max(e.encounter_datetime) AS `encounterTime`,
                                   cn.concept_id,cn.name as conceptName
                               from obs o
                                   INNER join concept_name cn
                                       on o.concept_id = cn.concept_id and cn.name in ("Genexpert (Crachat)", "Genexpert (Pus)", "Genexpert (Gastrique)",
                        "Genexpert (Ascite)", "Genexpert (Pleural)", "Genexpert (Ganglionnaire)", "Genexpert (Synovial)",
                        "Genexpert (Urine)", "Genexpert (LCR)") AND cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                               GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND
                                                                       o.concept_id = latestEncounter.concept_id
                   INNER JOIN concept_name answer_concept on o.value_coded = answer_concept.concept_id  AND answer_concept.voided IS FALSE AND
                                                             answer_concept.concept_name_type = 'FULLY_SPECIFIED' AND answer_concept.locale = 'fr'
                                                            
                                    UNION all
                                    (select
                   o.person_id,
                   latestEncounter.visit_id as visitid,
                   answer_concept.name as "LAMVALUE",
                   latestEncounter.conceptName,
                   o.obs_datetime,
                   null as C1
               from obs o
                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE and o.voided is false
                   INNER JOIN (select
                                   e.visit_id,
                                   max(e.encounter_datetime) AS `encounterTime`,
                                   cn.concept_id,cn.name as conceptName
                               from obs o
                                   INNER join concept_name cn
                                       on o.concept_id = cn.concept_id and cn.name = 'TB - LAM' AND cn.voided IS FALSE AND
                                          cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.locale = 'fr' and o.voided IS FALSE
                                   INNER JOIN encounter e on o.encounter_id = e.encounter_id AND e.voided IS FALSE
                               GROUP BY e.visit_id) latestEncounter ON latestEncounter.encounterTime = e.encounter_datetime AND
                                                                       o.concept_id = latestEncounter.concept_id
                   INNER JOIN concept_name answer_concept on o.value_coded = answer_concept.concept_id  AND answer_concept.voided IS FALSE AND
                                                             answer_concept.concept_name_type = 'FULLY_SPECIFIED' AND answer_concept.locale = 'fr'
                                                             ))lam
                                                             group by obs_datetime) as total)total_1 
                                                             group by dateresults,PID ) as tbgen on tbgen.PID=tbpgm.patient_id
  left join (
  /*ARV Date*/
    SELECT
    pp.patient_id,
    date(pp.date_enrolled) AS enrolledDate
    
    
    
FROM patient_program pp
    INNER JOIN
    (SELECT
         ARV_prog.patient_id,
         max(ARV_prog.date_enrolled) AS date_enrolled
     FROM (SELECT
               pp.patient_id,
               pp.program_id,
               pp.date_enrolled
           FROM patient_program pp INNER JOIN program p
                   ON pp.program_id = p.program_id AND p.retired IS FALSE AND pp.voided IS FALSE AND
                      p.name = 'Programme ARV') ARV_prog
     GROUP BY patient_id) latest_arv_prog
        ON latest_arv_prog.patient_id = pp.patient_id AND latest_arv_prog.date_enrolled = pp.date_enrolled
    INNER JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE

group by patient_id 
  ) as arvpgm on arvpgm.patient_id= tbpgm.patient_id   
  inner join person p on tbpgm.patient_id=p.person_id
  inner join patient_identifier pi on pi.patient_id=tbpgm.patient_id
  inner join person_name pn on pn.person_id=p.person_id
  inner join person_attribute pa on pa.person_id=p.person_id
  inner join person_attribute_type pad on pad.person_attribute_type_id=pa.person_attribute_type_id
  inner join concept_name cn on cn.concept_id=pa.value and  date(tbgen.dateresults) between date('#startDate#') and Date('#endDate#')
  group by pi.identifier,tbgen.dateresults;
  
