select distinct pi.identifier  as "ID Patient",
              group_concat( distinct (case when pat.name='Type de cohorte' then c.name else NULL end)) as "Type Cohorte",
              concat(pn.family_name,' ',ifnull(pn.middle_name,''),' ', ifnull(pn.family_name,'')) as Nom,
              concat(floor(datediff(now(), p.birthdate)/365), ' Années, ',  floor((datediff(now(), p.birthdate)%365)/30),' Mois') as "Age",
              case when p.gender='M' then 'Homme' when p.gender='F' then 'Femme' else null end as Sexe,
              date_format(p.birthdate, '%d/%m/%Y') as "Date de naissance",
              date_format(p.date_created,'%d/%m/%Y') as "Date enregistrement",
               group_concat( distinct ( case when pat.name='Status VIH' then c.name else NULL end )) as "Status VIH",
               group_concat( distinct ( case when pat.name='Date dépistage' then date_format(pa.value,'%d/%m/%Y')  else null end )) as "Date dépistage",
              group_concat( distinct  (  case when pat.name='ARV Naif/ Non Naif' then c.name else NULL end )) as "ARV Naif/ Non Naif",
              group_concat( distinct  (  case when pat.name='Converti CP' then case when pa.value ='true' then 'Oui' else 'Non'  end else null end )) As "Est converti CP",
               group_concat( distinct ( case when pat.name='Date de conversion' then date_format(pa.value,'%d/%m/%Y') else null end)) as "Date conversion",
               group_concat(distinct (case when pat.name='Bébé éxposé' then case when pa.value='true' then 'Oui' else 'Non' end else null end ))as "Est bébé exposé",
               case when p.dead=1 then 'Oui' when p.dead=0 then 'Non' else null end as "Est décédé",
               date_format(p.death_date, '%d/%m/%Y') as "Date de décés",
               group_concat(distinct (case when pat.name ='Lieu de dépistage' then pa.value else null end)) as "Lieu de dépistage",
               group_concat(distinct (case when pat.name='Centre de provenance' then pa.value else null end)) as "Centre de provenance",
               pad.address6 as "Commune",
               pad.address4 as "Quartier",
               pad.address3 as "Rue",
               pad.address2 as "No",
               group_concat(distinct (case when pat.name='Tel 1' then pa.value else null end)) as "Tel 1",
               group_concat(distinct (case when pat.name='Tel 2' then pa.value else null end)) as "Tel 2",
               group_concat(distinct (case when pat.name ='Etat Civil' then c.name else null end)) as "Eta Civil",
               group_concat(distinct (case when pat.name='Situation Parental(enfants)' then c.name else null end)) as"Situation Parental",
               group_concat(distinct (case when pat.name="Niveau d'etudes" then c.name else null end ))as "Niveau étude",
               group_concat(distinct (case when pat.name='Occupation' then pa.value else null end)) as "Occupation",
               group_concat(distinct (case when pat.name='Religion' then c.name else null end)) as "Réligion",
               group_concat(distinct (case when pat.name="Membre d'un réseau PVVIH" then c.name else null end)) as "Membre réseau PVVIH",
               group_concat(distinct (case when pat.name="Resident à Kinshasa" then c.name else null end)) as "Rés. à Kinshasa",
               group_concat(distinct (case when pat.name="Pays d'origine(autre que RDC)" then c.name else null end)) as "Pays origine",
               group_concat(distinct (case when pat.name="Province de provenance" then c.name else null end)) as "Prov. De provenance",
               group_concat(distinct (case when pat.name="Frequente un tradipraticien" then c.name else null end)) as "Fréquente tradipraticien",
               group_concat(distinct (case when pat.name="Nom du contact" then pa.value else null end)) as "Nom contact",
               group_concat(distinct (case when pat.name="Tel 1 du Contact" then pa.value else null end)) as "Tel 1 Contact",
               group_concat(distinct (case when pat.name="Tel 2 du Contact" then pa.value else null end)) as "Tel 2 Contact"    
               from
              person_attribute pa join person_attribute_type pat on pa.person_attribute_type_id=pat.person_attribute_type_id
              join person p on p.person_id=pa.person_id
              join person_name pn on  p.person_id=pn.person_id
              join patient_identifier pi on p.person_id=pi.patient_id
              left outer join person_address pad on pad.person_id=p.person_id
              LEFT OUTER join concept_name c on c.concept_id=pa.value
               and p.date_created BETWEEN '#startDate#' and '#endDate#'
              group by p.person_id;    
