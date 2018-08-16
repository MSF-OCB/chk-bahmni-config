#!/bin/bash

#excluding the first row in the csv Header file#
awk 'NR>1' $1

while read line
do
    IFS=',' read -r -a row <<< "$line"
    patient_phase=" INSERT INTO  patient_state (patient_program_id, state, start_date, date_created, creator, voided,uuid)
    VALUES(
      (select patient_program_id from patient_program where patient_id in
      (select patient_id from patient_identifier where identifier = '${row[0]}') and program_id in(select program_id from program where name='Programme ARV')), (select program_workflow_state_id from program_workflow_state where concept_id in (select concept_id from concept_name where name = '${row[1]}' and locale = 'fr' and concept_name_type = 'SHORT')), str_to_date('${row[2]}', '%m/%d/%Y'), now(),(select user_id from users where username = 'admin'),0,
      uuid()); "
    insertQuery+=$patient_phase
done < $1
echo $insertQuery | mysql -uroot -p$PleaseEnterPassword  openmrs
