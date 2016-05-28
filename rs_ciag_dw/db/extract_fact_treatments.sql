INSERT INTO dw_fact_treatments 
(
	treatment_id, -------
	total_waiting_room_duration_in_minutes, -------
	total_screening_duration_in_minutes, -------
	total_doctor_treatment_duration_in_minutes, -------
	total_nursing_treatment_duration_in_minutes, -------
	total_complementary_exam_duration_in_minutes, -------
	total_complete_treatment_duration_in_minutes, -------
	total_rest_duration_in_minutes, -------
	dw_dim_time_id, -------
	dw_dim_complementary_exams_status_id, -------
	dw_dim_employees_id, -------
	dw_dim_treatment_types_id, -------
	dim_company_id, -------
	dim_cid10s_id, -------
	dw_dim_emergency_infos_id, -------
	dw_dim_accident_investigations_id, ------- 
	dw_dim_screening_id, ------- 
	dw_occupational_treatments_id, ------- 
	dw_dim_clinical_treatments_id, ------- 
	dw_dim_tags_id, ------- 
	dw_dim_accident_treatments_id, ------- 
	dw_dim_users_id, ------- 
	dw_dim_contract_types_id, ------- 
	dw_dim_age_group_id ------- 
)

-- occupational_treatments
-- clinical_treatments
-- clinical_emergency_treatments
-- external_medical_certificates
-- accident_treatments
-- nursing
-- realizacao_de_exames (às vezes o próprio treatment)

