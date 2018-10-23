
SELECT DISTINCT pi.identifier  AS "ID Patient",
                group_concat( DISTINCT (CASE WHEN pat.name='Type de cohorte' THEN c.name ELSE NULL END)) AS "Type Cohorte",
                concat(pn.family_name,' ',ifnull(pn.middle_name,''),' ', ifnull(pn.given_name,'')) AS Nom,
                concat(floor(datediff(now(), p.birthdate)/365), ' ans, ',  floor((datediff(now(), p.birthdate)%365)/30),' mois') AS "Age",
                CASE WHEN p.gender='M' THEN 'Homme' WHEN p.gender='F' THEN 'Femme' ELSE NULL END AS Sexe,
                date_format(p.birthdate, '%d/%m/%Y') AS "Date de naissance",
                date_format(p.date_created,'%d/%m/%Y') AS "Date enregistrement",
                group_concat(DISTINCT(CASE WHEN pat.name='Date entrée cohorte' THEN  date_format(pae.value,'%d/%m/%Y')  ELSE  NULL END )) AS "Date entrée cohorte",
                group_concat( DISTINCT ( CASE WHEN pat.name='Status VIH' THEN c.name ELSE NULL END )) AS "Status VIH",
                group_concat( DISTINCT ( CASE WHEN pat.name LIKE '%Date%epist%' THEN date_format(pa.value,'%d/%m/%Y')  ELSE NULL END )) AS "Date dépistage",
                group_concat( DISTINCT  (  CASE WHEN pat.name='ARV Naif/ Non Naif' THEN c.name ELSE NULL END )) AS "ARV Naif/ Non Naif",
                group_concat( DISTINCT  (  CASE WHEN pat.name='Converti CP' THEN CASE WHEN pa.value ='true' THEN 'Oui' ELSE 'Non'  END ELSE NULL END )) AS "Est converti CP",
                group_concat( DISTINCT ( CASE WHEN pat.name='Date de conversion' THEN date_format(pa.value,'%d/%m/%Y') ELSE NULL END)) AS "Date conversion",
                group_concat(DISTINCT (CASE WHEN pat.name LIKE '%B%xpos%' THEN CASE WHEN pa.value='true' THEN 'Oui' ELSE 'Non' END ELSE NULL END ))AS "Est bébé exposé",
                group_concat(DISTINCT( CASE WHEN pi.identifier  THEN (SELECT identifier FROM patient_identifier WHERE patient_id = r2.person_b) ELSE NULL END)) AS "Nro Mére(Bébé éxposé)",
                CASE WHEN p.dead=1 THEN 'Oui' WHEN p.dead=0 THEN 'Non' ELSE NULL END AS "Est décédé",
                date_format(p.death_date, '%d/%m/%Y') AS "Date de décés",
                cn_death.name AS "Raison du décés",
                group_concat(DISTINCT (CASE WHEN pat.name LIKE '%Lieu%de%stage%' THEN pa.value ELSE NULL END)) AS "Lieu de dépistage",
                group_concat(DISTINCT (CASE WHEN pat.name ='Categorie Centre de provenance' THEN c.name ELSE NULL END)) AS "Categorie Centre de provenance",
                group_concat(DISTINCT (CASE WHEN pat.name='Centre de provenance' THEN pa.value ELSE NULL END)) AS "Centre de provenance",
                pad.COUNTY_DISTRICT AS "Commune",
                pad.address4 AS "Quartier",
                pad.address3 AS "Rue",
                pad.address2 AS "No",
                group_concat(DISTINCT (CASE WHEN pat.name='Tel 1' THEN pa.value ELSE NULL END)) AS "Tel 1",
                group_concat(DISTINCT (CASE WHEN pat.name='Tel 2' THEN pa.value ELSE NULL END)) AS "Tel 2",
                group_concat(DISTINCT (CASE WHEN pat.name ='Etat Civil' THEN c.name ELSE NULL END)) AS "Eta Civil",
                group_concat(DISTINCT (CASE WHEN pat.name='Situation Parental(enfants)' THEN c.name ELSE NULL END)) AS"Situation Parental",
                group_concat(DISTINCT (CASE WHEN pat.name="Niveau d'etudes" THEN c.name ELSE NULL END ))AS "Niveau étude",
                group_concat(DISTINCT (CASE WHEN pat.name='Occupation' THEN pa.value ELSE NULL END)) AS "Occupation",
                group_concat(DISTINCT (CASE WHEN pat.name='Religion' THEN c.name ELSE NULL END)) AS "Réligion",
                group_concat(DISTINCT (CASE WHEN pat.name LIKE "%Membre%seau%PVVIH%" THEN c.name ELSE NULL END)) AS "Membre réseau PVVIH",
                group_concat(DISTINCT (CASE WHEN pat.name LIKE "%Resident%Kinshasa" THEN c.name ELSE NULL END)) AS "Rés. à Kinshasa",
                group_concat(DISTINCT (CASE WHEN pat.name="Pays d'origine(autre que RDC)" THEN c.name ELSE NULL END)) AS "Pays origine",
                group_concat(DISTINCT (CASE WHEN pat.name="Province de provenance" THEN c.name ELSE NULL END)) AS "Prov. De provenance",
                group_concat(DISTINCT (CASE WHEN pat.name="Frequente un tradipraticien" THEN c.name ELSE NULL END)) AS "Fréquente tradipraticien",
                group_concat(DISTINCT (CASE WHEN pat.name="Nom du contact" THEN pa.value ELSE NULL END)) AS "Nom contact",
                group_concat(DISTINCT (CASE WHEN pat.name="Tel 1 du Contact" THEN pa.value ELSE NULL END)) AS "Tel 1 Contact",
                group_concat(DISTINCT (CASE WHEN pat.name="Tel 2 du Contact" THEN pa.value ELSE NULL END)) AS "Tel 2 Contact"
FROM  patient_identifier pi
    JOIN person p ON p.person_id=pi.patient_id
    JOIN person_name pn ON pn.person_id=p.person_id
    LEFT JOIN person_attribute pa ON p.person_id=pa.person_id AND pa.voided=0
    LEFT JOIN person_attribute_type pat ON  pa.person_attribute_type_id=pat.person_attribute_type_id
    LEFT JOIN person_attribute pae ON p.person_id=pae.person_id AND pae.voided=0
    LEFT JOIN person_attribute_type pate ON  pae.person_attribute_type_id=pate.person_attribute_type_id
    LEFT JOIN person_address pad ON pad.person_id=p.person_id
    LEFT  JOIN relationship r ON r.person_b=pi.patient_id
    LEFT  JOIN relationship r2 ON r2.person_a=pi.patient_id
    LEFT JOIN concept_name c ON c.concept_id=pa.value AND c.voided = 0 AND c.locale_preferred=1
    LEFT OUTER JOIN concept_name cn_death ON cn_death.concept_id = p.cause_of_death AND cn_death.locale_preferred = 1 AND cn_death.voided IS FALSE AND p.voided IS FALSE

    WHERE date(pae.value) BETWEEN date('#startDate#') AND Date('#endDate#')
    AND pate.person_attribute_type_id = (SELECT person_attribute_type_id FROM person_attribute_type WHERE `name` = "Date entrée cohorte")

GROUP BY pi.identifier,r.person_b;
