class OrderMailer < ActionMailer::Base
	default from: "nutrisuporte@nutrisuporte.com.br"
	def notify(order)
  	@order = order
    @user = order.user
  	mail(:subject => "Compra #{@order.the_id} iniciada",:to => @user.email, :bcc => "nutrisuporte@nutrisuporte.com.br")
  end
  def confirm(order)
  	@order = order
    @user = order.user
  	mail(:subject => "Compra #{@order.the_id} confirmada",:to => @user.email)
  end
  def sent(order)
    @order = order
    @user = order.user
    mail(:subject => "Compra #{@order.the_id} - Frete em andamento",:to => @user.email)
  end
  def cancel(order)
  	@order = order
    @user = order.user
  	mail(:subject => "Compra #{@order.the_id} cancelada",:to => @user.email)
  end
end