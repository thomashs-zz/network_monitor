require 'mondrian-olap'
class Dwh

  @schema = Mondrian::OLAP::Schema.define do
    
    cube 'Atendimentos' do
      
      table 'dw_fact_treatments'

      dimension 'Tempo', :foreign_key => 'dw_dim_time_id', :type => 'TimeDimension' do
        hierarchy :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Semestre', :column => 'semester_of_year', :unique_members => false, :level_type => 'TimeQuarters'
          level 'Mes', :column => 'month', :type => 'Numeric', :unique_members => false, :level_type => 'TimeMonths'
          level 'Dia', :column => 'day', :type => 'Numeric', :unique_members => false, :level_type => 'TimeDays'
          level 'Hora', :column => 'hour', :type => 'Numeric', :unique_members => false, :level_type => 'TimeHours'
          level 'Minuto', :column => 'minute', :type => 'Numeric', :unique_members => false, :level_type => 'TimeMinutes'
        end
        hierarchy 'SemanaDoAno', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Semana do Ano', :column => 'week_of_the_year', :type => 'Numeric', :unique_members => false, :level_type => 'TimeWeeks'
        end
        hierarchy 'SemanaDoMes', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Semana do Mes', :column => 'week_of_the_month', :type => 'Numeric', :unique_members => false, :level_type => 'TimeWeeks'
        end
        hierarchy 'DiaDaSemana', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Dia da Semana', :column => 'day_of_week', :type => 'Numeric', :unique_members => false, :level_type => 'TimeDays'
        end
        hierarchy 'MesDoAno', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Mes', :column => 'month', :type => 'Numeric', :unique_members => true, :level_type => 'TimeMonths'
        end
      end

      dimension 'Status de Exames', :foreign_key => 'dw_dim_complementary_exams_status_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos os Status', :primary_key => 'dw_dim_complementary_exams_status_id' do
          table 'dw_dim_complementary_exams_statuses'
          level 'Status', :column => 'status', :unique_members => true
          level 'Nome do Exame', :column => 'exam_name', :unique_members => false
        end
      end

      dimension 'Funcionarios', :foreign_key => 'dw_dim_employees_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos os Funcionarios', :primary_key => 'dw_dim_employees_id' do
          table 'dw_dim_employees'
          level 'Sexo', :column => 'gender', :unique_members => true
          level 'Nome', :column => 'name', :unique_members => false
          level 'CPF', :column => 'cpf', :unique_members => false
          level 'Data de Nascimento', :column => 'birth_date', :unique_members => false
        end
      end

      dimension 'Tipos de Atendimento', :foreign_key => 'dw_dim_treatment_types_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos os Tipos', :primary_key => 'dw_dim_treatment_types_id' do
          table 'dw_dim_treatment_types'
          level 'Descricao', :column => 'description', :unique_members => true
          level 'slug', :column => 'slug', :unique_members => true
        end
      end

      dimension 'Empresas', :foreign_key => 'dim_company_id' do
        hierarchy :has_all => true, :all_member_name => 'Todas', :primary_key => 'dim_company_id' do
          table 'dw_dim_companies'
          level 'Nome', :column => 'name', :unique_members => true
          level 'CNPJ', :column => 'cnpj', :unique_members => true
          level 'Tipo de Contrato', :column => 'company_type', :unique_members => true
        end
      end

      dimension 'CID10s', :foreign_key => 'dim_cid10s_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dim_cid10s_id' do
          table 'dw_dim_cid10s'
          level 'Grupo', :column => 'group_description', :unique_members => true
          level 'Descricao', :column => 'description', :unique_members => false
          level 'Codigo', :column => 'code', :unique_members => true
        end
      end

      dimension 'Informacoes de Emergencia', :foreign_key => 'dw_dim_emergency_infos_id' do
        hierarchy :has_all => true, :all_member_name => 'Todas', :primary_key => 'dw_dim_emergency_infos_id' do
          table 'dw_dim_emergency_infos'
          level 'Foi Transportado', :column => 'was_transported', :unique_members => true
          level 'Lider do Turno', :column => 'shift_leader', :unique_members => false
          level 'Local do Acidente', :column => 'accident_site', :unique_members => false
          level 'Responsavel pelo Transporte', :column => 'transport_responsible', :unique_members => false
          level 'Destino', :column => 'destiny', :unique_members => false
        end
      end

      dimension 'Investigacoes de Acidentes', :foreign_key => 'dw_dim_accident_investigations_id' do
        hierarchy :has_all => true, :all_member_name => 'Todas', :primary_key => 'dw_dim_accident_investigations_id' do
          table 'dw_dim_accident_investigations'
          level 'Horas ate Acidente', :column => 'hours_till_accident', :unique_members => false
          level 'Preenchido por', :column => 'company_contact_name', :unique_members => false
          level 'Usava Equipamento de Seguranca', :column => 'was_using_epi', :unique_members => false
          level 'Tipo de Acidente', :column => 'event_type', :unique_members => false
          level 'Classificao Acidente', :column => 'accident_classification', :unique_members => false
        end
      end

      dimension 'Triagens', :foreign_key => 'dw_dim_screening_id' do
        hierarchy :has_all => true, :all_member_name => 'Todas', :primary_key => 'dw_dim_screening_id' do
          table 'dw_dim_screening'
          level 'Pressao Alta', :column => 'high_blood_pressure', :unique_members => true
          level 'Nivel Manchester', :column => 'manchester_level', :unique_members => false
        end
      end

      dimension 'Atendimento Ocupacional', :foreign_key => 'dw_occupational_treatments_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_occupational_treatments_id' do
          table 'dw_dim_occupational_treatments'
          level 'Tipo', :column => 'type', :unique_members => false
          level 'Apto para Trabalhar', :column => 'is_able', :unique_members => true
          level 'Queixa Osteomuscular', :column => 'osteomuscular_complaint', :unique_members => false
          level 'Lado da Queixa', :column => 'osteomuscular_complaint_side', :unique_members => true
        end
      end

      dimension 'Atendimento Clinico', :foreign_key => 'dw_dim_clinical_treatments_id' do
        hierarchy :has_all => true, :all_member_name => 'Todas', :primary_key => 'dw_dim_clinical_treatments_id' do
          table 'dw_dim_clinical_treatments'
          level 'Clinicamente Relevante', :column => 'is_relevant', :unique_members => false
        end
        hierarchy 'Origem Ocupacional',:has_all => true, :primary_key => 'dw_dim_clinical_treatments_id' do
          table 'dw_dim_clinical_treatments'
          level 'Origem Ocupacional', :column => 'had_occupational_origin', :unique_members => false
        end
      end
      
      dimension 'Tags', :foreign_key => 'dw_dim_tags_id' do
        hierarchy :has_all => true, :all_member_name => 'Todas', :primary_key => 'dw_dim_tags_id' do
          table 'dw_dim_tags'
          level 'Descricao', :column => 'description', :unique_members => true
          level 'Subcategoria', :column => 'subcategory', :unique_members => false
        end
      end

      dimension 'Ocorrencias', :foreign_key => 'dw_dim_accident_treatments_id' do
        hierarchy :has_all => true, :all_member_name => true, :primary_key => 'dw_dim_accident_treatments_id' do
          table 'dw_dim_accident_treatments'
          level 'Origem da Lesao', :column => 'origin_of_injury', :unique_members => false
          level 'Parte do Corpo Atingida', :column => 'body_matrix', :unique_members => false
          level 'Afastamento', :column => 'period_away', :unique_members => false
          level 'Tipo de Afastamento', :column => 'away_type', :unique_members => false
        end
      end
      
      dimension 'Usuarios', :foreign_key => 'dw_dim_users_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_users_id' do
          table 'dw_dim_users'
          level 'Tipo', :column => 'user_type', :unique_members => false
          level 'Nome', :column => 'name', :unique_members => true
        end
      end
            
      dimension 'Tipos de Contrato', :foreign_key => 'dw_dim_contract_types_id' do
        hierarchy :has_all => true, :all_member_name => 'Todas', :primary_key => 'dw_dim_contract_types_id' do
          table 'dw_dim_contract_types'
          level 'Descricao', :column => 'description', :unique_members => false
        end
      end
         
      dimension 'Faixa Etaria', :foreign_key => 'dw_dim_age_group_id' do
        hierarchy :has_all => true, :all_member_name => 'Todas', :primary_key => 'dw_dim_age_group_id' do
          table 'dw_dim_age_groups'
          level 'Descricao', :column => 'description', :unique_members => false
        end
      end

      measure 'Total', :column => 'treatment_id', :aggregator => 'distinct-count'
      measure 'Tempo em Sala de Espera', :column => 'total_waiting_room_duration_in_minutes', :aggregator => 'avg'
      measure 'Tempo em Triagem', :column => 'total_screening_duration_in_minutes', :aggregator => 'avg'
      measure 'Tempo com Medico', :column => 'total_doctor_treatment_duration_in_minutes', :aggregator => 'avg'
      measure 'Tempo com Enfermeiro', :column => 'total_nursing_treatment_duration_in_minutes', :aggregator => 'avg'
      measure 'Tempo em Exames', :column => 'total_complementary_exam_duration_in_minutes', :aggregator => 'avg'
      measure 'Tempo Total', :column => 'total_complete_treatment_duration_in_minutes', :aggregator => 'avg'
      measure 'Tempo em Repouso', :column => 'total_rest_duration_in_minutes', :aggregator => 'avg'

    end

    cube 'Agenda' do 

      table 'dw_fact_appointments'

      dimension 'Tempo', :foreign_key => 'dw_dim_time_id', :type => 'TimeDimension' do
        hierarchy :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Semestre', :column => 'semester_of_year', :unique_members => false, :level_type => 'TimeQuarters'
          level 'Mes', :column => 'month', :type => 'Numeric', :unique_members => false, :level_type => 'TimeMonths'
          level 'Dia', :column => 'day', :type => 'Numeric', :unique_members => false, :level_type => 'TimeDays'
          level 'Hora', :column => 'hour', :type => 'Numeric', :unique_members => false, :level_type => 'TimeHours'
          level 'Minuto', :column => 'minute', :type => 'Numeric', :unique_members => false, :level_type => 'TimeMinutes'
        end
        hierarchy 'SemanaDoAno', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Semana do Ano', :column => 'week_of_the_year', :type => 'Numeric', :unique_members => false, :level_type => 'TimeWeeks'
        end
        hierarchy 'SemanaDoMes', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Semana do Mes', :column => 'week_of_the_month', :type => 'Numeric', :unique_members => false, :level_type => 'TimeWeeks'
        end
        hierarchy 'DiaDaSemana', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Dia da Semana', :column => 'day_of_week', :type => 'Numeric', :unique_members => false, :level_type => 'TimeDays'
        end
        hierarchy 'MesDoAno', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Mes', :column => 'month', :type => 'Numeric', :unique_members => true, :level_type => 'TimeMonths'
        end
      end

      dimension 'Empresas', :foreign_key => 'dim_company_id' do
        hierarchy :has_all => true, :all_member_name => 'Todas', :primary_key => 'dim_company_id' do
          table 'dw_dim_companies'
          level 'Nome', :column => 'name', :unique_members => true
          level 'CNPJ', :column => 'cnpj', :unique_members => true
          level 'Tipo de Contrato', :column => 'company_type', :unique_members => true
        end
      end

      dimension 'Usuarios', :foreign_key => 'dw_dim_users_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_users_id' do
          table 'dw_dim_users'
          level 'Tipo', :column => 'user_type', :unique_members => false
          level 'Nome', :column => 'name', :unique_members => true
        end
      end

      dimension 'Canceladores', :foreign_key => 'dw_dim_appointment_cancelers_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_appointment_cancelers_id' do
          table 'dw_dim_appointment_cancelers'
          level 'Empresa', :column => 'company_name', :unique_members => true
          level 'Nome', :column => 'user_name', :unique_members => false
        end
      end

      dimension 'Funcionarios', :foreign_key => 'dw_dim_employees_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos os Funcionarios', :primary_key => 'dw_dim_employees_id' do
          table 'dw_dim_employees'
          level 'Sexo', :column => 'gender', :unique_members => true
          level 'Nome', :column => 'name', :unique_members => false
          level 'CPF', :column => 'cpf', :unique_members => false
          level 'Data de Nascimento', :column => 'birth_date', :unique_members => false
        end
      end

      dimension 'Tipo de Agendamento', :foreign_key => 'dw_dim_appointment_type_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_appointment_type_id' do
          table 'dw_dim_appointment_type'
          level 'Description', :column => 'description', :unique_members => true
        end
      end

      dimension 'Tipo Ocupacional', :foreign_key => 'dw_dim_appointment_occupational_types' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_appointment_occupational_types_id' do
          table 'dw_dim_appointment_occupational_types'
          level 'Description', :column => 'description', :unique_members => true
        end
      end

      dimension 'Status', :foreign_key => 'dw_dim_appointment_statuses_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_appointment_statuses_id' do
          table 'dw_dim_appointment_statuses'
          level 'Description', :column => 'description', :unique_members => true
        end
      end

      dimension 'Turnos', :foreign_key => 'dw_dim_appointment_shifts_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_appointment_shifts_id' do
          table 'dw_dim_appointment_shifts'
          level 'Description', :column => 'description', :unique_members => true
        end
      end

      measure 'Total', :column => 'total', :aggregator => 'sum'
      measure 'Cancelados', :column => 'cancel_total', :aggregator => 'avg'
      measure 'Duracao esperada min', :column => 'expected_duration_in_minutes', :aggregator => 'avg'
      measure 'Duracao em min', :column => 'actual_appointment_duration_in_minutes', :aggregator => 'avg'
      measure 'Workflow min', :column => 'total_workflow_duration_in_minutes', :aggregator => 'avg'

    end

    cube 'Atestados' do 

      table 'dw_fact_medical_certificates'

      dimension 'Tempo', :foreign_key => 'dw_dim_time_id', :type => 'TimeDimension' do
        hierarchy :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Semestre', :column => 'semester_of_year', :unique_members => false, :level_type => 'TimeQuarters'
          level 'Mes', :column => 'month', :type => 'Numeric', :unique_members => false, :level_type => 'TimeMonths'
          level 'Dia', :column => 'day', :type => 'Numeric', :unique_members => false, :level_type => 'TimeDays'
          level 'Hora', :column => 'hour', :type => 'Numeric', :unique_members => false, :level_type => 'TimeHours'
          level 'Minuto', :column => 'minute', :type => 'Numeric', :unique_members => false, :level_type => 'TimeMinutes'
        end
        hierarchy 'SemanaDoAno', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Semana do Ano', :column => 'week_of_the_year', :type => 'Numeric', :unique_members => false, :level_type => 'TimeWeeks'
        end
        hierarchy 'SemanaDoMes', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Semana do Mes', :column => 'week_of_the_month', :type => 'Numeric', :unique_members => false, :level_type => 'TimeWeeks'
        end
        hierarchy 'DiaDaSemana', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Ano', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Dia da Semana', :column => 'day_of_week', :type => 'Numeric', :unique_members => false, :level_type => 'TimeDays'
        end
        hierarchy 'MesDoAno', :has_all => true, :primary_key => 'dw_dim_time_id' do
          table 'dw_dim_time'
          level 'Mes', :column => 'month', :type => 'Numeric', :unique_members => true, :level_type => 'TimeMonths'
        end
      end

      dimension 'Periodo', :foreign_key => 'dw_dim_medical_certificate_time_frames_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_medical_certificate_time_frames_id' do
          table 'dw_dim_medical_certificate_time_frames_id'
          level 'Description', :column => 'description', :unique_members => true
        end
      end

      dimension 'Usuarios', :foreign_key => 'dw_dim_users_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_users_id' do
          table 'dw_dim_users'
          level 'Tipo', :column => 'user_type', :unique_members => false
          level 'Nome', :column => 'name', :unique_members => true
        end
      end

      dimension 'CID10s', :foreign_key => 'dim_cid10s_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dim_cid10s_id' do
          table 'dw_dim_cid10s'
          level 'Grupo', :column => 'group_description', :unique_members => true
          level 'Descricao', :column => 'description', :unique_members => false
          level 'Codigo', :column => 'code', :unique_members => true
        end
      end

      dimension 'Funcionarios', :foreign_key => 'dw_dim_employees_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos os Funcionarios', :primary_key => 'dw_dim_employees_id' do
          table 'dw_dim_employees'
          level 'Sexo', :column => 'gender', :unique_members => true
          level 'Nome', :column => 'name', :unique_members => false
          level 'CPF', :column => 'cpf', :unique_members => false
          level 'Data de Nascimento', :column => 'birth_date', :unique_members => false
        end
      end

      dimension 'Empresas', :foreign_key => 'dim_company_id' do
        hierarchy :has_all => true, :all_member_name => 'Todas', :primary_key => 'dim_company_id' do
          table 'dw_dim_companies'
          level 'Nome', :column => 'name', :unique_members => true
          level 'CNPJ', :column => 'cnpj', :unique_members => true
          level 'Tipo de Contrato', :column => 'company_type', :unique_members => true
        end
      end

      dimension 'Medico', :foreign_key => 'dw_dim_doctors_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_doctors_id' do
          table 'dw_dim_doctors'
          level 'Name', :column => 'name', :unique_members => true
          level 'CRM', :column => 'crm', :unique_members => true
        end
      end

      dimension 'Medico', :foreign_key => 'dw_dim_medical_certificate_time_frames_id' do
        hierarchy :has_all => true, :all_member_name => 'Todos', :primary_key => 'dw_dim_medical_certificate_time_frames_id' do
          table 'dw_dim_medical_certificate_time_frames'
          level 'Description', :column => 'description', :unique_members => true
        end
      end

      measure 'Total', :column => 'total', :aggregator => 'sum'

    end

  end
  
  def self.schema
    @schema
  end

  params = ActiveRecord::Base.configurations[Rails.env].symbolize_keys
  @olap = Mondrian::OLAP::Connection.create(
    :driver => params[:adapter] == 'oracle_enhanced' ? 'oracle' : params[:adapter],
    :host => params[:host],
    :database => params[:database],
    :username => params[:username],
    :password => params[:password],
    :schema => @schema
  )

  def self.olap
    @olap
  end

end
