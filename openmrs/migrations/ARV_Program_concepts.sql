set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Programme ARV','Programme ARV','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'ARV Line','ARV Line','Coded','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'1ere(ARV)','1ere','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'2e(ARV)','2e','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'3e(ARV)','3e','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'1ere alternative(ARV)','1ere alternative','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'2e alternative(ARV)','2e alternative','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'3e alternative(ARV)','3e alternative','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'autres(ARV Program)','autres','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'ARV outcome','ARV outcome','N/A','Misc',true);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Décédé","Décédé",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Autre(ARV)','Autre','N/A','Misc',false);


