SELECT
	 pi.identifier AS 'PatientID', 
	 typeDCohorte.TypeCohorte as 'Type de Cohorte',
	 CONCAT(pn.family_name,' ',IFNULL(pn.middle_name,''),' ', IFNULL(pn.given_name,'')) AS Nom,
	 CASE WHEN p.gender='M' THEN 'Homme' WHEN p.gender='F' THEN 'Femme' ELSE NULL END AS Sexe,
	 DATE_FORMAT(p.birthdate, '%d/%m/%Y') AS "Date de naissance",
	 DATE_FORMAT(o.obs_datetime,'%d/%m/%Y') AS 'DateSession',
	 session_type.name as 'TypeSession',
	 session_name.name as 'Sess. Faite',
	 session_name.creator,
	 u.username AS 'Sess. Faite Par',
	 IFNULL(SessDemandee.Session,'') AS 'Sess. Demandee(s)',
	 IFNULL(SessDemandee.username,'') AS 'Sess. Demandee Par',
	 vt.name  AS 'TypeDeVisite'
 FROM obs o
 INNER JOIN encounter e ON o.encounter_id = e.encounter_id
 INNER JOIN visit v ON v.visit_id = e.visit_id
 INNER JOIN visit_type vt ON vt.visit_type_id = v.visit_type_id AND vt.retired IS FALSE
 INNER JOIN patient_identifier pi ON pi.patient_id = v.patient_id AND pi.voided IS FALSE
 INNER JOIN person p ON p.person_id = pi.patient_id AND p.voided IS FALSE
 LEFT JOIN (
     SELECT
	 person_id,
	 cv.concept_short_name as 'TypeCohorte'
	 FROM
	  person_attribute pa
	  INNER JOIN person_attribute_type pat ON pat.person_attribute_type_id = pa.person_attribute_type_id
	  AND pa.voided IS FALSE
	  AND pat.retired IS FALSE
	  INNER JOIN concept_view cv ON cv.concept_id = pa.value
	  AND cv.retired IS FALSE
	  WHERE  pat.name = 'Type de cohorte'
	) typeDCohorte ON typeDCohorte.person_id = pi.patient_id
 INNER JOIN person_name pn ON pn.person_id = pi.patient_id AND pn.voided IS FALSE
 INNER JOIN concept_name session_type ON session_type.concept_id = o.concept_id AND o.voided IS FALSE AND session_type.voided IS FALSE AND session_type.locale = 'fr' AND session_type.name IN ("SessionInitiation","SessionSuivi","SessionSET","SessionET","SessionBebeExpose","SessionAnnonce","SessionAutre","SessionScreening")
 INNER JOIN concept_name session_name ON session_name.concept_id = o.value_coded AND o.voided IS FALSE AND session_name.voided IS FALSE AND session_name.locale = 'fr' AND session_name.concept_name_type = "SHORT"
 INNER JOIN users u ON u.user_id = o.creator
 LEFT JOIN 
     ( SELECT 
	      SessDemandee1.patient_id,
	      SessDemandee1.visit_id,
		  SessDemandee1.Session,
		  SessDemandee1.creator,
		  u1.username
	  FROM
     (
	 SELECT 
	  v.patient_id,
	  v.visit_id,
	  GROUP_CONCAT(DISTINCT (requestSessName.name)) AS 'Session',
	  osbSessRequested.creator
		 FROM obs osbSessRequested
		 INNER JOIN encounter e ON osbSessRequested.encounter_id = e.encounter_id
		 INNER JOIN visit v ON v.visit_id = e.visit_id
		 INNER JOIN concept_name requestSessName ON requestSessName.concept_id = osbSessRequested.value_coded AND osbSessRequested.voided IS FALSE AND requestSessName.voided IS FALSE AND requestSessName.concept_name_type = "SHORT"
		 INNER JOIN concept_name requestSessType ON requestSessType.concept_id = osbSessRequested.concept_id AND osbSessRequested.voided IS FALSE AND requestSessType.voided IS FALSE
		 
		  WHERE requestSessType.name IN ('SessionPSEDemande')
		  AND requestSessType.locale = 'fr'
		  GROUP BY patient_id,visit_id ) as SessDemandee1
      INNER JOIN users u1 ON u1.user_id = SessDemandee1.creator		  
	  )  AS SessDemandee ON  v.visit_id = SessDemandee.visit_id
 
     WHERE DATE(o.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
	 ORDER BY o.encounter_id ASC;
