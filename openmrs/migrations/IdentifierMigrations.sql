set @cohortTypeId=(select person_attribute_type_id from person_attribute_type where name ='Type de cohorte'); 
set @chkName = (select concept_id from concept_name where name='CHK' limit 1);
set @cpName = (select concept_id from concept_name where name='CP' limit 1);

select @cohortTypeId;
select @chkName;
select @cpName;

update patient_identifier set identifier=CONCAT(substr(identifier,1,2),9,substr(identifier,3)) where  identifier in ('CP090021','CP110169','CP130150','CP160340','CP170017','CP170071','CP170157');

insert into person_attribute ( date_created,person_id,person_attribute_type_id,value,creator,uuid) select now(),patient_id,@cohortTypeId, CASE WHEN  SUBSTR(identifier, 1, 2) ='CH' THEN @chkName   WHEN SUBSTR(identifier, 1, 2) = 'CP' THEN @cpName  END,1,uuid()   from patient_identifier where identifier like "C%";

update patient_identifier set identifier=replace( identifier,'CHK','');
update patient_identifier set identifier=replace( identifier,'CP','');

