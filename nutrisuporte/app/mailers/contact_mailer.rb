class ContactMailer < ActionMailer::Base
  default from: "nutrisuporte@nutrisuporte.com.br"
  def contact(contact_form)
  	@cf = contact_form
  	mail(:subject => "[CONTATO VIA WEBSITE] #{contact_form.name}",:to => "contato@nutrisuporte.com.br", :reply_to => contact_form.email)
  end
end
