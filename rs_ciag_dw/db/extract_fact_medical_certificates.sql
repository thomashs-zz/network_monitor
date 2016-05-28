
INSERT INTO dw_fact_medical_certificates
(
	total,
	dw_dim_medical_certificate_types_id,
	dw_dim_doctors_id,
	dw_dim_medical_certificate_time_frames_id,
	dw_dim_employees_id,
	dw_dim_time_id,
	dim_cid10s_id,
	dim_company_id,
	dw_dim_users_id
)

SELECT 
	
	---
	SUM(1) AS total,

	---
	(CASE WHEN medical_certificates.treatment_id IS NULL THEN 7
		ELSE (
			SELECT dw_dim_medical_certificate_types_id FROM dw_dim_medical_certificate_types
			WHERE subtype_slug = treatments.treatment_type
			LIMIT 1
		)
	END) AS dw_dim_medical_certificate_types_id,


	---
	(CASE WHEN medical_certificates.external_doctor_crm IS NULL 
	THEN 
		(SELECT dw_dim_doctors_id FROM dw_dim_doctors
		WHERE crm = generate_internal_crm(medical_certificates.created_by_id)
		LIMIT 1)
	ELSE
		(SELECT dw_dim_doctors_id FROM dw_dim_doctors
		WHERE 
			name = medical_certificates.external_doctor_name 
			AND crm = medical_certificates.external_doctor_crm
		LIMIT 1)
	END) AS dw_dim_doctors_id,


	---
	(
		SELECT dw_dim_medical_certificate_time_frames_id FROM dw_dim_medical_certificate_time_frames
		WHERE duration_in_days = (DATE(end_at) - DATE(start_at) + 1)
		LIMIT 1
	) AS dw_dim_medical_certificate_time_frames_id,


	---
	employee_companies.employee_id AS dw_dim_employees_id,


	--- 
	get_dw_dim_time_id(medical_certificates.start_at) AS dw_dim_time_id,


	---
	medical_certificates.cid10_id AS dim_cid10s_id,

	---
	employee_companies.company_id AS dim_company_id,

	---
	medical_certificates.created_by_id AS dw_dim_users_id

FROM medical_certificates
INNER JOIN employee_companies ON medical_certificates.employee_company_id = employee_companies.id
LEFT OUTER JOIN treatments ON medical_certificates.treatment_id = treatments.id
GROUP BY 

	
	(CASE WHEN medical_certificates.treatment_id IS NULL THEN 7
		ELSE (
			SELECT dw_dim_medical_certificate_types_id FROM dw_dim_medical_certificate_types
			WHERE subtype_slug = treatments.treatment_type
			LIMIT 1
		)
	END),


	(CASE WHEN medical_certificates.external_doctor_crm IS NULL 
	THEN 
		(SELECT dw_dim_doctors_id FROM dw_dim_doctors
		WHERE crm = generate_internal_crm(medical_certificates.created_by_id)
		LIMIT 1)
	ELSE
		(SELECT dw_dim_doctors_id FROM dw_dim_doctors
		WHERE 
			name = medical_certificates.external_doctor_name 
			AND crm = medical_certificates.external_doctor_crm
		LIMIT 1)
	END),


	(
		SELECT dw_dim_medical_certificate_time_frames_id FROM dw_dim_medical_certificate_time_frames
		WHERE duration_in_days = (DATE(end_at) - DATE(start_at) + 1)
		LIMIT 1
	),

	employee_companies.employee_id,

	get_dw_dim_time_id(medical_certificates.start_at),

	medical_certificates.cid10_id,

	employee_companies.company_id,

	medical_certificates.created_by_id
