SET character_set_client = 'utf8';
update concept_name set name="Rép. du Congo-Brazzaville" where name="Rép. du Congo" and concept_name_type="FULLY_SPECIFIED";
update  concept_name set name="Province d'origine" where name="Province de provenance" and concept_name_type="FULLY_SPECIFIED";
update person_attribute_type SET NAME="Province d'origine" where  name="Province de provenance" and retired = 0;