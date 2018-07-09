set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;


call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Flacon","Flacon", 'N/A','Misc', FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Plaquette","Plaquette", 'N/A','Misc', FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Poche","Poche", 'N/A','Misc', FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Tube","Tube", 'N/A','Misc', FALSE);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Puff","Puff", 'N/A','Misc', FALSE);
