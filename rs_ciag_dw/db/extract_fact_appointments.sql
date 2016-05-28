INSERT INTO dw_fact_appointments

(
	total,
	cancel_total,
	expected_duration_in_minutes,
	actual_appointment_duration_in_minutes,
	total_workflow_duration_in_minutes,
	dw_dim_appointment_type_id, ----
	dw_dim_appointment_shifts_id, ----
	dw_dim_appointment_occupational_types_id,
	dw_dim_appointment_statuses_id,
	dw_dim_users_id_,
	dw_dim_employees_id,
	dim_company_id,
	dw_dim_appointment_cancelers_id,
	dw_dim_time_id,
	dw_dim_contract_types_id
)

SELECT 

	SUM(1) total,

	COUNT(appointment_cancels.id) AS cancel_total,

	AVG(
		DATE_PART('minute',appointments.ends_at - appointments.starts_at)
	) AS expected_duration_in_minutes,

	AVG(
		COALESCE(
			DATE_PART('minute',occupational_treatments.out_at - occupational_treatments.in_at) * SIGN(DATE_PART('minute',occupational_treatments.out_at - occupational_treatments.in_at))
		,0)
	) AS actual_appointment_duration_in_minutes,

	AVG(
		COALESCE(
			DATE_PART('minute',treatments.out_at - treatments.in_at) * SIGN(DATE_PART('minute',treatments.out_at - treatments.in_at))
		,0)
	) AS total_workflow_duration_in_minutes,

	----
	(CASE WHEN appointments.appointment_type = 'normal' THEN 1
	ELSE 2
	END) AS dw_dim_appointment_type_id,
	

	----
	appointments.shift_id AS dw_dim_appointment_shifts_id,


	----
	(SELECT dw_dim_appointment_occupational_types_id FROM dw_dim_appointment_occupational_types
	WHERE appointments.occupational_reason = slug
	LIMIT 1
	) AS dw_dim_appointment_occupational_types_id,


	----
	(CASE
	WHEN (appointments.employee_company_id IS NOT NULL OR appointments.company_id IS NOT NULL) AND appointments.id IN (SELECT appointment_id FROM treatments) THEN 1
	WHEN (appointments.employee_company_id IS NOT NULL OR appointments.company_id IS NOT NULL) AND appointments.id NOT IN (SELECT appointment_id FROM treatments) THEN 3
	ELSE 2
	END) AS dw_dim_appointment_statuses_id,


	---
	COALESCE(appointments.updated_by_id,appointments.created_by_id) AS dw_dim_users_id_,

	
	----
	employee_companies.employee_id AS dw_dim_employees_id,


	-----
	COALESCE(employee_companies.company_id,companies.id) AS dim_company_id,


	----
	appointment_cancels.created_by_id AS dw_dim_appointment_cancelers_id,


	----
	get_dw_dim_time_id(appointments.starts_at) AS dw_dim_time_id,


	----
	(
		SELECT dw_dim_contract_types_id FROM dw_dim_contract_types
		WHERE description_slug = employee_companies.contract_type
		LIMIT 1
	) AS dw_dim_contract_types_id

FROM appointments
LEFT OUTER JOIN employee_companies ON appointments.employee_company_id = employee_companies.id 
LEFT OUTER JOIN companies ON appointments.company_id = companies.id
LEFT OUTER JOIN appointment_cancels ON appointments.id = appointment_cancels.appointment_id
LEFT OUTER JOIN treatments ON appointments.id = treatments.appointment_id
LEFT OUTER JOIN occupational_treatments ON occupational_treatments.treatment_id = treatments.id

WHERE appointments.employee_company_id IS NOT NULL OR appointments.company_id IS NOT NULL

GROUP BY 

	----
	(CASE WHEN appointments.appointment_type = 'normal' THEN 1
	ELSE 2
	END),
	

	----
	appointments.shift_id,


	----
	(SELECT dw_dim_appointment_occupational_types_id FROM dw_dim_appointment_occupational_types
	WHERE appointments.occupational_reason = slug
	LIMIT 1
	),


	----
	(CASE
	WHEN (appointments.employee_company_id IS NOT NULL OR appointments.company_id IS NOT NULL) AND appointments.id IN (SELECT appointment_id FROM treatments) THEN 1
	WHEN (appointments.employee_company_id IS NOT NULL OR appointments.company_id IS NOT NULL) AND appointments.id NOT IN (SELECT appointment_id FROM treatments) THEN 3
	ELSE 2
	END),


	---
	COALESCE(appointments.updated_by_id,appointments.created_by_id),

	
	----
	employee_companies.employee_id,


	-----
	COALESCE(employee_companies.company_id,companies.id),


	----
	appointment_cancels.created_by_id,


	----
	get_dw_dim_time_id(appointments.starts_at),


	----
	(
		SELECT dw_dim_contract_types_id FROM dw_dim_contract_types
		WHERE description_slug = employee_companies.contract_type
		LIMIT 1
	);
