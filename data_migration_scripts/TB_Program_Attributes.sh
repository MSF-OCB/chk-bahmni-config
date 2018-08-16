#!/bin/bash

#excluding the first row in csv file if header is present

awk 'NR>1' $1
while read line
do
    IFS=',' read -r -a row <<< "$line"
    patient_enroll=" insert into patient_program (patient_id,program_id,date_enrolled,date_completed,outcome_concept_id,creator,date_created,uuid) values ((select patient_id from patient_identifier where identifier ='${row[0]}'),(select program_id from program where name ='Programme TB'), str_to_date('${row[1]}', '%m/%d/%Y'),str_to_date('${row[2]}', '%m/%d/%Y'), (select concept_id from concept_name where name ='${row[6]}' and concept_name_type='FULLY_SPECIFIED' and locale='fr'), (select user_id from users where username='admin'), now(),uuid()); "

    attribute_one=" insert into patient_program_attribute (patient_program_id,attribute_type_id,value_reference,uuid,creator,date_created,voided) values ((select patient_program_id from patient_program where patient_id in(select patient_id from patient_identifier where identifier= ${row[0]}) and program_id in (select program_id from program where name ='Programme TB')),
    (select distinct program_attribute_type_id from program_attribute_type where name ='TB Type' ),
    (select distinct concept_id from concept_name where name ='${row[3]}' and concept_name_type='FULLY_SPECIFIED' and locale='fr'),
    uuid(),
    (select user_id from users where username='admin'),
    now(),
     0
    ); "

    attribute_two=" insert into patient_program_attribute (patient_program_id,attribute_type_id,value_reference,uuid,creator,date_created,voided)
    values (
    (select patient_program_id from patient_program where patient_id in(select patient_id from patient_identifier where identifier= ${row[0]}) and program_id in (select program_id from program where name ='Programme TB')),
    (select distinct program_attribute_type_id from program_attribute_type where name ='Site TEP' ),
    (select distinct concept_id from concept_name where name ='${row[4]}' and concept_name_type='FULLY_SPECIFIED'),
    uuid(),
    (select user_id from users where username='admin'),
    now(),
     0
    ); "

    attribute_three=" insert into patient_program_attribute (patient_program_id,attribute_type_id,value_reference,uuid,creator,date_created,voided)
    values (
    (select patient_program_id from patient_program where patient_id in(select patient_id from patient_identifier where identifier= ${row[0]}) and program_id in (select program_id from program where name ='Programme TB')),
    (select distinct program_attribute_type_id from program_attribute_type where name ='Motif début traitement'),
    (select distinct concept_id from concept_name where name ='${row[5]}' and concept_name_type='FULLY_SPECIFIED' and locale='fr'),
    uuid(),
    (select user_id from users where username='admin'),
    now(),
     0
    ); "
    insertQuery+="$patient_enroll $attribute_one $attribute_two $attribute_three"

done < $1
echo $insertQuery | mysql -uroot -p$PleaseEnterpassword openmrs
