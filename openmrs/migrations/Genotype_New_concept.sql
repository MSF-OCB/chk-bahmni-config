set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;

call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Test Genotypage','Test Genotypage ','N/A','LabSet',true);

call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'AZATANAVIR/r(Resistance)','AZATANAVIR/r(Resistance)','Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'DARUNAVIR/r(Resistance)','DARUNAVIR/r(Resistance)','Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'FOSAMPRENAVIR/r(Resistance)','FOSAMPRENAVIR/r(Resistance)','Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'INDINAVIR/r(Resistance)','INDINAVIR/r(Resistance)','Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'LOPINAVIR/r(Resistance)','LOPINAVIR/r(Resistance)','Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'NELFINAVIR/r(Resistance)','NELFINAVIR/r(Resistance)','Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'SAQUINAVIR/r(Resistance)','SAQUINAVIR/r(Resistance)','Coded','LabTest',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'TIPRANAVIR/r(Resistance)','TIPRANAVIR/r(Resistance)','Coded','LabTest',false);

call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"High","High",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Intermediate","Intermediate",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Low","Low",'N/A','Misc',false);
call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Susceptible","Susceptible",'N/A','Misc',false);
