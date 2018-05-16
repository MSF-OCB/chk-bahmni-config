set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Programme TB','Programme TB','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'TB Outcome','TB Outcome','N/A','Misc',true);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Echec','Echec','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Référé','Référé','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Motif début traitement","Motif début traitement",'Coded','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Nouveau patient','Nouveau patient','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Rechute","Rechute",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Traitement après echec","Traitement après echec",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Traitement après perdu de vue","Traitement après perdu de vue",'N/A','Misc',false);

call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'TB Type','TB Type','Coded','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Pulmonaire-Bactériologiquement confirmé","Pulmonaire-Bactériologiquement confirmé",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Pulmonaire-Cliniquement Confirmé","Pulmonaire-Cliniquement Confirmé",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Site TEP","Site TEP",'Coded','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Abdominale","Abdominale",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Ganglionnaire","Ganglionnaire",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Mal de pott","Mal de pott",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Meningé","Meningé",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Miliaire","Miliaire",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Os et articulaire","Os et articulaire",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Pericardite","Pericardite",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Pleuresie","Pleuresie",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Poly-serosite","Poly-serosite",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"TB Program Workflow","TB Program Workflow",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Program States for TB','Program states','Coded','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Intensive(ARV)','Intensive','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Entretien(ARV)','Entretien','N/A','Misc',false);



