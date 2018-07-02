set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;



call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Prophylaxie, Dapsone",'DAPSONE','N/A','Misc',false );
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Prophylaxie, Fluconazole",'FLUCONAZOLE','N/A','Misc',false );
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Prophylaxie, Albendazole",'ALBENDAZOLE','N/A','Misc',false );
