     set @concept_id = 0;
     set @concept_short_id = 0;
     set @concept_full_id = 0;
     set @count = 0;
     set @uuid = NULL;
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Effets secondaires - médicaments","Effets secondaires - médicaments",'N/A','Misc',true);                
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Molécule','Molécule','Text','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Effets secondaires','Effets secondaires','Text','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Grade,Suivi','Grade','Coded','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'1,Suivi',"1",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'2,Suivi',"2",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'3,Suivi',"3",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'4,Suivi',"4",'N/A','Misc',false);



