# encoding: UTF-8
class ProductsController < ApplicationController

	def show
		@product = Product.find_by_url(params[:slug])
	end

	def category
		@products_count = Product.by_product_category(params[:slug]).count
		@current_category = ProductCategory.find_by_url(params[:slug])
		@products = (Product.by_product_category(params[:slug])).page(params[:page])
	end

	def brand
		@brand = Brand.find_by_url(params[:slug])
		@products_count = Product.where(brand_id: @brand.id).count
		@products = Product.where(brand_id: @brand.id).page(params[:page])
	end

	def deals
		@products_count = Product.deals.count
		@products = Product.deals.page(params[:page])
	end

	def search 
		@products_count = Product.regular_search(params[:busca].to_s).count
		@products = Product.regular_search(params[:busca]).page(params[:page])
	end

	def auto_complete_search
		render json: (Product.regular_search(params[:term])).to_json(only: [:name,:subtitle,:slug,:image,:url], methods: [:brand_name,:product_category_name,:price_str])
	end
	
	def shipping_calculator
		#begin
			session[:cep] = params[:cep].to_s
			@options = ProductType.find(params[:product_type_id]).calculate_shipping(params[:cep],params[:qty])
			render layout: false
		#rescue 
		#	render text: "Não foi possível calcular o frete"
		#end
	end

	def total_calculator
		begin
			@product = Product.joins(:product_types).where("product_types.id = ?",params[:product_type_id]).first
			@shipping_total = BigDecimal.new(params[:shipping_total])
			@qty = params[:qty].to_i
			@max_payments = @product.max_payments(@shipping_total,@qty)
			render layout: false
		rescue
			render text: "Não foi possível calcular o total das parcelas"
		end
	end

	def product_subscription
		ProductSubscription.create(name: params[:name], email: params[:email], product_id: params[:product_id])
		redirect_to product_path(params[:slug]), notice: "Cadastro realizado com sucesso"
	end

end