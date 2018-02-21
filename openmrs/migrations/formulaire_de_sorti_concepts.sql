set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Formulaire de sortie','Formulaire de sortie','N/A','Misc',true);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Date de sortie','Date de sortie','Datetime','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Ligne','Ligne','Coded','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Mis sous ARV en hospitalization','Mis sous ARV en hospitalization','Coded','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Date initiation','Date initiation','Date','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Syndrome','Syndrome','Coded','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,"Si autre, veuillez préciser","Si autre, veuillez préciser",'Text','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Traitement à la sortie','Traitement à la sortie','Text','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Traitemtent TB commencé?','Traitemtent TB commencé?','Coded','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Date début','Date début','Datetime','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Mode de sortie','Mode de sortie','Coded','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Date du prochain RDV','Date du prochain RDV','Datetime','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'1ère Ligne','1ère Ligne','N/A','Misc',false);   
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'2ème Ligne','2ème Ligne','N/A','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'3ème Ligne','3ème Ligne','N/A','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Pas sous ARV','Pas sous ARV','N/A','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Retour à domicile','Retour à domicile','N/A','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Abandon','Abandon','N/A','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Referé','Referé','N/A','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Décés','Décés','N/A','Misc',false);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Arv à la sortie','Arv à la sortie','N/A','Misc',true);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Syndrome et Diagnostic','Syndrome et Diagnostic','N/A','Misc',true);
     call add_concept_fr(@concept_id,@concept_short_id,@concept_full_id,'Syndrome à la sortie','Syndrome à la sortie','N/A','Misc',true);









        

     