SELECT DISTINCT
	
	---
	treatments.id AS treatment_id,

	---
	DATE_PART('minute',COALESCE(occupational_treatments.in_at,clinical_treatments.in_at,clinical_emergency_treatments.in_at,external_medical_certificates.created_at,accident_treatments.in_at,nursings.in_at,audiometries.in_at,spirometries.in_at,visiotests.in_at,treatments.in_at) - treatments.in_at) 
	-- HACK para remover sinal negativo
	* SIGN(DATE_PART('minute',COALESCE(occupational_treatments.in_at,clinical_treatments.in_at,clinical_emergency_treatments.in_at,external_medical_certificates.created_at,accident_treatments.in_at,nursings.in_at,audiometries.in_at,spirometries.in_at,visiotests.in_at,treatments.in_at) - treatments.in_at))
	AS total_waiting_room_duration_in_minutes,

	---
	(CASE WHEN screenings.id IS NOT NULL 
	THEN
		DATE_PART('minute', screenings.out_at - screenings.in_at) 
	ELSE
		0 
	END) AS total_screening_duration_in_minutes,

	---
	COALESCE(DATE_PART('minute',
		COALESCE(occupational_treatments.out_at,clinical_treatments.out_at,clinical_emergency_treatments.out_at,external_medical_certificates.created_at,accident_treatments.out_at,nursings.out_at,audiometries.out_at,spirometries.out_at,visiotests.out_at,treatments.out_at) 
		- COALESCE(occupational_treatments.in_at,clinical_treatments.in_at,clinical_emergency_treatments.in_at,external_medical_certificates.created_at,accident_treatments.in_at,nursings.in_at,audiometries.in_at,spirometries.in_at,visiotests.in_at,treatments.in_at)
	),0)
	-- HACK para remover sinal negativo
	* COALESCE(SIGN(
		DATE_PART('minute',
			COALESCE(occupational_treatments.out_at,clinical_treatments.out_at,clinical_emergency_treatments.out_at,external_medical_certificates.created_at,accident_treatments.out_at,nursings.out_at,audiometries.out_at,spirometries.out_at,visiotests.out_at,treatments.out_at) 
			- COALESCE(occupational_treatments.in_at,clinical_treatments.in_at,clinical_emergency_treatments.in_at,external_medical_certificates.created_at,accident_treatments.in_at,nursings.in_at,audiometries.in_at,spirometries.in_at,visiotests.in_at,treatments.in_at)
		)
	),0)
	AS total_doctor_treatment_duration_in_minutes,

	---
	(CASE WHEN nursings.id IS NOT NULL 
	THEN
		DATE_PART('minute',nursings.out_at - nursings.in_at)
	ELSE
		0
	END) AS total_nursing_treatment_duration_in_minutes,

	---
	(
		(CASE WHEN audiometries.id IS NOT NULL
		THEN DATE_PART('minute',audiometries.out_at - audiometries.in_at)
		ELSE 0
		END) 
		+ 
		(CASE WHEN spirometries.id IS NOT NULL
		THEN DATE_PART('minute',spirometries.out_at - spirometries.in_at)
		ELSE 0
		END) 
		+
		(CASE WHEN visiotests.id IS NOT NULL
		THEN DATE_PART('minute',visiotests.out_at - visiotests.in_at)
		ELSE 0
		END)
	) AS total_complementary_exam_duration_in_minutes,


	---
	COALESCE(
		DATE_PART('minute',treatments.out_at - treatments.in_at)
		* SIGN(DATE_PART('minute',treatments.out_at - treatments.in_at)),
		0)
	AS total_complete_treatment_duration_in_minutes,


	---
	(CASE WHEN treatment_rests.id IS NOT NULL 
	THEN
		DATE_PART('minute',treatment_rests.end_at - treatment_rests.start_at)
		* SIGN(DATE_PART('minute',treatment_rests.end_at - treatment_rests.start_at))
	ELSE 
		0
	END) AS total_rest_duration_in_minutes,

	---
	get_dw_dim_time_id(treatments.in_at) AS dw_dim_time_id,


	--- ver tabela no left outer join abaixo
	dw_dim_complementary_exams_status_t.id AS dw_dim_complementary_exams_status_id,


	--- 
	employee_companies.employee_id AS dw_dim_employees_id,


	--- 
	(CASE
	WHEN occupational_treatments.id IS NOT NULL THEN 1 
	WHEN clinical_treatments.id IS NOT NULL THEN 2 
	WHEN clinical_emergency_treatments.id IS NOT NULL THEN 3 
	WHEN external_medical_certificates.id IS NOT NULL THEN 4
	WHEN accident_treatments.id IS NOT NULL THEN 5
	WHEN nursings.id IS NOT NULL THEN 6 
	ELSE 7 -- realização de exames
	END) AS dw_dim_treatment_types_id,


	---
	employee_companies.company_id AS dim_company_id,

 
	---
	treatment_cid10s.cid10_id AS dim_cid10s_id,


	---
	get_dw_dim_emergency_infos_id(emergency_infos.id) AS dw_dim_emergency_infos_id,

	---
	get_dw_dim_accident_investigations_id(accident_investigations.id) AS dw_dim_accident_investigations_id,


	---
	get_dw_dim_screening_id(screenings.id) AS dw_dim_screening_id,


	---
	get_dw_occupational_treatments_id(
		dw_dim_occupational_treatments_temp.type,
		dw_dim_occupational_treatments_temp.is_able,
		dw_dim_occupational_treatments_temp.osteomuscular_complaint,
		dw_dim_occupational_treatments_temp.osteomuscular_complaint_side
	) AS dw_occupational_treatments_id,
	

	---
	get_dw_dim_clinical_treatments_id(clinical_treatments.id) AS dw_dim_clinical_treatments_id,


	---
	tags_temp.id AS dw_dim_tags_id,


	---
	get_dw_dim_accident_treatments_id(
		dw_dim_accident_treatments_temp.origin_of_injury,
		dw_dim_accident_treatments_temp.body_matrix,
		dw_dim_accident_treatments_temp.period_away,
		dw_dim_accident_treatments_temp.away_type
	) AS dw_dim_accident_treatments_id,


	---
	users.id AS dw_dim_users_id,


	---
	(CASE 
	WHEN employee_companies.contract_type = 'contratado' THEN 1
	WHEN employee_companies.contract_type = 'terceiro' THEN 2
	ELSE 3
	END) AS dw_dim_contract_types_id,


	---
	(CASE WHEN get_dw_dim_age_group_id(employees.birth_date,date(treatments.created_at)) IS NULL 
	THEN (SELECT MAX(dw_dim_age_groups.dw_dim_age_group_id) FROM dw_dim_age_groups)
	ELSE get_dw_dim_age_group_id(employees.birth_date,date(treatments.created_at))
	END) AS dw_dim_age_group_id

