ActiveAdmin.register Product do

	menu priority: 1
	
	form do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs "Dados de Cadastro" do
			f.input :brand
			f.input :product_category
			f.input :name
			f.input :subtitle
			f.input :description, as: :wysihtml5, blocks: [:h1,:h2,:h3,:p]
		end
		f.inputs "Preço" do
			f.input :price
			f.input :original_price
		end
		f.inputs "Status" do
			f.input :is_new_product, as: :boolean
			f.input :is_featured, as: :boolean
			f.input :is_available, as: :boolean
		end
		f.inputs "Imagem" do
			f.input :image, :as => :file, :hint => (f.template.image_tag(f.object.image.url(:thumb)) if f.object.image?) 
      f.input :image_cache, :as => :hidden, :wrapper_html => { :style => "display:none;" }	
		end
		f.inputs "Tipos" do
			f.has_many :product_types do |fs|
				fs.input :name
				fs.input :qty, as: :number
				fs.input :weight, as: :number, hint: "em gramas (gr)"
				fs.input :width, as: :number, hint: "em centímetros (cm)"
				fs.input :height, as: :number, hint: "em centímetros (cm)"
				fs.input :length, as: :number, hint: "em centímetros (cm)"
				fs.input :_destroy, :as => :boolean, :required => false, :label=>'Remover ao salvar'
			end
		end
		f.inputs "Produtos Relacionados" do
			f.has_many :product_relateds do |fs|
				fs.input :related, as: :select, collection: Product.order(:name).all.collect{ |i| ["#{i.name} - #{i.subtitle}",i.id] }
				fs.input :_destroy, :as => :boolean, :required => false, :label=>'Remover ao salvar'
			end
		end
		f.actions
	end

	index do 
		column :image do |product|
			image_tag(product.image.url(:thumb))
		end
		column :name
		column :is_available do |product|
			product.is_available ? status_tag("Disponível",:ok) : status_tag("Indisponível")
		end
		column :is_featured do |product|
			product.is_featured ? status_tag("Destaque",:ok) : ""
		end
		default_actions
	end

	show do |product|
		panel "Dados de cadastro" do
			attributes_table_for product do
				row :brand
				row :product_category
				row :name
				row :description do |p|
					p.description.html_safe
				end
				row :price
				row :original_price
				row :is_available do |p|
					p.is_available ? status_tag("Disponível",:ok) : status_tag("Indisponível")
				end
				row :is_featured do |p|
					p.is_featured ? status_tag("Destaque",:ok) : "-"
				end
				row :image do |p|
					image_tag(p.image.url(:thumb))
				end
				row :created_at
				row :updated_at
			end
		end
		panel "Tipos" do
			product.product_types.each do |product_type|
				attributes_table_for product_type do
					row :name
					row :qty
					row :weight
					row :height
					row :width
					row :length
				end
			end
		end
		panel "Produtos relacionados" do
			product.product_relateds.each do |r|
				attributes_table_for r do 
					row :related
				end
			end
		end if product.product_relateds.any?
		panel "Cadastros" do
			attributes_table_for product do 
				row "Cadastros" do 
					"Este produto possui #{product.product_subscriptions.count} cadastros."
				end
			end
		end
	end

end
