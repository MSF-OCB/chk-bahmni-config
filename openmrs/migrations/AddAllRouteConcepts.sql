				set @concept_id = 0;
                set @concept_short_id = 0;
                set @concept_full_id = 0;
                set @count = 0;

call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'À manger','À manger','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Application locale','Application locale','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Inhallation','Inhallation','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Injectable','Injectable','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Orale','Orale','N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Perfusion','Perfusion','N/A','Misc',false);
