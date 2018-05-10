set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Triage Form','Triage Form','N/A','Misc',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Temperature Triage','Temperature','Numeric','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Tension arterielle','Tension arterielle','Numeric','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Frequence cardiaque','Frequence cardiaque','Numeric','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Frequence respiratoire','Frequence respiratoire','Numeric','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Saturation','Saturation','Numeric','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Déshydratation','Déshydratation','Coded','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Bien hydraté','Bien hydraté','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Modéré','Modéré','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Sévère','Sévère','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Incapacité de marcher sans aide','Incapacité de marcher sans aid','Coded','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Oui(Triage)','Oui','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Non(Triage)','Non','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Altération de l\'état neurologique','Altération de l\'état neurologique','Coded','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Oui(Triage_1)','Oui','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Non(Triage_1)','Non','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Autre signe neurologique','Autre signe neurologique','Text','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Poids habituel','Poids habituel','Numeric','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Poids','Poids','Numeric','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Taille','Taille','Numeric','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'IMC','IMC','Numeric','Computed',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Symptôme de TB','Symptôme de TB','Coded','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Oui(Triage_2)','Oui','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Non(Triage_2)','Non','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Sous ARV','Sous ARV','Coded','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Oui(Triage_3)','Oui','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Non(Triage_3)','Non','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Hospitalisation récente','Hospitalisation récente','Coded','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Oui(Triage_4)','Oui','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Non(Triage_4)','Non','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Patient Instable','Patient Instable','Coded','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Oui(Triage_5)','Oui','N/A','Misc',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Non(Triage_5)','Non','N/A','Misc',FALSE);

call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Temperature Data','Temeperature','N/A','Concept Details',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Tension_arterielle Data','Tension arterielle','N/A','Concept Details',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Frequence cardiaque Data','Frequence cardiaque','N/A','Concept Details',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Frequence respiratoire Data','Frequence respiratoire','N/A','Concept Details',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Temperature Abnormal','Abnormal','Boolean','Abnormal',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Tension_arterielle Abnormal','Abnormal','Boolean','Abnormal',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Frequence cardiaque Data Abnormal','Abnormal','Boolean','Abnormal',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Frequence respiratoire Data Abnormal','Abnormal','Boolean','Abnormal',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'IMC DATA','IMC','N/A','Concept Details',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'IMC ABNORMAL','IMC ABNORMAL','Boolean','Abnormal',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'IMC STATUS DATA','IMC STATUS','N/A','Concept Details',TRUE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'IMC STATUS','IMC STATUS','Text','Computed',FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'IMC STATUS ABNORMAL','IMC STATUS ABNORMAL','Boolean','Abnormal',FALSE);

INSERT INTO concept_numeric
 (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
  VALUES ((select concept_id from concept_name where name = 'Temperature Triage'
   and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,39,NULL,NULL,0,'°C',1,NULL);

   INSERT INTO concept_numeric
 (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
  VALUES ((select concept_id from concept_name where name = 'Tension arterielle'
   and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,90,'mmHg',1,NULL);

   INSERT INTO concept_numeric
 (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
  VALUES ((select concept_id from concept_name where name = 'Frequence cardiaque'
   and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,120,NULL,NULL,0,'Battement/min',1,NULL);

   INSERT INTO concept_numeric
 (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
  VALUES ((select concept_id from concept_name where name = 'Frequence respiratoire'
   and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,30,NULL,NULL,0,'Cycle/min',1,NULL);

 INSERT INTO concept_numeric
 (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
  VALUES ((select concept_id from concept_name where name = 'Poids habituel'
   and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,0,'Kgs',1,NULL);

 INSERT INTO concept_numeric
 (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
  VALUES ((select concept_id from concept_name where name = 'Poids'
   and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,0,'Kgs',1,NULL);

 INSERT INTO concept_numeric
 (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
  VALUES ((select concept_id from concept_name where name = 'Taille'
   and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,0,'Meters',1,NULL);

INSERT INTO concept_numeric
 (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
  VALUES ((select concept_id from concept_name where name = 'Saturation'
   and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,0,'%',1,NULL);
 INSERT INTO concept_numeric
 (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
  VALUES ((select concept_id from concept_name where name = 'IMC'
   and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,0,NULL,1,NULL);
