set @hivTypeId=(select person_attribute_type_id from person_attribute_type where name ='Status VIH'); 
set @hivpos = (select concept_id from concept_name where name='VIH+' limit 1);

select @hivTypeId;
select @hivpos;

insert ignore into person_attribute ( date_created,person_id,person_attribute_type_id,value,creator,uuid) select distinct now(),patient_id,@hivTypeId, @hivpos ,1,uuid()   from patient_identifier where patient_id not in (select person_id from person_attribute where person_attribute_type_id=@hivTypeId);

