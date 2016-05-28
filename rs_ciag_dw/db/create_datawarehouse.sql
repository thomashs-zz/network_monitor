--
-- TREATMENTS DW
-- 

-- COMPANIES
DROP TABLE IF EXISTS dw_dim_companies CASCADE;
CREATE TABLE dw_dim_companies(
	dim_company_id serial NOT NULL,
	name character varying,
	cnpj varchar,
	company_type varchar,
	CONSTRAINT dw_dim_companies_pkey PRIMARY KEY (dim_company_id)
);

INSERT INTO dw_dim_companies (dim_company_id,name,cnpj,company_type)  
SELECT 
	id AS dw_dim_company_id,
	name,
	cnpj,
	company_type
FROM companies;


-- CID10s
DROP TABLE IF EXISTS dw_dim_cid10s CASCADE;
CREATE TABLE dw_dim_cid10s(
	dim_cid10s_id serial NOT NULL,
	description varchar,
	group_description varchar,
	code varchar,
	CONSTRAINT dw_dim_cid10s_pkey PRIMARY KEY (dim_cid10s_id)
);

INSERT INTO dw_dim_cid10s (dim_cid10s_id,description,group_description,code) 
SELECT
	id AS dim_cid10s_id,
	description,
	cid10s.group AS group_description,
	code 
FROM cid10s;


-- COMPLEMENTARY EXAMS STATUSES
DROP TABLE IF EXISTS dw_dim_complementary_exams_statuses CASCADE;
CREATE TABLE dw_dim_complementary_exams_statuses(
	dw_dim_complementary_exams_status_id serial NOT NULL,
	status varchar,
	exam_name varchar,
	CONSTRAINT dw_dim_complementary_exams_statuses_pkey PRIMARY KEY (dw_dim_complementary_exams_status_id)
);
INSERT INTO dw_dim_complementary_exams_statuses (dw_dim_complementary_exams_status_id,status,exam_name) VALUES 
(1,'Audiometria','Alterado'), 
(2,'Audiometria','Normal'),
(3,'Visiotest','Alterado'),
(4,'Visiotest','Normal'),
(5,'Espirometria','Alterado'),
(6,'Espirometria','Normal'),
(7,'-','Não realizou');


-- TREATMENT TYPES
DROP TABLE IF EXISTS dw_dim_treatment_types CASCADE;
CREATE TABLE dw_dim_treatment_types(
	dw_dim_treatment_types_id serial NOT NULL,
	description varchar,
	slug varchar,
	CONSTRAINT dw_dim_treatment_types_pkey PRIMARY KEY (dw_dim_treatment_types_id)
);
INSERT INTO dw_dim_treatment_types (dw_dim_treatment_types_id,description,slug) VALUES 
(1,'Atendimento Ocupacional','occupational_treatment'),
(2,'Atendimento Clínico','clinical_treatment'),
(3,'Emergência Clínica','clinical_emergency_treatment'),
(4,'Atestado Médico','external_medical_certificate'),
(5,'Ocorrência','accident_treatment'),
(6,'Enfermagem','nursing'),
(7,'Realização de Exames','realizacao_de_exames');


-- EMPLOYEES
DROP TABLE IF EXISTS dw_dim_employees CASCADE;
CREATE TABLE dw_dim_employees(
	dw_dim_employees_id serial NOT NULL,
	name varchar,
	cpf varchar,
	birth_date date,
	gender varchar,
	CONSTRAINT dw_dim_employees_pkey PRIMARY KEY (dw_dim_employees_id)
);

INSERT INTO dw_dim_employees (dw_dim_employees_id,name,cpf,birth_date,gender) 
SELECT 
	id AS dw_dim_employees_id,
	name,
	cpf,
	birth_date,
	gender
FROM employees;

-- HOLIDAYS HELPER TABLE
DROP TABLE IF EXISTS dw_holidays_helper;
CREATE TABLE dw_holidays_helper( the_date date );

INSERT INTO dw_holidays_helper (the_date) VALUES 
-- 2015
('2015-01-01'),
('2015-02-17'),
('2015-04-03'),
('2015-04-05'),
('2015-04-21'),
('2015-05-01'),
('2015-06-04'),
('2015-09-07'),
('2015-10-12'),
('2015-11-02'),
('2015-11-15'),
('2015-12-25'),
-- 2016
('2016-01-01'),
('2016-02-09'),
('2016-03-25'),
('2016-03-27'),
('2016-04-21'),
('2016-05-01'),
('2016-05-26'),
('2016-09-07'),
('2016-10-12'),
('2016-11-02'),
('2016-11-15'),
('2016-12-25');

-- TIME
DROP TABLE IF EXISTS dw_dim_time CASCADE;
CREATE TABLE dw_dim_time(
	dw_dim_time_id timestamp NOT NULL,
	year smallint,
	month smallint,
	day smallint,
	hour smallint,
	minute smallint,
	day_of_week smallint,
	week_of_the_month smallint,
	week_of_the_year smallint,
	semester_of_year smallint,
	is_holiday boolean,
	CONSTRAINT dw_dim_time_pkey PRIMARY KEY (dw_dim_time_id)
);

