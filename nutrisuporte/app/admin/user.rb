ActiveAdmin.register User do

	menu priority: 2

	filter :name
	filter :email
	filter :cpf_or_cnpj_contains, as: :string

	form do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs "Dados de cadastro" do
			f.input :name
			f.input :email
			f.input :user_type, as: :select, collection: ['fisica','juridica']
			f.input :cpf
			f.input :cnpj
			f.input :company_name
			f.input :state_registration
			f.input :phone
			f.input :password, as: :password
			f.input :mobile
			f.input :gender, as: :radio, collection: ['m','f']
			f.input :birth_date, as: :date_select, start_year: Time.now.year - 100
			f.input :email_news, as: :boolean
		end
		f.inputs "Endereços" do
			f.has_many :user_addresses do |fs|
				fs.input :is_default, as: :boolean
				fs.input :name
				fs.input :address
				fs.input :neighbourhood
				fs.input :cep
				fs.input :city
				fs.input :state
			end
		end
		f.actions
	end

	show do |user|
		attributes_table do
			row :name
			row :email
			row :user_type
			row (user.user_type == 'fisica' ? :cpf : :cnpj)
			row :phone
			row :mobile
			row :gender
			row :birth_date
			row :email_news do 
				user.email_news ? status_tag("Sim",:ok) : status_tag("Não")
			end
		end
		user.user_addresses.each do |address|
			panel "Endereço" do
				attributes_table_for address  do 
					row :name
					row :is_default do
						address.is_default ? status_tag("Sim",:ok) : status_tag("Não")
					end
					row :address
					row :neighbourhood
					row :cep
					row :city
					row :state
				end
			end
		end
	end

	index do 
		column :name
		column :email
		default_actions
	end

end
