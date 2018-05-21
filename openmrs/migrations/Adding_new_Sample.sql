  set @concept_id = 0;
                set @concept_short_id = 0;
                set @concept_full_id = 0;
                set @count = 0;
                set @uuid = NULL;
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Bilan à l’admission - IPD","Bilan à l’admission - IPD",'N/A','Sample',true);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Bilan de routine IPD','Bilan de routine IPD','N/A','LabSet',true);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Genexpert(Panel)','Genexpert','N/A','LabSet',true);

call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Charge Virale - Value(Bilan de routine IPD)','Charge Virale - Value(Bilan de routine IPD)','Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Charge Virale - Log(Bilan de routine IPD)','Charge Virale - Log(Bilan de routine IPD)','Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Créatinine(Bilan de routine IPD)','Créatinine(Bilan de routine IPD)','Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'GPT(Bilan de routine IPD)','GPT(Bilan de routine IPD)','Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"CD4(Bilan de routine IPD)","CD4(Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Glycémie(Bilan de routine IPD)","Glycémie(Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"TDR - Malaria(Bilan de routine IPD)","TDR - Malaria(Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Crag sérique(Bilan de routine IPD)","Crag sérique(Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Syphilis(Bilan de routine IPD)","Syphilis(Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Hépatite B(Bilan de routine IPD)","Hépatite B(Bilan de routine IPD)",'Coded','LabTest',false);

call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Genexpert (LCR - Bilan de routine IPD)","Genexpert (LCR - Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Genexpert (Ascite - Bilan de routine IPD)","Genexpert (Ascite - Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Genexpert (Urine - Bilan de routine IPD)","Genexpert (Urine - Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Genexpert (Synovial - Bilan de routine IPD)","Genexpert (Synovial - Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Genexpert (Crachat - Bilan de routine IPD)","Genexpert (Crachat - Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Genexpert TB (LCR - Bilan de routine IPD)","Genexpert TB (LCR - Bilan de routine IPD",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Genexpert (Pleural - Bilan de routine IPD)","Genexpert (Pleural - Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Genexpert (Pus - Bilan de routine IPD)","Genexpert (Pus - Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Genexpert (Ganglionnaire - Bilan de routine IPD)","Genexpert (Ganglionnaire - Bilan de routine IPD)",'Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Genexpert (Gastrique - Bilan de routine IPD)","Genexpert (Gastrique - Bilan de routine IPD)",'Coded','LabTest',false);

call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Globules Blancs(Bilan de routine IPD)","Globules Blancs(Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Globules Rouges(Bilan de routine IPD)","Globules Rouges(Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Hemoglobine(Bilan de routine IPD)","Hemoglobine(Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Hematocrite(Bilan de routine IPD)","Hematocrite(Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"VGM(Bilan de routine IPD)","VGM(Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"CCMH(Bilan de routine IPD)","CCMH(Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"LYM%(Bilan de routine IPD)","LYM%(Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Plaquettes(Bilan de routine IPD)","Plaquettes(Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"MXD% (Eosino+Monocytes - Bilan de routine IPD)","MXD% (Eosino+Monocytes - Bilan de routine IPD)",'Numeric','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"NEUT%(Bilan de routine IPD)","NEUT%(Bilan de routine IPD)",'Numeric','LabTest',false);


INSERT INTO concept_numeric
(concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES
 ((select concept_id from concept_name where name = 'Charge Virale - Value(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
NULL,NULL,NULL,NULL,NULL,NULL,'copies/ml',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES
 ((select concept_id from concept_name where name = 'Charge Virale - Log(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
 NULL,NULL,NULL,NULL,NULL,NULL,'log',1,NULL);

INSERT INTO concept_numeric
(concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES
 ((select concept_id from concept_name where name = 'CD4(Bilan de routine IPD)'
 and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
 NULL,NULL,NULL,NULL,NULL,NULL,'UI/L',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = 'Glycémie(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'mg/dl',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
 VALUES ((select concept_id from concept_name where name = 'Globules Blancs(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'10³/mm³',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,
units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Globules Rouges(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr'
and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'10⁶/mm³',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Hemoglobine(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr'
and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'g/dl',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Hematocrite(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr'
 and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'VGM(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
NULL,NULL,NULL,NULL,NULL,NULL,'fl',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'CCMH(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Plaquettes(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
NULL,NULL,NULL,NULL,NULL,NULL,'10³/mm³',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'LYM%(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'MXD% (Eosino+Monocytes - Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'NEUT%(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Créatinine(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
NULL,NULL,NULL,NULL,NULL,NULL,'µmol/L',1,NULL);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'GPT(Bilan de routine IPD)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
NULL,NULL,NULL,NULL,NULL,NULL,'UI/L',1,NULL);