INSERT INTO dw_dim_time (dw_dim_time_id,year,month,day,hour,minute,day_of_week,week_of_the_month,week_of_the_year,semester_of_year,is_holiday) 
SELECT DISTINCT
	(dt::timestamp without time zone) AS dw_dim_time_id,
	EXTRACT('year' FROM dt) AS year,
	EXTRACT('month' FROM dt) AS month,
	EXTRACT('day' FROM dt) AS day,
	EXTRACT('hour' FROM dt) AS hour,
	EXTRACT('minute' FROM dt) AS minute,
	EXTRACT('dow' FROM dt) AS day_of_week,
	CAST(to_char(dt,'W') AS integer) AS week_of_the_month,
	EXTRACT('week' FROM dt) AS week_of_the_year,
	EXTRACT('quarter' FROM dt) AS semester_of_year,
	((SELECT COUNT(*) FROM dw_holidays_helper WHERE DATE(dt) = dw_holidays_helper.the_date) > 0) AS is_holiday
FROM
GENERATE_SERIES(
  (
  	CASE WHEN 
  	(SELECT DATE(MIN(start_at)) FROM medical_certificates) > 
  	(SELECT DATE(MIN(created_at)) FROM treatments)
  	THEN 
  	(SELECT DATE(MIN(created_at)) FROM treatments)
  	ELSE 
  	(SELECT DATE(MIN(start_at)) FROM medical_certificates)
  	END 
  ),
  (SELECT DATE(MAX(starts_at + '1 hour')) FROM appointments),
  '5 minutes'
) AS datetime_series(dt);

-- DROP HOLIDAYS
DROP TABLE IF EXISTS dw_holidays_helper;


-- EMERGENCY INFOS
DROP TABLE IF EXISTS dw_dim_emergency_infos CASCADE;
CREATE TABLE dw_dim_emergency_infos(
	dw_dim_emergency_infos_id serial NOT NULL,
	shift_leader varchar,
	accident_site varchar,
	was_transported bool,
	transport_responsible varchar,
	destiny varchar,
	CONSTRAINT dw_dim_emergency_infos_pkey PRIMARY KEY (dw_dim_emergency_infos_id)
);

INSERT INTO dw_dim_emergency_infos (shift_leader,accident_site,was_transported,transport_responsible,destiny) 
SELECT DISTINCT 
	shift_leader,
	COALESCE(accident_site_other,accident_site) AS accident_site,
	transported AS was_transported,
	transportation_responsible AS transport_responsible,
	COALESCE(destiny_other,destiny) AS destiny 
FROM emergency_infos;


-- ACCIDENT INVESTIGATIONS
DROP TABLE IF EXISTS public.dw_dim_accident_investigations CASCADE;
CREATE TABLE dw_dim_accident_investigations(
	dw_dim_accident_investigations_id serial NOT NULL,
	hours_till_accident smallint,
	company_contact_name varchar,
	was_using_epi bool,
	event_type varchar,
	accident_classification varchar,
	CONSTRAINT dw_dim_accident_investigations_pkey PRIMARY KEY (dw_dim_accident_investigations_id)
);

INSERT INTO dw_dim_accident_investigations (hours_till_accident,company_contact_name,was_using_epi,event_type,accident_classification) 
SELECT 
	hours_till_accident,
	(SELECT name FROM company_contacts WHERE company_contacts.id = accident_investigations.company_contact_id LIMIT 1) AS company_contact_name,
	using_equipment AS was_using_epi,
	event_type,
	accident_classification
FROM accident_investigations;


-- SCREENING
CREATE OR REPLACE function high_blood_pressure(pa_sistolica integer, pa_diastolica integer)
  RETURNS varchar AS 
$func$
BEGIN
  RETURN CASE WHEN 
  	(pa_sistolica > 120 AND pa_diastolica > 80)
  THEN 'SIM' ELSE 'NÃO' END;
END;
$func$ LANGUAGE plpgsql;

DROP TABLE IF EXISTS dw_dim_screening CASCADE;
CREATE TABLE dw_dim_screening(
	dw_dim_screening_id serial NOT NULL,
	manchester_level smallint,
	high_blood_pressure varchar,
	CONSTRAINT dw_dim_screening_id PRIMARY KEY (dw_dim_screening_id)
);

INSERT INTO dw_dim_screening (manchester_level,high_blood_pressure) 
SELECT DISTINCT
	screening_level AS manchester_level,
	high_blood_pressure(pa_sistolica,pa_diastolica) AS high_blood_pressure
FROM screenings;


-- OCCUPATIONAL TREATMENTS
DROP TABLE IF EXISTS dw_dim_occupational_treatments CASCADE;
CREATE TABLE dw_dim_occupational_treatments(
	dw_occupational_treatments_id serial NOT NULL,
	type varchar,
	is_able varchar,
	osteomuscular_complaint varchar,
	osteomuscular_complaint_side varchar,
	CONSTRAINT dw_occupational_treatments_pkey PRIMARY KEY (dw_occupational_treatments_id)
);

