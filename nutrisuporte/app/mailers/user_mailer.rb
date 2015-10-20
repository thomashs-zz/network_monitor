class UserMailer < ActionMailer::Base
	default from: "nutrisuporte@nutrisuporte.com.br"
	def welcome(user)
		@user = user
		mail(subject: "Cadastro Nutri Suporte", to: user.email)
	end
end