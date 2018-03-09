insert into person_attribute_type (name, description, format, foreign_key, searchable, creator, date_created, sort_weight, uuid)
select concat('LienDuDépendant', nr.i),
       concat('Lien du dépendant ', nr.i),
       'org.openmrs.Concept',
       concept_id,
       0,
       user_id,
       now(),
       52,
       uuid()
from concept_name,
     (select 1 as i union all select 2 union all select 3 union all select 4 union all select 5 union all select 6) as nr,
     users
where name = "Lien_Dep"
  and locale = "fr"
  and concept_name_type = "FULLY_SPECIFIED"
  and username = "admin";

insert into person_attribute_type (name, description, format, searchable, creator, date_created, sort_weight, uuid)
select concat('CHKIDDuDépendant', nr.i),
       concat('CHK ID du dépendant ', nr.i),
       'java.lang.String',
       0,
       user_id,
       now(),
       53,
       uuid()
from (select 1 as i union all select 2 union all select 3 union all select 4 union all select 5 union all select 6) as nr,
     users
where username = "admin";

insert into person_attribute_type (name, description, format, searchable, creator, date_created, sort_weight, uuid)
select concat('PrénomDépendant', nr.i),
       concat('Prénom dépendant ', nr.i),
       'java.lang.String',
       0,
       user_id,
       now(),
       54,
       uuid()
from (select 1 as i union all select 2 union all select 3 union all select 4 union all select 5 union all select 6) as nr,
     users
where username = "admin";

insert into person_attribute_type (name, description,format, searchable,creator, date_created, sort_weight, uuid)
select concat('NomDépendant', nr.i),
       concat('Nom dépendant ', nr.i),
       'java.lang.String',
       0,
       user_id,
       now(),
       55,
       uuid()
from (select 1 as i union all select 2 union all select 3 union all select 4 union all select 5 union all select 6) as nr,
     users
where username = "admin";

insert into person_attribute_type (name, description, format, foreign_key, searchable, creator, date_created, sort_weight, uuid)
select concat('EstInforméDuStatutSérologique', nr.i),
       concat('Est informé du statut sérologique ', nr.i),
       'org.openmrs.Concept',
       concept_id,
       0,
       user_id,
       now(),
       56,
       uuid()
from concept_name,
     (select 1 as i union all select 2 union all select 3 union all select 4 union all select 5 union all select 6) as nr,
     users
where name = "Informé du statut VIH du patient_Dep"
  and locale = "fr"
  and concept_name_type = "FULLY_SPECIFIED"
  and username = "admin";

insert into person_attribute_type (name, description, format, foreign_key, searchable, creator, date_created, sort_weight, uuid)
select concat('RésultatDuTestVIH', nr.i),
       concat('Résultat du test VIH ', nr.i),
       'org.openmrs.Concept',
       concept_id,
       0,
       user_id,
       now(),
       57,
       uuid()
from concept_name,
     (select 1 as i union all select 2 union all select 3 union all select 4 union all select 5 union all select 6) as nr,
     users
where name = "Résultat_Dep"
  and locale = "fr"
  and concept_name_type = "FULLY_SPECIFIED"
  and username = "admin";

insert into person_attribute_type (name, description, format, searchable, creator, date_created, sort_weight, uuid)
select concat('DateDeNaissanceDépendant', nr.i),
       concat('Date de naissance dépendant ', nr.i),
       'org.openmrs.util.AttributableDate',
       0,
       user_id,
       now(),
       58,
       uuid()
from (select 1 as i union all select 2 union all select 3 union all select 4 union all select 5 union all select 6) as nr,
     users
where username = "admin";