INSERT INTO dw_dim_occupational_treatments (type,is_able,osteomuscular_complaint,osteomuscular_complaint_side) 
SELECT DISTINCT type,is_able,osteomuscular_complaint,osteomuscular_complaint_side FROM dw_dim_occupational_treatments_temp;

-- APPOINTMENT TYPE
DROP TABLE IF EXISTS dw_dim_appointment_type CASCADE;
CREATE TABLE dw_dim_appointment_type(
	dw_dim_appointment_type_id serial NOT NULL,
	description varchar,
	CONSTRAINT dw_dim_appointment_type_pkey PRIMARY KEY (dw_dim_appointment_type_id)
);
INSERT INTO dw_dim_appointment_type (dw_dim_appointment_type_id,description) VALUES 
(1,'Normal'), 
(2,'Extra');


-- APPOINTMENT STATUS
DROP TABLE IF EXISTS dw_dim_appointment_statuses CASCADE;
CREATE TABLE dw_dim_appointment_statuses(
	dw_dim_appointment_statuses_id serial NOT NULL,
	description varchar,
	CONSTRAINT dw_dim_appointment_statuses_pkey PRIMARY KEY (dw_dim_appointment_statuses_id)
);
INSERT INTO dw_dim_appointment_statuses (dw_dim_appointment_statuses_id,description) VALUES 
(1,'Utilizada'),
(2,'Não utilizada'),
(3,'Falta');


-- TAGS
DROP TABLE IF EXISTS dw_dim_tags CASCADE;
CREATE TABLE dw_dim_tags(
	dw_dim_tags_id serial NOT NULL,
	description varchar,
	subcategory varchar,
	CONSTRAINT dw_dim_tags_pkey PRIMARY KEY (dw_dim_tags_id)
);

INSERT INTO dw_dim_tags (dw_dim_tags_id,description,subcategory) VALUES 
(1,'Enviado p/ INSS','Atestado'),
(2,'Enviado p/ INSS','Atendimento médico'),
(3,'Enviado p/ Repouso','COM retorno ao médico'),
(4,'Enviado p/ Repouso','SEM retorno ao médico'),
(5,'Realização de Exames','Eletrocardiograma'),
(6,'Realização de Exames','Eletroencefalograma'),
(7,'Realização de Exames','Exame Laboratorial');


-- APPOINTMENT OCCUPATIONAL TYPES
DROP TABLE IF EXISTS dw_dim_appointment_occupational_types CASCADE;
CREATE TABLE dw_dim_appointment_occupational_types(
	dw_dim_appointment_occupational_types_id serial NOT NULL,
	description varchar,
	slug varchar,
	CONSTRAINT dw_dim_appointment_occupational_types_pkey PRIMARY KEY (dw_dim_appointment_occupational_types_id)
);

INSERT INTO dw_dim_appointment_occupational_types (description,slug) VALUES 
('Admissional','admissional'),
('Periódico','periodico'),
('Demissional','demissional'),
('Retorno ao Trabalho','retorno_ao_trabalho'),
('Mudança de Função','mudanca_de_funcao'),
('Consulta Ocupacional','consulta_ocupacional');


-- CLINICAL TREATMENTS
DROP TABLE IF EXISTS dw_dim_clinical_treatments CASCADE;
CREATE TABLE dw_dim_clinical_treatments(
	dw_dim_clinical_treatments_id serial NOT NULL,
	is_relevant varchar,
	had_occupational_origin varchar,
	CONSTRAINT dw_dim_clinical_treatments_pkey PRIMARY KEY (dw_dim_clinical_treatments_id)
);
INSERT INTO dw_dim_clinical_treatments (is_relevant,had_occupational_origin) VALUES 
('SIM','SIM'),
('SIM','NÃO'),
('NÃO','NÃO'),
('NÃO','SIM');


-- USERS
DROP TABLE IF EXISTS dw_dim_users CASCADE;
CREATE TABLE dw_dim_users(
	dw_dim_users_id serial NOT NULL,
	user_type varchar,
	name varchar,
	CONSTRAINT dw_dim_users_pkey PRIMARY KEY (dw_dim_users_id)
);

INSERT INTO dw_dim_users (user_type,name) 
SELECT user_type,name FROM users;


-- ACCIDENT TREATMENTS
DROP TABLE IF EXISTS dw_dim_accident_treatments CASCADE;
CREATE TABLE dw_dim_accident_treatments(
	dw_dim_accident_treatments_id serial NOT NULL,
	origin_of_injury varchar,
	body_matrix varchar,
	period_away varchar,
	away_type varchar,
	CONSTRAINT dw_dim_accident_treatments_pkey PRIMARY KEY (dw_dim_accident_treatments_id)
);

INSERT INTO dw_dim_accident_treatments (origin_of_injury,body_matrix,period_away,away_type) 
SELECT DISTINCT origin_of_injury,body_matrix,period_away,away_type FROM dw_dim_accident_treatments_temp;