FROM treatments 
INNER JOIN employee_companies ON employee_companies.id = treatments.employee_company_id
INNER JOIN employees ON employees.id = employee_companies.employee_id 
LEFT OUTER JOIN audiometries ON treatments.id = audiometries.treatment_id
LEFT OUTER JOIN spirometries ON treatments.id = spirometries.treatment_id
LEFT OUTER JOIN visiotests ON treatments.id = visiotests.treatment_id
LEFT OUTER JOIN screenings ON treatments.id = screenings.treatment_id 
LEFT OUTER JOIN occupational_treatments ON treatments.id = occupational_treatments.treatment_id
LEFT OUTER JOIN clinical_treatments ON treatments.id = clinical_treatments.treatment_id
LEFT OUTER JOIN clinical_emergency_treatments ON treatments.id = clinical_emergency_treatments.treatment_id
LEFT OUTER JOIN external_medical_certificates ON treatments.id = external_medical_certificates.treatment_id
LEFT OUTER JOIN accident_treatments ON treatments.id = accident_treatments.treatment_id 
LEFT OUTER JOIN nursings ON treatments.id = nursings.treatment_id 
LEFT OUTER JOIN nursing_doctors ON treatments.id = nursing_doctors.treatment_id
LEFT OUTER JOIN treatment_rests ON treatments.id = treatment_rests.treatment_id
LEFT OUTER JOIN treatment_cid10s ON 
	occupational_treatments.id = treatment_cid10s.occupational_treatment_id
	OR clinical_treatments.id = treatment_cid10s.clinical_treatment_id
	OR clinical_emergency_treatments.id = treatment_cid10s.clinical_emergency_treatment_id 
	OR accident_treatments.id = treatment_cid10s.accident_treatment_id 
	OR nursing_doctors.id = treatment_cid10s.nursing_doctor_id
LEFT OUTER JOIN emergency_infos ON treatments.id = emergency_infos.treatment_id
LEFT OUTER JOIN accident_investigations ON treatments.id = accident_investigations.treatment_id

-- para fazer tracking dos status dos exames
LEFT OUTER JOIN 
(
	SELECT 
		treatments.id AS treatment_id, 
		(CASE WHEN audiometries.status = 'normal' 
			THEN 2 
			ELSE 1
		END) AS id 
	FROM treatments 
	INNER JOIN audiometries ON treatments.id = audiometries.treatment_id

	UNION

	SELECT 
		treatments.id AS treatment_id, 
		(CASE WHEN spirometries.status = 'normal' 
			THEN 6 
			ELSE 5
		END) AS id 
	FROM treatments 
	INNER JOIN spirometries ON treatments.id = spirometries.treatment_id

	UNION 

	SELECT 
		treatments.id AS treatment_id, 
		(CASE WHEN visiotests.status = 'normal' 
			THEN 4
			ELSE 3
		END) AS id 
	FROM treatments 
	INNER JOIN visiotests ON treatments.id = visiotests.treatment_id

	UNION 

	SELECT
		treatments.id AS treatment_id, 
		7 AS id
	FROM treatments
	WHERE treatments.id NOT IN 
	(
		SELECT treatment_id FROM audiometries
		UNION SELECT treatment_id FROM spirometries
		UNION SELECT treatment_id FROM visiotests
	)

) dw_dim_complementary_exams_status_t ON treatments.id = dw_dim_complementary_exams_status_t.treatment_id 


-- queixas osteomusculares
LEFT OUTER JOIN dw_dim_occupational_treatments_temp ON dw_dim_occupational_treatments_temp.occupational_treatment_id = occupational_treatments.id

