# encoding: UTF-8
namespace :dw do
	task :extract => :environment do |t|
		
		# creates temp table dw_dim_occupational_treatments_temp

		puts "criando tabela temporária dw_dim_occupational_treatments_temp"
		sql_create = %Q(
			DROP TABLE IF EXISTS dw_dim_occupational_treatments_temp CASCADE;
			CREATE TABLE dw_dim_occupational_treatments_temp(
				occupational_treatment_id integer,
				type varchar,
				is_able varchar,
				osteomuscular_complaint varchar,
				osteomuscular_complaint_side varchar
			);
		)
		ActiveRecord::Base.connection.execute(sql_create)
		puts "tabela dw_dim_occupational_treatments_temp criada"
		#
		puts "extraindo dados para dw_dim_occupational_treatments_temp"
		

		body_segment_types = {
	    'Antebraço' => 'antebraco',
	    'Braço' => 'braco',
	    'Coluna cervical' => 'coluna_cervical',
	    'Coluna dorsal' => 'coluna_dorsal',
	    'Coluna lombar' => 'coluna_lombar',
	    'Coxa' => 'coxa',
	    'Ombro' => 'ombro',
	    'Cotovelo' => 'cotovelo',
	    'Punho' => 'punho',
	    'Mão' => 'mao',
	    'Quadril' => 'quadril',
	    'Joelho' => 'joelho',
	    'Tornozelo' => 'tornozelo',
	    'Pé' => 'pe',
	    'Perna' => 'perna'
	  }

	  body_side_types = {
	    'Esquerdo' => 'esquerdo',
	    'Direito' => 'direito'
	  }

		h_queixas_ostemusculares = {}				

		body_side_types.each do |side_k,side_v|
			body_segment_types.each do |type_k,type_v| 
				h_queixas_ostemusculares["#{type_v}_#{side_v}"] = {
					type: type_k,
					side: side_k
				}
			end
		end

		sql_select = %(SELECT id,reason,able,body_matrix FROM occupational_treatments)
		occupational_data = ActiveRecord::Base.connection.execute(sql_select)
		occupational_data.each do |data|
			begin 
				sql_insert = "INSERT INTO dw_dim_occupational_treatments_temp (occupational_treatment_id,type,is_able,osteomuscular_complaint,osteomuscular_complaint_side) VALUES "
				array_queixas_osteomusculares = YAML::load(data["body_matrix"].to_s)
				if array_queixas_osteomusculares != false and array_queixas_osteomusculares != [] 
					inserts = []
					array_queixas_osteomusculares.each do |item|
						h_qo = h_queixas_ostemusculares[item]
						inserts << "(#{data["id"]},'#{data["reason"]}','#{data["able"] == true ? "SIM" : "NÃO" }','#{h_qo[:type]}','#{h_qo[:side]}')"
					end
					sql_insert += (inserts * ",").to_s
				else
					sql_insert += "(#{data["id"]},'#{data["reason"]}','#{data["able"] == true ? "SIM" : "NÃO" }',NULL,NULL)"
				end
				ActiveRecord::Base.connection.execute(sql_insert)
			rescue Exception => e
				puts e
			end
		end
		puts "extracao para dw_dim_occupational_treatments_temp terminada"

		# --------------------------------------------------------
		# --------------------------------------------------------
		# --------------------------------------------------------

		puts "extracao para dw_dim_accident_treatments_temp"

		sql_create = %Q(
			DROP TABLE IF EXISTS dw_dim_accident_treatments_temp CASCADE;
			CREATE TABLE dw_dim_accident_treatments_temp(
				accident_treatment_id integer,
				origin_of_injury varchar,
				body_matrix varchar,
				period_away varchar,
				away_type varchar
			);
		)
		ActiveRecord::Base.connection.execute(sql_create)

		# lista origin_of_injury_types  
		# valor unico awat_types
		# lista body_parts_types
		# valor unico period_away_types

		away_type_types = {
			'Afastamento' => 'afastamento',
			'Restrição' => 'restricao',
			'Sem afastamento' => 'sem_afastamento'
		}

		period_away_types = {
			'0 dia' => '0',
			'1 a 3 dias' => '1_a_3',
			'4 a 6 dias' => '1_a_6',
			'7 a 15 dias' => '7_a_15',
			'Superior a 15 dias' => '15+'
		}

		sql_select = "SELECT id, body_matrix, origin_of_injury, period_away, away_type FROM accident_treatments"
		accident_data = ActiveRecord::Base.connection.execute(sql_select)
		accident_data.each do |data|
			sql_insert = "INSERT INTO dw_dim_accident_treatments_temp (accident_treatment_id, origin_of_injury, body_matrix, period_away, away_type) VALUES "
			body_matrix_array = YAML::load(data["body_matrix"].to_s)
			body_matrix_array = [] if body_matrix_array == false
			origin_of_injury_array = YAML::load(data["origin_of_injury"].to_s)
			origin_of_injury_array = [] if origin_of_injury_array == false 
			inserts = []
			body_matrix_array.each do |body_matrix_item| 
				if origin_of_injury_array.empty?
					inserts << "(#{data["id"]},'#{body_matrix_item}','NÃO INFORMADO','#{period_away_types.invert[data["period_away"]]}','#{away_type_types.invert[data["away_type"]]}')"
				else
					origin_of_injury_array.each do |origin_of_injury_item|
						inserts << "(#{data["id"]},'#{body_matrix_item}','#{origin_of_injury_item}','#{period_away_types.invert[data["period_away"]]}','#{away_type_types.invert[data["away_type"]]}')"
					end
				end
			end

			if body_matrix_array.empty?
				origin_of_injury_array.each do |origin_of_injury_item|
					inserts << "(#{data["id"]},'NÃO INFORMADO','#{origin_of_injury_item}','#{period_away_types.invert[data["period_away"]]}','#{away_type_types.invert[data["away_type"]]}')"
				end
			end

			if body_matrix_array.empty? and origin_of_injury_array.empty?
				inserts << "(#{data["id"]},'NÃO INFORMADO','NÃO INFORMADO','#{period_away_types.invert[data["period_away"]]}','#{away_type_types.invert[data["away_type"]]}')"
			end

			sql_insert += (inserts * ",")
			ActiveRecord::Base.connection.execute(sql_insert)
		end

		puts "extracao para dw_dim_accident_treatments_temp terminada"		

		# --------------------------------------------------------
		# --------------------------------------------------------
		# --------------------------------------------------------

		puts "criando tabela temporária dw_other_treatment_exams_tags_temp"
		sql_create = %Q(
			DROP TABLE IF EXISTS dw_other_treatment_exams_tags_temp CASCADE;
			CREATE TABLE dw_other_treatment_exams_tags_temp(
				treatment_id integer,
				tag_id integer
			);
		)
		ActiveRecord::Base.connection.execute(sql_create)
		puts "tabela dw_other_treatment_exams_tags_temp criada"
		#

		other_exams_types = { 
			'Eletrocardiograma' => 'ecg', 
			'Eletroencefalograma' => 'eeg', 
			'Exame Laboratorial' => 'exame_laboratorial' 
		}

		other_exams_tag_index = { 'ecg' => 5, 'eeg' => 6, 'exame_laboratorial' => 7 }

		puts "extraindo dados para dw_other_treatment_exams_tags_temp"

		sql_select = "SELECT id,other_exams FROM treatments"
		treatments_data = ActiveRecord::Base.connection.execute(sql_select)
		treatments_data.each do |data|
			other_exams = YAML::load(data["other_exams"].to_s)
			if other_exams != false and other_exams != []
				other_exams.each do |exam_name|
					sql_insert = "INSERT INTO dw_other_treatment_exams_tags_temp (treatment_id,tag_id) VALUES (#{data["id"]},#{other_exams_tag_index[exam_name.to_s]})"
					ActiveRecord::Base.connection.execute(sql_insert)
				end
			end
		end

		puts "extracao para dw_other_treatment_exams_tags_temp terminada"

		# --------------------------------------------------------
		# --------------------------------------------------------
		# --------------------------------------------------------

		# EXECUTE SQL SCRIPT
		puts "iniciando execução de scripts SQL para extracao"
		ActiveRecord::Base.connection.execute(open("#{Rails.root}/db/create_datawarehouse.sql").read.to_s)
		puts 'extraindo p/ tratamentos'
		ActiveRecord::Base.connection.execute(open("#{Rails.root}/db/extract_fact_treatments.sql").read.to_s)
		puts 'extraindo p/ atestados medicos'
		ActiveRecord::Base.connection.execute(open("#{Rails.root}/db/extract_fact_medical_certificates.sql").read.to_s)
		puts 'extraindo p/ agenda'
		ActiveRecord::Base.connection.execute(open("#{Rails.root}/db/extract_fact_appointments.sql").read.to_s)
		puts "execucao SQL terminada"
		
		# DROP TEMP TABLES
		temp_tables = ['dw_dim_occupational_treatments_temp','dw_dim_accident_treatments_temp','dw_other_treatment_exams_tags_temp']
		temp_tables.each { |table_name| ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{table_name}") }
		puts "tabelas temporarias removidas"
		puts "fim do script"

	end
end