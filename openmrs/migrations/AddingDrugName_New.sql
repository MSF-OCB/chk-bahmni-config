insert into drug (concept_id,name,dosage_form,route,creator,date_created,uuid) 
values (
(select concept_id from concept_name where name = "ABC" and concept_name_type = 'FULLY_SPECIFIED' and locale='fr' and voided = 0),
"ABC 600 mg / 3TC 300 mg, comp",
(select concept_id from concept_name where name ="Comprimé" and concept_name_type = 'FULLY_SPECIFIED' and locale='fr' and voided = 0),
(select concept_id from concept_name where name ="Orale" and concept_name_type = 'FULLY_SPECIFIED' and locale='fr' and voided = 0),
(select user_id from users where username ="superman"),now(),uuid());