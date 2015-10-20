class ContactController < ApplicationController
	def new
		@contact_form = ContactForm.new
	end
	def create
		@contact_form = ContactForm.new(params)
		if @contact_form.valid?
			@contact_form.send_message
			flash[:notice] = "Mensagem enviada."
			redirect_to action: :new
		else
			redirect_to action: :index
		end
	end
end