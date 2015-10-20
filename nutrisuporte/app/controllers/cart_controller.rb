class CartController < ApplicationController
	
	before_filter :set_cart_session, except: [:clear_cart]
	SESSION_CART_ID = :cart
	
	def index
		@items = session[SESSION_CART_ID]
		@products = ProductType.where("id IN (?)",@cart.keys.map{ |i| i.to_i })
	end	

	def add
		session[SESSION_CART_ID][params[:product_type_id]] ||= 0
		session[SESSION_CART_ID][params[:product_type_id]] += params[:qty].to_i
		redirect_to cart_path, notice: "Item adicionado ao carrinho"
	end
	
	def set_qty
		session[SESSION_CART_ID][params[:product_type_id]] = params[:qty].to_i
		render text: ""
	end

	def remove
		session[SESSION_CART_ID].delete(params[:product_type_id])
		redirect_to cart_path, notice: "Item removido com sucesso"
	end

	def shipping_selector
		session[:cep] = params[:cep]
		calculator = ShippingCalculator.new(@cart)
		if calculator.exceeds_weight?
			render 'shipping_weight_warning', layout: false
		else
			@options = calculator.calculate_for_cep(params[:cep])
			render layout: false
		end
	end

	def save_shipping_option
		session[:shipping_option] = params[:shipping_option]
		render text: ""
	end

	def clear_cart
		session[SESSION_CART_ID].clear
		redirect_to cart_path, notice: "Carrinho esvaziado"
	end

	private
	def set_cart_session
		session[SESSION_CART_ID] ||= {}
		@cart = Hash[session[SESSION_CART_ID]]
	end

end