-- DOCTORS

CREATE OR REPLACE function generate_internal_crm(id integer)
  RETURNS varchar AS 
$func$
BEGIN
  RETURN 'INTERNO' || '-' || id;
END;
$func$ LANGUAGE plpgsql;

DROP TABLE IF EXISTS dw_dim_doctors CASCADE;
CREATE TABLE dw_dim_doctors(
	dw_dim_doctors_id serial NOT NULL,
	name varchar,
	crm varchar,
	doctor_type varchar,
	CONSTRAINT dw_dim_doctors_pkey PRIMARY KEY (dw_dim_doctors_id)
);

INSERT INTO dw_dim_doctors (crm,name,doctor_type) 
SELECT doctor_crm AS crm, doctor_name AS name, 'EXTERNO' AS doctor_type FROM external_medical_certificate_items
UNION 
	SELECT code AS crm, name, 'EXTERNO' AS doctor_type FROM crms
UNION 
	SELECT generate_internal_crm(id) AS crm, name, 'INTERNO' AS doctor_type FROM users 
	WHERE id IN 
		(
			SELECT DISTINCT COALESCE(clinical_treatments.created_by_id,occupational_treatments.created_by_id,clinical_emergency_treatments.created_by_id,accident_treatments.created_by_id,nursing_doctors.created_by_id)
		 	FROM treatment_medical_certificates 
		 	LEFT OUTER JOIN clinical_treatments ON treatment_medical_certificates.clinical_treatment_id = clinical_treatments.id
		 	LEFT OUTER JOIN occupational_treatments ON treatment_medical_certificates.occupational_treatment_id = occupational_treatments.id
		 	LEFT OUTER JOIN clinical_emergency_treatments ON treatment_medical_certificates.clinical_emergency_treatment_id = clinical_emergency_treatments.id
		 	LEFT OUTER JOIN accident_treatments ON treatment_medical_certificates.accident_treatment_id = accident_treatments.id
		 	LEFT OUTER JOIN nursing_doctors ON treatment_medical_certificates.nursing_doctor_id = nursing_doctors.id
		);


-- MEDICAL CERTIFICATES TIME FRAMES
DROP TABLE IF EXISTS dw_dim_medical_certificate_time_frames CASCADE;
CREATE TABLE dw_dim_medical_certificate_time_frames(
	dw_dim_medical_certificate_time_frames_id serial NOT NULL,
	description varchar,
	duration_in_days smallint,
	CONSTRAINT dw_dim_medical_certificate_time_frames_pkey PRIMARY KEY (dw_dim_medical_certificate_time_frames_id)
);

INSERT INTO dw_dim_medical_certificate_time_frames (description,duration_in_days) 
SELECT DISTINCT description, duration_in_days 
FROM
(
	SELECT (DATE(end_at) - DATE(start_at) + 1) || ' DIA' || (CASE WHEN (DATE(end_at) - DATE(start_at) + 1) > 1 THEN 'S' ELSE '' END) AS description, (DATE(end_at) - DATE(start_at) + 1) AS duration_in_days FROM external_medical_certificate_items
	UNION SELECT (DATE(out_at) - DATE(in_at) + 1) || ' DIA' || (CASE WHEN (DATE(out_at) - DATE(in_at) + 1) > 1 THEN 'S' ELSE '' END) AS description, (DATE(out_at) - DATE(in_at) + 1) AS duration_in_days  FROM treatment_medical_certificates
) AS tt 
ORDER BY duration_in_days;


-- MEDICAL CERTIFICATE TYPES
DROP TABLE IF EXISTS dw_dim_medical_certificate_types CASCADE;
CREATE TABLE dw_dim_medical_certificate_types(
	dw_dim_medical_certificate_types_id serial NOT NULL,
	description varchar,
	subtype varchar,
	subtype_slug varchar,
	CONSTRAINT dw_dim_medical_certificate_types_pkey PRIMARY KEY (dw_dim_medical_certificate_types_id)
);

INSERT INTO dw_dim_medical_certificate_types (dw_dim_medical_certificate_types_id,description,subtype,subtype_slug) VALUES 
(1,'INTERNO','Atendimento Ocupacional','occupational_treatment'),
(2,'INTERNO','Atendimento Clínico','clinical_treatment'),
(3,'INTERNO','Emergência Clínica','clinical_emergency_treatment'),
(4,'EXTERNO','Atestado Médico','external_medical_certificate'),
(5,'INTERNO','Ocorrência','accident_treatment'),
(6,'INTERNO','Enfermagem','nursing'),
(7,'EXTERNO','Externo','externo');


-- CONTRACT TYPES
DROP TABLE IF EXISTS dw_dim_contract_types CASCADE;
CREATE TABLE dw_dim_contract_types(
	dw_dim_contract_types_id serial NOT NULL,
	description varchar,
	description_slug varchar,
	CONSTRAINT dw_dim_contract_types_pkey PRIMARY KEY (dw_dim_contract_types_id)
);

