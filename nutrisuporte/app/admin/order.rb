ActiveAdmin.register Order do

	filter :status, as: :select, collection: Order.status_types
	filter :delivery_method, as: :select, collection: Order.delivery_types
	filter :total
	filter :total_discount
	filter :total_shipping
	filter :credit_card_interest

	menu priority: 3

	show do |order|
		
		attributes_table do
    	row :user
    	row :created_at
    	row :status do |order|
    		status_tag(Order.status_types.invert[order.status])
    	end

    	row :the_total do 
    		number_to_currency(order.the_total)
    	end
    	row :total do 
    		number_to_currency(order.total)
    	end
    	row :credit_card_interest do 
    		number_to_currency(order.credit_card_interest)
    	end
    	row :total_discount do 
    		number_to_currency(order.total_discount)
    	end
    	row :total_shipping do 
    		number_to_currency(order.total_shipping)
    	end
    	row :is_gift do |order|
    		order.is_gift ? status_tag("Embalagem de Presente",:ok) : status_tag("Embalagem normal")
    	end
    end

    panel "Status" do 
    	attributes_table_for order do
    		row :payed_at
    		row :canceled_at
    		row :shipped_at
    	end
    end
    
    panel "Entrega" do
    	attributes_table_for order do
    		row :delivery_method do 
    			order.delivery_method
    		end
    	end
    	attributes_table_for order do
    		row :delivery_address
    		row :delivery_complement
    		row :delivery_cep
				row :delivery_name
				row :delivery_neighbourhood
				row :delivery_city
				row :delivery_state
    	end if order.delivery_method != 'Retirar na Loja'
    end
    
    panel "Endereço de Cobrança" do
    	attributes_table_for order do
    		row :payment_method do
    			Order.payment_methods.invert[order.payment_method]
    		end
    		attributes_table_for order do 
    			row :payment_address
					row :payment_complement
					row :payment_cep
					row :payment_name
					row :payment_neighbourhood
					row :payment_city
					row :payment_state
    		end if order.payment_method == '1'
    	end
    end
    
    panel "NF" do
    	attributes_table_for order do
    		row :nf_number
    	end
    end
    
    panel "Ítens" do
    	order.order_items.each do |item|
    		attributes_table_for item do
    			row :product_name
    			row :product_subtitle
    			row :product_type
    			row :qty
    			row :price do |i|
						number_to_currency(i.price)
					end
    		end
    	end
    end
	end
	
	index do 
		column :user
		column :created_at
		column :status do |i|
			Order.status_types.invert[i.status]
		end
		column :total do |i|
			number_to_currency(i.the_total)
		end
		default_actions
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys

		f.inputs "Dados de cadastro" do
			f.input :user
		end

		f.inputs "Entrega" do
			f.input :delivery_method, as: :select, collection: Order.delivery_types
			f.input :is_gift, as: :boolean
			f.input :delivery_address
			f.input :delivery_complement
			f.input :delivery_cep
      f.input :delivery_name
      f.input :delivery_neighbourhood
      f.input :delivery_city
      f.input :delivery_state
		end

		f.inputs "Endereço de Cobrança" do
			f.input :payment_method, as: :select, collection: Order.payment_methods
			f.input :payment_address
			f.input :payment_complement
			f.input :payment_cep
			f.input :payment_name
			f.input :payment_neighbourhood
			f.input :payment_city
			f.input :payment_state
		end

		f.inputs "Status" do
			f.input :payed_at, as: :datetime_select
			f.input :canceled_at, as: :datetime_select
			f.input :shipped_at, as: :datetime_select
			f.input :status, as: :select, collection: Order.status_types
		end

		f.inputs "Totais" do
			f.input :total_discount, as: :number
			f.input :total_shipping, as: :number
			f.input :total, as: :number
		end

		f.inputs "NF" do
			f.input :nf_number
		end

		f.inputs "Itens" do
			f.has_many :order_items do |fs|
				fs.input :product_name
				fs.input :product_subtitle, hint: "Ex: 100ml"
				fs.input :product_type
				fs.input :price 
				fs.input :qty
				fs.input :_destroy, :as => :boolean, :required => false, :label=>'Remover ao salvar'
			end
		end

		f.actions
	end

end