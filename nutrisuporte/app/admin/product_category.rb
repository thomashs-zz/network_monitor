ActiveAdmin.register ProductCategory do

	menu parent: "Configurações"

	config.sort_order = "relevance_asc"

	filter :name

	index do 
		column :name
		column :relevance
		column :product_category
		default_actions
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs do
			f.input :product_category
			f.input :name, as: :string
			f.input :subtitle, as: :string
			f.input :relevance, as: :number
		end
		f.actions
	end

	show do
		attributes_table do 
			row :product_category
			row :name
			row :subtitle
			row :relevance
			row :url
		end
	end

end
