
INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Hemogramme' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'Sang','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Hemogramme' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'Sang','en',1,now(),NULL,NULL,uuid());


INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Demande de Transfusion Sanguine(Blood Transfusion Request)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),
'Sang','fr',1,now(),NULL,NULL,uuid());
INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Demande de Transfusion Sanguine(Blood Transfusion Request)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
'Sang','en',1,now(),NULL,NULL,uuid());


INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'CD4 (Panel)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'Sang','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'CD4 (Panel)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'Sang','en',1,now(),NULL,NULL,uuid());


INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Ionogramme' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'Sang','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Ionogramme' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'Sang','en',1,now(),NULL,NULL,uuid());


INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Bilan post hepatique (ANALYSIS DONE AT EXTERNAL FACILITY)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'Sang','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Bilan post hepatique (ANALYSIS DONE AT EXTERNAL FACILITY)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'Sang','en',1,now(),NULL,NULL,uuid());


INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Selles (Panel)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'Selles','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Selles (Panel)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'Selles','en',1,now(),NULL,NULL,uuid());


INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'LCR (Panel)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'LCR','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'LCR (Panel)' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'LCR','en',1,now(),NULL,NULL,uuid());


INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Urine bandelette' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'fr' and voided = 0),'Urine','fr',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) 
VALUES 
((select concept_id from concept_name where name = 'Urine bandelette' and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'Urine','en',1,now(),NULL,NULL,uuid());