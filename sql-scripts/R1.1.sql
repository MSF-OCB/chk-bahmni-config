set character_set_client = 'utf8';
update patient_identifier_type set format = "^(CHK|CP)[0-9]{5,6}$" where name = "Identifiant de patient";
update person_attribute_type set format = 'java.lang.String' where name like 'Tel % du Contact';

