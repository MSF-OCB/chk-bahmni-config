
select distinct pi.identifier  as "ID Patient",
                group_concat( distinct (case when pat.name='Type de cohorte' then c.name else NULL end)) as "Type Cohorte",
                concat(pn.family_name,' ',ifnull(pn.middle_name,''),' ', ifnull(pn.given_name,'')) as Nom,
                concat(floor(datediff(now(), p.birthdate)/365), ' ans, ',  floor((datediff(now(), p.birthdate)%365)/30),' mois') as "Age",
                case when p.gender='M' then 'Homme' when p.gender='F' then 'Femme' else null end as Sexe,
                date_format(p.birthdate, '%d/%m/%Y') as "Date de naissance",
                date_format(p.date_created,'%d/%m/%Y') as "Date enregistrement",
                group_concat( distinct  (  case when pat.name='Date entrée cohorte' then  date(pae.value)  else  null end )) As "Date entrée cohorte",
                group_concat( distinct ( case when pat.name='Status VIH' then c.name else NULL end )) as "Status VIH",
                group_concat( distinct ( case when pat.name like '%Date%epist%' then date(pa.value)  else null end )) as "Date dépistage",
                group_concat( distinct  (  case when pat.name='ARV Naif/ Non Naif' then c.name else NULL end )) as "ARV Naif/ Non Naif",
                group_concat( distinct  (  case when pat.name='Converti CP' then case when pa.value ='true' then 'Oui' else 'Non'  end else null end )) As "Est converti CP",
                group_concat( distinct ( case when pat.name='Date de conversion' then date_format(pa.value,'%d/%m/%Y') else null end)) as "Date conversion",
                group_concat(distinct (case when pat.name like '%B%xpos%' then case when pa.value='true' then 'Oui' else 'Non' end else null end ))as "Est bébé exposé",
                group_concat(distinct( case when pi.identifier  then (select identifier from patient_identifier where patient_id = r2.person_b) else null end)) AS "Nro Mére(Bébé éxposé)",
                case when p.dead=1 then 'Oui' when p.dead=0 then 'Non' else null end as "Est décédé",
                date_format(p.death_date, '%d/%m/%Y') as "Date de décés",
                cn_death.name as "Raison du décés",
                group_concat(distinct (case when pat.name like '%Lieu%de%stage%' then pa.value else null end)) as "Lieu de dépistage",
                group_concat(distinct (case when pat.name ='Categorie Centre de provenance' then c.name else null end)) as "Categorie Centre de provenance",
                group_concat(distinct (case when pat.name='Centre de provenance' then pa.value else null end)) as "Centre de provenance",
                pad.COUNTY_DISTRICT as "Commune",
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
                group_concat(distinct (case when pat.name like "%Membre%seau%PVVIH%" then c.name else null end)) as "Membre réseau PVVIH",
                group_concat(distinct (case when pat.name like "%Resident%Kinshasa" then c.name else null end)) as "Rés. à Kinshasa",
                group_concat(distinct (case when pat.name="Pays d'origine(autre que RDC)" then c.name else null end)) as "Pays origine",
                group_concat(distinct (case when pat.name="Province de provenance" then c.name else null end)) as "Prov. De provenance",
                group_concat(distinct (case when pat.name="Frequente un tradipraticien" then c.name else null end)) as "Fréquente tradipraticien",
                group_concat(distinct (case when pat.name="Nom du contact" then pa.value else null end)) as "Nom contact",
                group_concat(distinct (case when pat.name="Tel 1 du Contact" then pa.value else null end)) as "Tel 1 Contact",
                group_concat(distinct (case when pat.name="Tel 2 du Contact" then pa.value else null end)) as "Tel 2 Contact"
from  patient_identifier pi
    join person p on p.person_id=pi.patient_id
    join person_name pn on pn.person_id=p.person_id
    left join person_attribute pa on p.person_id=pa.person_id and pa.voided=0
    left join person_attribute pae on p.person_id=pae.person_id and pae.voided=0

    left join person_attribute_type pat on  pa.person_attribute_type_id=pat.person_attribute_type_id

    left join person_address pad on pad.person_id=p.person_id
    left  join relationship r on r.person_b=pi.patient_id
    left  join relationship r2 on r2.person_a=pi.patient_id
    left join concept_name c on c.concept_id=pa.value and c.voided = 0 and c.locale_preferred=1
    left outer join concept_name cn_death on cn_death.concept_id = p.cause_of_death AND cn_death.locale_preferred = 1 AND cn_death.voided IS FALSE AND p.voided IS FALSE
where date(pae.value)

BETWEEN date('#startDate#') and Date('#endDate#')

group by pi.identifier,r.person_b;