INSERT INTO dw_dim_contract_types (dw_dim_contract_types_id,description,description_slug) VALUES
(1,'Contratado','contratado'),
(2,'Terceiro','terceiro'),
(3,'Em admissão','em_admissao');


-- APPOINTMENT CANCELERS
DROP TABLE IF EXISTS dw_dim_appointment_cancelers CASCADE;
CREATE TABLE dw_dim_appointment_cancelers(
	dw_dim_appointment_cancelers_id serial NOT NULL,
	user_name varchar,
	CONSTRAINT dw_dim_appointment_cancelers_pkey PRIMARY KEY (dw_dim_appointment_cancelers_id)
);

INSERT INTO dw_dim_appointment_cancelers (dw_dim_appointment_cancelers_id,user_name) 
SELECT DISTINCT 
id AS dw_dim_appointment_cancelers_id,name 
FROM users WHERE id IN (SELECT created_by_id FROM appointment_cancels);


-- APPOINTMENT SHIFTS
DROP TABLE IF EXISTS dw_dim_appointment_shifts CASCADE;
CREATE TABLE dw_dim_appointment_shifts(
	dw_dim_appointment_shifts_id serial NOT NULL,
	description varchar,
	CONSTRAINT dw_dim_appointment_shifts_pkey PRIMARY KEY (dw_dim_appointment_shifts_id)
);

INSERT INTO dw_dim_appointment_shifts (dw_dim_appointment_shifts_id,description) 
SELECT id as dw_dim_appointment_shifts_id, description 
FROM shifts;


-- AGE GROUP
DROP TABLE IF EXISTS dw_dim_age_groups CASCADE;
CREATE TABLE dw_dim_age_groups(
	dw_dim_age_group_id serial NOT NULL,
	description varchar,
	min smallint,
	max smallint,
	CONSTRAINT dw_dim_age_group_pkey PRIMARY KEY (dw_dim_age_group_id)
);
INSERT INTO dw_dim_age_groups (description,min,max) VALUES
('0 a 18 anos ',0,18),
('19 a 23 anos ',19,23),
('24 a 28 anos ',24,28),
('29 a 33 anos ',29,33),
('34 a 38 anos ',34,38),
('39 a 43 anos ',39,43),
('44 a 48 anos ',44,48),
('49 a 53 anos ',49,53),
('54 a 58 anos ',54,58),
('59 anos ou mais',59,1000);


-- CALCULATE AGE IN A DATE
-- age(the_date,birth_date)