LEFT OUTER JOIN 
(

	-- ENVIADO PARA INSS POR UM ATESTADO
	SELECT 1 AS id, treatment_id FROM external_medical_certificates WHERE send_to_inss IS TRUE
	
	-- TAG ENVIADO PARA INSS EM UM ATENDIMENTO
	UNION SELECT 2 AS id, treatment_id FROM occupational_treatments WHERE send_to_inss IS TRUE
	UNION SELECT 2 AS id, treatment_id FROM clinical_treatments WHERE send_to_inss IS TRUE
	UNION SELECT 2 AS id, treatment_id FROM clinical_emergency_treatments WHERE send_to_inss IS TRUE
	UNION SELECT 2 AS id, treatment_id FROM accident_treatments WHERE send_to_inss IS TRUE
	UNION SELECT 2 AS id, treatment_id FROM nursing_doctors WHERE send_to_inss IS TRUE
	
	--- TAG ENVIADO p/ REPOUSO COM RETORNO AO MÉDICO
	UNION SELECT 3 AS id, treatment_id FROM occupational_treatments 			WHERE treatment_id IN (SELECT treatment_id FROM treatment_rests WHERE treatment_id = occupational_treatments.treatment_id AND return_to_doctor IS TRUE)
	UNION SELECT 3 AS id, treatment_id FROM clinical_treatments 					WHERE treatment_id IN (SELECT treatment_id FROM treatment_rests WHERE treatment_id = clinical_treatments.treatment_id AND return_to_doctor IS TRUE)
	UNION SELECT 3 AS id, treatment_id FROM clinical_emergency_treatments WHERE treatment_id IN (SELECT treatment_id FROM treatment_rests WHERE treatment_id = clinical_emergency_treatments.treatment_id AND return_to_doctor IS TRUE)
	UNION SELECT 3 AS id, treatment_id FROM accident_treatments 					WHERE treatment_id IN (SELECT treatment_id FROM treatment_rests WHERE treatment_id = accident_treatments.treatment_id AND return_to_doctor IS TRUE)
	UNION SELECT 3 AS id, treatment_id FROM nursing_doctors 							WHERE treatment_id IN (SELECT treatment_id FROM treatment_rests WHERE treatment_id = nursing_doctors.treatment_id AND return_to_doctor IS TRUE)

	-- TAG ENVIADO p/ REPOUSO SEM RETORNO AO MÉDICO
	UNION SELECT 4 AS id, treatment_id FROM occupational_treatments 			WHERE treatment_id IN (SELECT treatment_id FROM treatment_rests WHERE treatment_id = occupational_treatments.treatment_id AND return_to_doctor IS FALSE)
	UNION SELECT 4 AS id, treatment_id FROM clinical_treatments 					WHERE treatment_id IN (SELECT treatment_id FROM treatment_rests WHERE treatment_id = clinical_treatments.treatment_id AND return_to_doctor IS FALSE)
	UNION SELECT 4 AS id, treatment_id FROM clinical_emergency_treatments WHERE treatment_id IN (SELECT treatment_id FROM treatment_rests WHERE treatment_id = clinical_emergency_treatments.treatment_id AND return_to_doctor IS FALSE)
	UNION SELECT 4 AS id, treatment_id FROM accident_treatments 					WHERE treatment_id IN (SELECT treatment_id FROM treatment_rests WHERE treatment_id = accident_treatments.treatment_id AND return_to_doctor IS FALSE)
	UNION SELECT 4 AS id, treatment_id FROM nursing_doctors 							WHERE treatment_id IN (SELECT treatment_id FROM treatment_rests WHERE treatment_id = nursing_doctors.treatment_id AND return_to_doctor IS FALSE)

	-- TAG REALIZAÇÃO DE EXAMES
	-- ELETROCARDIOGRAMA
	-- ELETROENCEFALOGRAMA
	-- EXAME LABORATORIAL
	UNION SELECT tag_id AS id, treatment_id FROM dw_other_treatment_exams_tags_temp

) AS tags_temp ON treatments.id = tags_temp.treatment_id

LEFT OUTER JOIN dw_dim_accident_treatments_temp ON dw_dim_accident_treatments_temp.accident_treatment_id = accident_treatments.id

LEFT OUTER JOIN users ON 
	COALESCE(occupational_treatments.created_by_id,clinical_treatments.created_by_id,clinical_emergency_treatments.created_by_id,accident_treatments.created_by_id,nursing_doctors.created_by_id,treatments.created_by_id) = users.id




;