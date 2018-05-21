
update concept_numeric set low_normal = NULL where concept_id =(select concept_id
from concept_name where name ='Temperature Triage' and concept_name_type='FULLY_SPECIFIED'
and locale='fr' and voided=0);

update concept_numeric set low_normal = NULL where concept_id =(select concept_id
from concept_name where name ='Frequence cardiaque' and concept_name_type='FULLY_SPECIFIED'
and locale='fr' and voided=0);

update concept_numeric set low_normal = NULL where concept_id =(select concept_id
from concept_name where name ='Frequence respiratoire' and concept_name_type='FULLY_SPECIFIED'
and locale='fr' and voided=0);

update concept_numeric set precise = 1 ,low_normal= NULL where concept_id =(select concept_id
from concept_name where name ='Saturation' and concept_name_type='FULLY_SPECIFIED'
and locale='fr' and voided=0);

update concept_numeric set precise = 1,low_normal= NULL where concept_id =(select concept_id
from concept_name where name ='Poids habituel' and concept_name_type='FULLY_SPECIFIED'
and locale='fr' and voided=0);

update concept_numeric set precise = 1,low_normal= NULL where concept_id =(select concept_id
from concept_name where name ='Poids' and concept_name_type='FULLY_SPECIFIED'
and locale='fr' and voided=0);

update concept_numeric set precise = 1,low_normal = NULL where concept_id =(select concept_id
from concept_name where name ='Taille' and concept_name_type='FULLY_SPECIFIED'
and locale='fr' and voided=0);

update concept_name set name ='Temperature' where name ='Temeperature' and concept_name_type='SHORT'
and locale in ('fr','en');
