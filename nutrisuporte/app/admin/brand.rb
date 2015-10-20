ActiveAdmin.register Brand do

	menu parent: "Configurações"

	form do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs do 
			f.input :name, as: :string
			f.input :is_available, as: :boolean
			f.input :image, :as => :file, :hint => (f.template.image_tag(f.object.image.url(:thumb)) if f.object.image?) 
      f.input :image_cache, :as => :hidden, :wrapper_html => { :style => "display:none;" }
		end
		f.actions
	end

	index do 
		column :image do |brand|
			image_tag(brand.image.url(:thumb))
		end
		column :name
		column :is_available do |brand|
			brand.is_available ? status_tag('Sim',:ok) : status_tag('Não',:danger)
		end
		default_actions
	end

	show do |brand|
		attributes_table do
			row :image do
				image_tag(brand.image.url(:thumb))
			end
    	row :name
    	row :url
    	row :is_available do
    		brand.is_available ? status_tag('Sim',:ok) : status_tag('Não',:danger)
    	end
    end
	end

end