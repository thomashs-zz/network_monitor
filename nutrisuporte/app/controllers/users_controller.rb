class UsersController < ApplicationController
	before_filter :authenticate_user!
	require 'brazilian_states'
	def edit
		@user = current_user
	end
	def update
		@user = current_user
		params[:user].delete(:password) if params[:user][:password].empty?
		if @user.update_attributes(params[:user])
			if(session[:after_update_url])
				redirect_to session[:after_update_url], notice: 'Siga sua compra'
				session[:after_update_url] = nil
			else
				redirect_to user_account_path, notice: 'Dados atualizados com sucesso'
			end
		else
			render action: :edit
		end
	end
	def orders
		@orders = current_user.orders.payment_started
	end
	def order
		@order = Order.where(user_id: current_user.id).where(id: params[:id]).first
	end
end