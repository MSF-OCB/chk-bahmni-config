insert into person_attribute (uuid, person_id, creator, date_created, person_attribute_type_id, value)
select uuid() as uuid,
       a.person_id,
       (select user_id
        from users
        where username = "superman"
       ) as creator,
       now() as date_created,
       (select person_attribute_type_id
        from person_attribute_type
        where name = "Categorie Centre de provenance"
       ) as person_attribute_type_id,
       -- Select the concept id from the concept which is an answer to "Cat Centre de prov"
       -- and whose name correspondes to the name determinded by the case expression.
       (select distinct n.concept_id
        from concept_name n inner join concept_answer ca
          on n.concept_id = ca.answer_concept
        where ca.concept_id = (select foreign_key
                               from person_attribute_type
                               where name = "Categorie Centre de provenance")
          -- and n.locale = "fr"
          and n.concept_name_type = "FULLY_SPECIFIED"
          and n.name = case
            -- when a.value in ()
            --   then "CDV famille"
            when a.value in ("Podi Funa")
              then "PODI"
            when a.value in (
              "2ème rue",
              "2ème rue limete",
              "Akram",
              "AMO CONGO",
              "APRODI",
              "Armée du Salut",
              "Armée du Salut Ndjili",
              "Auto réf",
              "Auto-référence",
              "Auto-référence AMOCONGO",
              "Auto-référence Angola",
              "Auto-référence CDVF",
              "Auto-référence Gabon",
              "Auto-référence Kinsanagani",
              "Auto-référence Lumbashi",
              "Auto-référence Mbuji Mayi",
              "Auto-référence Muji Mayi",
              "Auto-référence/ Centre inconnu",
              "Autoréférence",
              "Autoréférence BRAZZA",
              "Brazza auto-réf",
              "CONVIVIAL ASEPROVIC",
              "Edith Cavell 3",
              "Kikimi",
              "non connu",
              "Non identifié",
              "Pamela",
              "PASCO",
              "Sainte-Rita",
              "Sendwe / Katanga"        
            )
              then "Autres"
            else "Centre partenaires"
          end
       ) as value
-- We insert a row for every person attribute of type "Centre de provenance"
-- for which no person attribute of type "Categorie Centre de provenance" exists.
from person_attribute a inner join person_attribute_type a_type
  on a.person_attribute_type_id = a_type.person_attribute_type_id
where a_type.name = "Centre de provenance"
  and not exists (select 1
                  from person_attribute a2 inner join person_attribute_type a2_type
                    on a2.person_attribute_type_id = a2_type.person_attribute_type_id
                  where a.person_id = a2.person_id
                    and a2_type.name = "Categorie Centre de provenance");

