SELECT
 IDPatient,
 Nom,
 Sexe,
 DOB,
 NbreJrs,
 DateDebutTBRecent,
 DatePrevueVisite,
 DateDerniereVisite,
 DateDebutARV,
 RegimeARV,
 DebutRegimeARV,
 Decede,
 DateDeces
FROM
(/*SUBQUERY 2 START*/
SELECT
  pi.identifier as "IDPatient",
  CONCAT(COALESCE(NULLIF(personalDetails.given_name, ''), ''), ' ',
  COALESCE(NULLIF(personalDetails.family_name, ''), ''))           AS "Nom",
  CASE WHEN personForDetails.gender='M' THEN 'Homme' WHEN personForDetails.gender='F' THEN 'Femme' ELSE NULL END AS Sexe,
  DATE_FORMAT(personForDetails.birthdate, '%d/%m/%Y') AS "DOB",
  MAX(timestampdiff(DAY, DATE(lostToFollowUpPatients.appointmentDate),'#endDate#')) AS "NbreJrs",
  DATE_FORMAT(DATE(tb_program_data.rec_enrolledDate), '%d/%m/%Y') AS "DateDebutTBRecent",
  DATE_FORMAT(DATE(tb_program_data.rec_completedDate), '%d/%m/%Y') AS "DateFinTBRecent",
DATE_FORMAT(DATE(lostToFollowUpPatients.appointmentDate), '%d/%m/%Y') AS "DatePrevueVisite",
DATE_FORMAT(DATE(lostToFollowUpPatients.visitDate), '%d/%m/%Y') AS "DateDerniereVisite",
DATE_FORMAT(arvpgm.enrolledDate, '%d/%m/%Y') AS "DateDebutARV",
reg.regimen_arv as "RegimeARV",
DATE_FORMAT(reg.regimen_start_date, '%d/%m/%Y')    AS "DebutRegimeARV",
CASE
      WHEN personForDetails.dead = 0 THEN "Non"
      WHEN personForDetails.dead = 1 THEN "Oui"
      ELSE NULL END                                                                  AS "Decede",
      DATE_FORMAT(DATE(personForDetails.death_date), '%d/%m/%Y')                       AS "DateDeces",
      cvForGettingDeathReason.concept_full_name                                        AS "RaisonDeces"
FROM
(SELECT
  person_id,
  obs_id,
  visitForAppointmentDate.visit_id,
  MAX(obsForAppointmentDate.obs_datetime)   AS "obsDate",
  MAX(obsForAppointmentDate.value_datetime) AS "appointmentDate",
  MAX(visitForAppointmentDate.date_started) AS "visitDate"
   FROM obs obsForAppointmentDate
   INNER JOIN visit visitForAppointmentDate ON visitForAppointmentDate.patient_id = obsForAppointmentDate.person_id

   WHERE obsForAppointmentDate.concept_id IN (SELECT concept_id
                                                 FROM concept_view
                                                 WHERE concept_full_name IN ("CSI, Date prochain RDV","Date de prochain RDV"))
      AND obsForAppointmentDate.voided = 0
      AND visitForAppointmentDate.voided = 0
          AND obs_id NOT IN (SELECT obs_id
                           FROM obs obsForAppointmentDate
                                  INNER JOIN visit visitForAppointmentDate
                                    ON visitForAppointmentDate.patient_id = obsForAppointmentDate.person_id
                           WHERE obsForAppointmentDate.concept_id IN (SELECT concept_id
                                                                      FROM concept_view
                                                                      WHERE concept_full_name
                                                                              IN ("CSI, Date prochain RDV",
                                                                                  "Date de prochain RDV"))
                             AND obsForAppointmentDate.voided   = 0
                             AND visitForAppointmentDate.voided = 0
                             AND ( /*1. To remove patient with visit present between appointment date and report end date*/
                                   /*2. To remove patients with appt date greater than report end date*/
                                                                   /*3. To remove patients with appointment date before report starting date*/
                                     date(visitForAppointmentDate.date_started) BETWEEN date(obsForAppointmentDate.value_datetime) AND Date('#endDate#')
                                       OR date(obsForAppointmentDate.value_datetime) > DATE('#endDate#')/*End Date*/
                                                                           /* OR date(obsForAppointmentDate.value_datetime) < DATE('#endDate#')Start Date*/
                                                                           ))
  GROUP BY obsForAppointmentDate.person_id
) lostToFollowUpPatients
INNER JOIN person personForDetails ON lostToFollowUpPatients.person_id = personForDetails.person_id
LEFT JOIN concept_view cvForGettingDeathReason ON personForDetails.cause_of_death = cvForGettingDeathReason.concept_id
INNER JOIN person_name personalDetails ON lostToFollowUpPatients.person_id = personalDetails.person_id
INNER JOIN patient_identifier pi ON lostToFollowUpPatients.person_id = pi.patient_id AND pi.voided = 0
  LEFT JOIN (
  /* TB Program Data */
   SELECT
  tb_latest_program.visit_id,
  tb_latest_program.date_started,
  tb_latest_program.patient_id,
  pi.identifier as "IdPatient",
  tb_latest_program.patient_program_id,
  tb_latest_program.rec_enrolledDate,
  date(pp1.date_completed) as rec_completedDate,
  concept_v.concept_short_name as rec_outcome
FROM
( /* Get the latest TB program for a patient*/
select
 v.visit_id,
 date(v.date_started) AS date_started,
 v.patient_id,
 tb_program.patient_program_id,
 max(tb_program.enrolledDate) as rec_enrolledDate
 from visit v
 left join
 (
  select
      pp.patient_program_id,
      pp.patient_id,
      date(pp.date_enrolled) AS enrolledDate
          FROM patient_program pp
          INNER JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE AND pp.voided = 0 AND p.name = 'Programme TB'
          WHERE pp.voided = 0
          ORDER BY date_enrolled DESC
 ) tb_program on v.patient_id = tb_program.patient_id and tb_program.enrolledDate <= v.date_started
 GROUP BY visit_id ) tb_latest_program
 INNER JOIN patient_identifier pi ON tb_latest_program.patient_id = pi.patient_id AND pi.voided IS FALSE
 INNER JOIN patient_program pp1 ON pp1.patient_program_id = tb_latest_program.patient_program_id AND pp1.patient_id = tb_latest_program.patient_id
 LEFT JOIN concept_view concept_v ON concept_v.concept_id = pp1.outcome_concept_id
  ) tb_program_data ON tb_program_data.visit_id = lostToFollowUpPatients.visit_id AND tb_program_data.patient_id = lostToFollowUpPatients.person_id
LEFT JOIN (
  /*ARV enrollment Date*/
         SELECT pp.patient_id, date(pp.date_enrolled) AS enrolledDate
         FROM patient_program pp
          INNER JOIN (SELECT ARV_prog.patient_id, max(ARV_prog.date_enrolled) AS date_enrolled
           FROM (SELECT pp.patient_id, pp.program_id, pp.date_enrolled
                 FROM patient_program pp
                  INNER JOIN program p
                   ON pp.program_id = p.program_id AND p.retired IS FALSE AND pp.voided = 0 AND p.name = 'Programme ARV'
                   ) ARV_prog
                         GROUP BY patient_id) latest_arv_prog ON latest_arv_prog.patient_id = pp.patient_id AND latest_arv_prog.date_enrolled = pp.date_enrolled
                  INNER JOIN program p ON pp.program_id = p.program_id AND p.retired IS FALSE
         GROUP BY patient_id
  ) AS arvpgm ON arvpgm.patient_id = lostToFollowUpPatients.person_id
LEFT JOIN (
/* --Get ARV regimen details for the patients per visit START --*/
 SELECT
  regimen.visit_id,
  regimen.encounter_id,
  regimen.obs_id,
  regimen.patient_id,
  regimen.IDPatient,
  regimen.value as regimen_arv,
  reg_start_dates.regimen_start_date
  FROM
  (
  /* Regimen Name*/
  SELECT
        oTest1.obs_id,
        oTest1.obs_group_id,
    et1.encounter_id,
        oTest1.value_coded,
        v.visit_id,
        v.date_started as visit_date,
        (SELECT concept_full_name FROM concept_view WHERE concept_id = oTest1.value_coded LIMIT 1) AS VALUE,
        et1.patient_id,
        pi.identifier as IDPatient
  FROM obs oTest1
  INNER JOIN encounter et1 ON et1.encounter_id = oTest1.encounter_id AND et1.voided IS FALSE
  INNER JOIN visit v ON v.visit_id = et1.visit_id
  INNER JOIN patient_identifier pi ON v.patient_id = pi.patient_id AND pi.voided IS FALSE
  INNER JOIN concept_view concept_v1 ON concept_v1.concept_id = oTest1.concept_id
  AND concept_v1.concept_full_name IN ('RA, ARV Line','CAI, ARV Line','ARV','CSI, ARV Line')
  AND oTest1.voided IS FALSE AND concept_v1.retired IS FALSE
  WHERE oTest1.value_coded IS NOT NULL
  /*GROUP BY patient_id,visit_id */
  )  AS regimen
  LEFT JOIN
  ( /* Regimen Starting Date*/
  SELECT
        oTest1.obs_id,
        oTest1.obs_group_id,
    et1.encounter_id,
        oTest1.value_datetime as 'regimen_start_date',
        v.visit_id,
        v.date_started as visit_date,
        et1.patient_id,
        pi.identifier
  FROM obs oTest1
  INNER JOIN encounter et1 ON et1.encounter_id = oTest1.encounter_id AND et1.voided IS FALSE
  INNER JOIN visit v ON v.visit_id = et1.visit_id
  INNER JOIN patient_identifier pi ON v.patient_id = pi.patient_id AND pi.voided IS FALSE
  INNER JOIN concept_view concept_v1 ON concept_v1.concept_id = oTest1.concept_id
  AND concept_v1.concept_full_name IN ('Regimen Start date','CAI, Date début Regime ARV','CSI, Date début Regime ARV','HA, Date début')
  AND oTest1.voided IS FALSE AND concept_v1.retired IS FALSE
  WHERE oTest1.value_datetime IS NOT NULL
  /*GROUP BY patient_id,visit_id */
  ) AS reg_start_dates ON reg_start_dates.obs_group_id = regimen.obs_group_id AND reg_start_dates.patient_id = regimen.patient_id
ORDER BY regimen.patient_id DESC,reg_start_dates.regimen_start_date DESC
/* --Get latest ARV regimen details for the patients END --*/
) AS reg ON reg.patient_id = pi.patient_id  AND reg.regimen_start_date <= lostToFollowUpPatients.visitDate

WHERE DATE_ADD(DATE(lostToFollowUpPatients.appointmentDate), INTERVAL 0 DAY) < DATE('#endDate#') /* Condition 1 & 2 To remove the patient if appt date + 3 days is less than reporting end date. (Not considered as lost to followup patients.)*/
GROUP BY lostToFollowUpPatients.person_id
ORDER BY lostToFollowUpPatients.obs_id DESC
) AS MyData/*SUBQUERY 2 END*/
WHERE MyData.DateDebutTBRecent IS NOT NULL AND MyData.DateFinTBRecent IS NULL;
