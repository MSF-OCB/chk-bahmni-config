set @concept_id = 0;
set @uuid = NULL;

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Globules Blancs' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'10³/mm³',1,NULL);


INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Globules Rouges' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'10⁶/mm³',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Hematocrite' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'VGM' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'fl',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'CCMH' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Plaquettes' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'10³/mm³',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'LYM%' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'MXD% (Eosino+Monocytes)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'NEUT%' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Numération reticulocyte' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Temps de coagulation' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'min',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Temps de saignement' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'min',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'CD4' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'cells/µl',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'CD4 % (enfants de - 5 ans)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Creatinine' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'µmol/L',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'GPT' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'UI/L',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Glycémie' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'mg/dl',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Numeration GB' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'cells/mm³',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'FL - LYM%' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'FL - MXD%' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'FL - NEUT%' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'%',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'sodium' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'mmol/L',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'potassium' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'mmol/L',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Chlore' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'mmol/L',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Hemoglobine' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'g/dl',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Hemoglobine*' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'g/dl',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Lactate' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'mmol/L',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Gamma GT' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'µmol/L',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Phosphatase alcaline' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'µmol/L',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Glycorachie' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'mg/dl',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Bilirubine totalE' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'UI/L',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Bilirubine directE' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'UI/L',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Charge Virale HIV - Value' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'copies/ml',1,NULL);
 

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = 'Charge Virale HIV - Logarithme' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,'log',1,NULL);
 