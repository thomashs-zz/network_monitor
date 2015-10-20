class ShippingCalculator
	attr_accessor :items
	attr_accessor :total_weight

	def initialize(items)
		self.items = items
		calculate_weight
	end

	def calculate_weight
		self.total_weight = 0.0
		self.items.each do |product_type_id,qty|
			self.total_weight += ProductType.find(product_type_id).weight * qty.to_i
		end
	end

	def exceeds_weight?
		total_weight >= NutrisuporteSetting.max_weight
	end

	def calculate_for_cep(cep)
		puts self.items.inspect
		options = []
		
		products_types = ProductType.where("id IN (?)",items.keys)
		
		pacote = Correios::Frete::Pacote.new
		
		products_types.each do |product_type|
			# cria pacotes
			self.items[product_type.id.to_s].to_i.times do
				item = Correios::Frete::PacoteItem.new peso: (product_type.weight / 1000.0), comprimento: product_type.length, largura: product_type.width, altura: product_type.height
				pacote.adicionar_item(item)
			end
		end

		puts "Pacote com #{pacote.itens.size} itens" 
		puts "Dimensões #{pacote.altura} x #{pacote.largura} x #{pacote.comprimento}"
		puts "Peso #{pacote.peso}"
		
		items_to_calculate = [:sedex, :pac]

		the_hash = { cep_origem: NutrisuporteSetting.cep_origem, cep_destino: cep, encomenda: pacote }

		if NutrisuporteSetting.correios_cod_empresa.present?
			the_hash[:codigo_empresa] = NutrisuporteSetting.correios_cod_empresa
			the_hash[:senha] = NutrisuporteSetting.correios_senha
			items_to_calculate = [:pac_com_contrato,:e_sedex,:sedex_com_contrato_1]
		end
		
		#  creates "correios" calculator
    shipping = Correios::Frete::Calculador.new(the_hash)

    # calls correios
    services = shipping.calcular(*items_to_calculate)

    # fills options
    services.each do |k,v|
      if v.valor.to_i > 0
    	  options << ShippingOption.new(price: v.valor,
    		  														days: v.prazo_entrega,
    			  													name: v.nome)
      end
    end

    # calculates motoboy total
    begin
    	calculator = MotoboyCalculator.new(cep)
    	if NutrisuporteSetting.motoboy_available and calculator.calculate
	    	options << ShippingOption.new(price: calculator.price, days: calculator.days, name: "Motoboy")
			end
    rescue 
    	# do nothing
    end

    # adds option to get the product directly at the store.
    if NutrisuporteSetting.get_on_store_available
    	options << ShippingOption.new(price: 0.0, days: 0, name: "Retirar na Loja",message: NutrisuporteSetting.get_on_store_message)
    end
    
    return options

	end

	# def calculate_for_cep(cep)
	# 	options = []
	# 	products = ProductType.where("id IN (?)",items.keys)
	# 	products.each do |product|
	# 		product_options = product.calculate_shipping(cep)
	# 		# updates price based on quantity
	# 		product_options.each { |option| option.price = option.price * self.items[product.id.to_s] }
	# 		# creates options array
	# 		if options.empty?
	# 			options = product_options
	# 		else
	# 			options.each do |option|
	# 				product_option = product_options.select{ |i| i.name == option.name }.first
	# 				option.price += product_option.price
	# 				option.days = product_option.days if product_option.days > option.days
	# 			end
	# 		end
	# 	end
	# 	return options 
	# end

end