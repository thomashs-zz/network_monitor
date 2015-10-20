class CheckoutController < ApplicationController
	before_filter :authenticate_user!

	#
	# "resumo"
	#
	def index
		begin
			@cart = Hash[session[:cart]]
			@user_addresses = current_user.user_addresses
			@products = ProductType.where("id in (?)",@cart.keys.map{ |i| i.to_i })
			@shipping_option = ShippingCalculator.new(@cart).calculate_for_cep(session[:cep]).select{ |i| i.name == session[:shipping_option] }.first
		rescue
			redirect_to root_path, alert: 'Seu carrinho está vazio!'
		end
	end

	def change_address_and_return
		session[:after_update_url] = checkout_path
		redirect_to edit_user_account_path, notice: "Adicione o endereço desejado e clique em 'Alterar Dados'"
	end

	def add_address_and_return
		session[:after_update_url] = checkout_payment_path
		redirect_to edit_user_account_path, notice: "Adicione o endereço desejado e clique em 'Alterar Dados'"
	end

	def save_user_address_id
		session[:user_address_id] = params[:user_address_id]
		render text: ""
	end

	#
	# payment 
	#
	def payment
		require 'moip'
		@moip = Moip::Checkout.new
		begin
			@order = Order.build_for_checkout(current_user.id,Hash[session[:cart]],session[:shipping_option],session[:user_address_id])
		rescue
			redirect_to root_path, alert: 'Seu carrinho está vazio!'
		end
	end

	#
	# deposit
	#
	def pay_with_deposit
		order = Order.build_for_checkout(current_user.id,Hash[session[:cart]],session[:shipping_option],session[:user_address_id],params[:payments],"3")
		render json: (order.save ? true : order.errors.full_messages)
	end

	#
	# ajax call to get moip token
	#
	def get_token
		
		require 'moip'
		@order = Order.build_for_checkout(current_user.id,Hash[session[:cart]],session[:shipping_option],session[:user_address_id], params[:payments],params[:payment_method],params[:payment_user_address_id])
		
		if @order.save
			@moip = Moip::Checkout.new
			invoice = {
			  :razao => "NutriSuporte Compra #{@order.the_id}",
			  :id => @order.id.to_s,
			  :total => @order.the_total.to_s, # the_total is important! see order.rb
			  :acrescimo => '0.00',
			  :desconto => '0.00',
			  :cliente => {
			    :id => current_user.id,
			    :nome => current_user.name,
			    :email => current_user.email,
			    :logradouro => @order.payment_address,
			    :complemento => @order.payment_complement,
			    :bairro => @order.payment_neighbourhood,
			    :cidade => @order.payment_city,
			    :uf => @order.payment_state,
			    :cep => @order.payment_cep,
			    :telefone => current_user.phone
			  },
			  :parcelamentos => NutrisuporteSetting.parcelamentos
			}
			render json: @moip.get_token(invoice)
		else
			render json: @order.errors.full_messages
		end
	end

end