-- FACT TREATMENTS
DROP TABLE IF EXISTS dw_fact_treatments CASCADE;
CREATE TABLE dw_fact_treatments(
	treatment_id integer NOT NULL,
	total_waiting_room_duration_in_minutes smallint NOT NULL,
	total_screening_duration_in_minutes smallint NOT NULL,
	total_doctor_treatment_duration_in_minutes smallint NOT NULL,
	total_nursing_treatment_duration_in_minutes smallint NOT NULL,
	total_complementary_exam_duration_in_minutes smallint NOT NULL,
	total_complete_treatment_duration_in_minutes smallint NOT NULL,
	total_rest_duration_in_minutes smallint NOT NULL,
	dw_dim_time_id timestamp NOT NULL,
	dw_dim_complementary_exams_status_id integer NOT NULL,
	dw_dim_employees_id integer NOT NULL,
	dw_dim_treatment_types_id integer NOT NULL,
	dim_company_id integer NOT NULL,
	dim_cid10s_id integer,
	dw_dim_emergency_infos_id integer,
	dw_dim_accident_investigations_id integer,
	dw_dim_screening_id integer,
	dw_occupational_treatments_id integer,
	dw_dim_clinical_treatments_id integer,
	dw_dim_tags_id integer,
	dw_dim_accident_treatments_id integer,
	dw_dim_users_id integer NOT NULL,
	dw_dim_contract_types_id integer,
	dw_dim_age_group_id integer NOT NULL
);

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_complementary_exams_statuses_fk CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_complementary_exams_statuses_fk FOREIGN KEY (dw_dim_complementary_exams_status_id)
REFERENCES public.dw_dim_complementary_exams_statuses (dw_dim_complementary_exams_status_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_time_fk CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_time_fk FOREIGN KEY (dw_dim_time_id)
REFERENCES public.dw_dim_time (dw_dim_time_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_employees_fk CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_employees_fk FOREIGN KEY (dw_dim_employees_id)
REFERENCES public.dw_dim_employees (dw_dim_employees_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_treatment_types_fk CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_treatment_types_fk FOREIGN KEY (dw_dim_treatment_types_id)
REFERENCES public.dw_dim_treatment_types (dw_dim_treatment_types_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_companies_fk CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_companies_fk FOREIGN KEY (dim_company_id)
REFERENCES public.dw_dim_companies (dim_company_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_cid10s CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_cid10s FOREIGN KEY (dim_cid10s_id)
REFERENCES public.dw_dim_cid10s (dim_cid10s_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_emergency_infos CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_emergency_infos FOREIGN KEY (dw_dim_emergency_infos_id)
REFERENCES public.dw_dim_emergency_infos (dw_dim_emergency_infos_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_contract_types CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_contract_types FOREIGN KEY (dw_dim_contract_types_id)
REFERENCES public.dw_dim_contract_types (dw_dim_contract_types_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_age_groups CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_age_groups FOREIGN KEY (dw_dim_age_group_id)
REFERENCES public.dw_dim_age_groups (dw_dim_age_group_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_accident_investigations CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_accident_investigations FOREIGN KEY (dw_dim_accident_investigations_id)
REFERENCES public.dw_dim_accident_investigations (dw_dim_accident_investigations_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_screening CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_screening FOREIGN KEY (dw_dim_screening_id)
REFERENCES public.dw_dim_screening (dw_dim_screening_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_occupational_treatments CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_occupational_treatments FOREIGN KEY (dw_occupational_treatments_id)
REFERENCES public.dw_dim_occupational_treatments (dw_occupational_treatments_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_clinical_treatments CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_clinical_treatments FOREIGN KEY (dw_dim_clinical_treatments_id)
REFERENCES public.dw_dim_clinical_treatments (dw_dim_clinical_treatments_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_tags CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_tags FOREIGN KEY (dw_dim_tags_id)
REFERENCES public.dw_dim_tags (dw_dim_tags_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_accident_treatments CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_accident_treatments FOREIGN KEY (dw_dim_accident_treatments_id)
REFERENCES public.dw_dim_accident_treatments (dw_dim_accident_treatments_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_treatments DROP CONSTRAINT IF EXISTS dw_dim_users CASCADE;
ALTER TABLE public.dw_fact_treatments ADD CONSTRAINT dw_dim_users FOREIGN KEY (dw_dim_users_id)
REFERENCES public.dw_dim_users (dw_dim_users_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- FACT MEDICAL CERTIFICATES
DROP TABLE IF EXISTS dw_fact_medical_certificates CASCADE;
CREATE TABLE dw_fact_medical_certificates(
	total smallint NOT NULL,
	dw_dim_medical_certificate_types_id integer NOT NULL,
	dw_dim_doctors_id integer NOT NULL,
	dw_dim_medical_certificate_time_frames_id integer NOT NULL,
	dw_dim_employees_id integer NOT NULL,
	dw_dim_time_id timestamp NOT NULL,
	dim_cid10s_id integer,
	dim_company_id integer NOT NULL,
	dw_dim_users_id integer
);

ALTER TABLE public.dw_fact_medical_certificates DROP CONSTRAINT IF EXISTS dw_dim_medical_certificate_types CASCADE;
ALTER TABLE public.dw_fact_medical_certificates ADD CONSTRAINT dw_dim_medical_certificate_types FOREIGN KEY (dw_dim_medical_certificate_types_id)
REFERENCES public.dw_dim_medical_certificate_types (dw_dim_medical_certificate_types_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_medical_certificates DROP CONSTRAINT IF EXISTS dw_dim_doctors CASCADE;
ALTER TABLE public.dw_fact_medical_certificates ADD CONSTRAINT dw_dim_doctors FOREIGN KEY (dw_dim_doctors_id)
REFERENCES public.dw_dim_doctors (dw_dim_doctors_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_medical_certificates DROP CONSTRAINT IF EXISTS dw_dim_medical_certificate_time_frames CASCADE;
ALTER TABLE public.dw_fact_medical_certificates ADD CONSTRAINT dw_dim_medical_certificate_time_frames FOREIGN KEY (dw_dim_medical_certificate_time_frames_id)
REFERENCES public.dw_dim_medical_certificate_time_frames (dw_dim_medical_certificate_time_frames_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_medical_certificates DROP CONSTRAINT IF EXISTS dw_dim_employees CASCADE;
ALTER TABLE public.dw_fact_medical_certificates ADD CONSTRAINT dw_dim_employees FOREIGN KEY (dw_dim_employees_id)
REFERENCES public.dw_dim_employees (dw_dim_employees_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_medical_certificates DROP CONSTRAINT IF EXISTS dw_dim_time CASCADE;
ALTER TABLE public.dw_fact_medical_certificates ADD CONSTRAINT dw_dim_time FOREIGN KEY (dw_dim_time_id)
REFERENCES public.dw_dim_time (dw_dim_time_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_medical_certificates DROP CONSTRAINT IF EXISTS dw_dim_cid10s CASCADE;
ALTER TABLE public.dw_fact_medical_certificates ADD CONSTRAINT dw_dim_cid10s FOREIGN KEY (dim_cid10s_id)
REFERENCES public.dw_dim_cid10s (dim_cid10s_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_medical_certificates DROP CONSTRAINT IF EXISTS dw_dim_companies CASCADE;
ALTER TABLE public.dw_fact_medical_certificates ADD CONSTRAINT dw_dim_companies FOREIGN KEY (dim_company_id)
REFERENCES public.dw_dim_companies (dim_company_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_medical_certificates DROP CONSTRAINT IF EXISTS dw_dim_users CASCADE;
ALTER TABLE public.dw_fact_medical_certificates ADD CONSTRAINT dw_dim_users FOREIGN KEY (dw_dim_users_id)
REFERENCES public.dw_dim_users (dw_dim_users_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;


-- FACT APPOINTMENTS
DROP TABLE IF EXISTS dw_fact_appointments CASCADE;
CREATE TABLE dw_fact_appointments(
	total smallint NOT NULL,
	cancel_total smallint NOT NULL,
	expected_duration_in_minutes smallint NOT NULL,
	actual_appointment_duration_in_minutes smallint NOT NULL,
	total_workflow_duration_in_minutes smallint NOT NULL,
	dw_dim_appointment_type_id integer NOT NULL,
	dw_dim_appointment_shifts_id integer NOT NULL,
	dw_dim_appointment_occupational_types_id integer NOT NULL,
	dw_dim_appointment_statuses_id integer NOT NULL,
	dw_dim_users_id_ integer NOT NULL,
	dw_dim_employees_id integer,
	dim_company_id integer NOT NULL,
	dw_dim_appointment_cancelers_id integer,
	dw_dim_time_id timestamp NOT NULL,
	dw_dim_contract_types_id integer
);

ALTER TABLE public.dw_fact_appointments DROP CONSTRAINT IF EXISTS dw_dim_appointment_type CASCADE;
ALTER TABLE public.dw_fact_appointments ADD CONSTRAINT dw_dim_appointment_type FOREIGN KEY (dw_dim_appointment_type_id)
REFERENCES public.dw_dim_appointment_type (dw_dim_appointment_type_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_appointments DROP CONSTRAINT IF EXISTS dw_dim_appointment_shifts CASCADE;
ALTER TABLE public.dw_fact_appointments ADD CONSTRAINT dw_dim_appointment_shifts FOREIGN KEY (dw_dim_appointment_shifts_id)
REFERENCES public.dw_dim_appointment_shifts (dw_dim_appointment_shifts_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_appointments DROP CONSTRAINT IF EXISTS dw_dim_appointment_occupational_types CASCADE;
ALTER TABLE public.dw_fact_appointments ADD CONSTRAINT dw_dim_appointment_occupational_types FOREIGN KEY (dw_dim_appointment_occupational_types_id)
REFERENCES public.dw_dim_appointment_occupational_types (dw_dim_appointment_occupational_types_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_appointments DROP CONSTRAINT IF EXISTS dw_dim_appointment_statuses CASCADE;
ALTER TABLE public.dw_fact_appointments ADD CONSTRAINT dw_dim_appointment_statuses FOREIGN KEY (dw_dim_appointment_statuses_id)
REFERENCES public.dw_dim_appointment_statuses (dw_dim_appointment_statuses_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_appointments DROP CONSTRAINT IF EXISTS dw_dim_users CASCADE;
ALTER TABLE public.dw_fact_appointments ADD CONSTRAINT dw_dim_users FOREIGN KEY (dw_dim_users_id_)
REFERENCES public.dw_dim_users (dw_dim_users_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_appointments DROP CONSTRAINT IF EXISTS dw_dim_employees CASCADE;
ALTER TABLE public.dw_fact_appointments ADD CONSTRAINT dw_dim_employees FOREIGN KEY (dw_dim_employees_id)
REFERENCES public.dw_dim_employees (dw_dim_employees_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_appointments DROP CONSTRAINT IF EXISTS dw_dim_companies CASCADE;
ALTER TABLE public.dw_fact_appointments ADD CONSTRAINT dw_dim_companies FOREIGN KEY (dim_company_id)
REFERENCES public.dw_dim_companies (dim_company_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_appointments DROP CONSTRAINT IF EXISTS dw_dim_appointment_cancelers CASCADE;
ALTER TABLE public.dw_fact_appointments ADD CONSTRAINT dw_dim_appointment_cancelers FOREIGN KEY (dw_dim_appointment_cancelers_id)
REFERENCES public.dw_dim_appointment_cancelers (dw_dim_appointment_cancelers_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_appointments DROP CONSTRAINT IF EXISTS dw_dim_time CASCADE;
ALTER TABLE public.dw_fact_appointments ADD CONSTRAINT dw_dim_time FOREIGN KEY (dw_dim_time_id)
REFERENCES public.dw_dim_time (dw_dim_time_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.dw_fact_appointments DROP CONSTRAINT IF EXISTS dw_dim_contract_types CASCADE;
ALTER TABLE public.dw_fact_appointments ADD CONSTRAINT dw_dim_contract_types FOREIGN KEY (dw_dim_contract_types_id)
REFERENCES public.dw_dim_contract_types (dw_dim_contract_types_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

CREATE OR REPLACE function get_dw_dim_time_id(t timestamp) RETURNS timestamp AS $$
  SELECT dw_dim_time_id FROM dw_dim_time
  WHERE dw_dim_time_id <= t 
  ORDER BY dw_dim_time_id DESC
  LIMIT 1;
$$ LANGUAGE sql;

CREATE OR REPLACE function get_dw_dim_emergency_infos_id(emergency_info_id integer) RETURNS integer AS $$
  SELECT dw_dim_emergency_infos_id FROM dw_dim_emergency_infos 
  INNER JOIN emergency_infos ON 
  	emergency_infos.shift_leader = dw_dim_emergency_infos.shift_leader 
  	AND COALESCE(emergency_infos.accident_site_other,emergency_infos.accident_site) = dw_dim_emergency_infos.accident_site 
  	AND emergency_infos.transported = dw_dim_emergency_infos.was_transported 
  	AND COALESCE(emergency_infos.destiny_other,emergency_infos.destiny) = dw_dim_emergency_infos.destiny
  WHERE emergency_infos.id = emergency_info_id
  LIMIT 1;
$$ LANGUAGE sql;

CREATE OR REPLACE function get_dw_dim_accident_investigations_id(accident_investigation_id integer) RETURNS integer AS $$
  SELECT dw_dim_accident_investigations_id FROM dw_dim_accident_investigations
  INNER JOIN accident_investigations ON 
  	dw_dim_accident_investigations.hours_till_accident = accident_investigations.hours_till_accident 
  	AND dw_dim_accident_investigations.company_contact_name = (SELECT name FROM company_contacts WHERE company_contacts.id = accident_investigations.company_contact_id LIMIT 1)
  	AND accident_investigations.using_equipment = dw_dim_accident_investigations.was_using_epi 
  	AND accident_investigations.event_type = dw_dim_accident_investigations.event_type 
  	AND accident_investigations.accident_classification = dw_dim_accident_investigations.accident_classification
  WHERE accident_investigations.id = accident_investigation_id
  LIMIT 1;
$$ LANGUAGE sql;

CREATE OR REPLACE function get_dw_dim_screening_id(screening_id integer) RETURNS integer AS $$
  SELECT dw_dim_screening_id FROM dw_dim_screening
  INNER JOIN screenings ON 
  	dw_dim_screening.manchester_level = screenings.screening_level 
  	AND dw_dim_screening.high_blood_pressure = high_blood_pressure(screenings.pa_sistolica,screenings.pa_diastolica)
  WHERE screenings.id = screening_id
  LIMIT 1;
$$ LANGUAGE sql;

CREATE OR REPLACE function get_dw_dim_clinical_treatments_id(clinical_treatment_id integer) RETURNS integer AS $$
  SELECT dw_dim_clinical_treatments_id FROM dw_dim_clinical_treatments
  INNER JOIN clinical_treatments ON 
  	(CASE WHEN clinical_treatments.clinical_relevance THEN 'SIM' ELSE 'NÃO' END) = dw_dim_clinical_treatments.is_relevant 
  	AND (CASE WHEN clinical_treatments.not_occupational THEN 'NÃO' ELSE 'SIM' END) = dw_dim_clinical_treatments.had_occupational_origin
  WHERE clinical_treatments.id = clinical_treatment_id
  LIMIT 1;
$$ LANGUAGE sql;

CREATE OR REPLACE function get_dw_occupational_treatments_id(atype varchar, ais_able varchar, aosteomuscular_complaint varchar, aosteomuscular_complaint_side varchar) RETURNS integer AS $$
  SELECT dw_occupational_treatments_id FROM dw_dim_occupational_treatments
  WHERE 
  	dw_dim_occupational_treatments.type = atype 
  	AND dw_dim_occupational_treatments.is_able = ais_able 
  	AND dw_dim_occupational_treatments.osteomuscular_complaint = aosteomuscular_complaint 
  	AND dw_dim_occupational_treatments.osteomuscular_complaint_side = aosteomuscular_complaint_side 
  LIMIT 1;
$$ LANGUAGE sql;

CREATE OR REPLACE function get_dw_dim_accident_treatments_id(aorigin_of_injury varchar, abody_matrix varchar, aperiod_away varchar, aaway_type varchar) RETURNS integer AS $$
  SELECT dw_dim_accident_treatments_id FROM dw_dim_accident_treatments
  WHERE 
  	dw_dim_accident_treatments.origin_of_injury = aorigin_of_injury 
  	AND dw_dim_accident_treatments.body_matrix = abody_matrix 
  	AND dw_dim_accident_treatments.period_away = aperiod_away 
  	AND dw_dim_accident_treatments.away_type = aaway_type 
  LIMIT 1;
$$ LANGUAGE sql;

CREATE OR REPLACE function get_dw_dim_age_group_id(the_birth_date date, on_date date) RETURNS integer AS $$
  SELECT dw_dim_age_group_id FROM dw_dim_age_groups
  WHERE 
  	date_part('year',age(on_date,the_birth_date)) >= min 
  	AND date_part('year',age(on_date,the_birth_date)) <= max
  LIMIT 1;
$$ LANGUAGE sql;
