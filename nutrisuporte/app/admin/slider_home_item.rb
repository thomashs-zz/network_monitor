ActiveAdmin.register SliderHomeItem do

	menu parent: "Configurações"

	filter :title

	index do 
		column :image do |show|
			image_tag(show.image.url(:thumb))
		end
		column :title
		column :relevance
		default_actions
	end

	form do |f|
		f.inputs "Títulos" do
			f.input :title
			f.input :subtitle
			f.input :description, as: :text
		end
		f.inputs "Imagens" do
			f.input :image, :as => :file, :hint => (f.template.image_tag(f.object.image.url(:thumb)) if f.object.image?) 
      f.input :image_cache, :as => :hidden, :wrapper_html => { :style => "display:none;" }
      f.input :background_image, :as => :file, :hint => (f.template.image_tag(f.object.background_image.url(:thumb)) if f.object.background_image?) 
      f.input :background_image_cache, :as => :hidden, :wrapper_html => { :style => "display:none;" }
      f.input :display_picture_only, as: :boolean
		end
		f.inputs "Configurações" do
			f.input :price, as: :number
			f.input :price_subtitle
			f.input :url, as: :string
			f.input :relevance
			f.input :is_available, as: :boolean
		end
		f.actions
	end

	show do |s|
		attributes_table do
			row :title
			row :subtitle
			row :price
			row :price_subtitle
			row :relevance
			row :image do |slider|
				image_tag(slider.image.url(:thumb))
			end if s.image.url
			row :background_image do |slider|
				image_tag(slider.background_image.url(:thumb))
			end
			row :url
			row :is_available do |slider|
				slider.is_available ? status_tag("Mostrando no site",:ok) : status_tag("Não mostrando no site")
			end
		end
	end

end
