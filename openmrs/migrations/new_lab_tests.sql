                set @concept_id = 0;
                set @concept_short_id = 0;
                set @concept_full_id = 0;
                set @count = 0;
                set @uuid = NULL;
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'IPD','IPD','N/A','Department',true);                
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Hémoglobine (IPD)','Hémoglobine (IPD)','Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Glycémie (IPD)','Glycémie (IPD)','Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'TDR - Paludisme (IPD)','TDR - Paludisme (IPD)','Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'CD4 (IPD)','CD4 (IPD)','Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'CD4 % (enfants de - 5 ans) (IPD)','CD4 % (enfants de - 5 ans) (IPD)','Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'TB - LAM (IPD)','TB - LAM (IPD)','Numeric','LabTest',false);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Hémoglobine (IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'g/dl',1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "Glycémie (IPD)" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'mg/dl',1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "CD4 (IPD)" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'cells/µl',1,NULL);
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "CD4 % (enfants de - 5 ans) (IPD)" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);

