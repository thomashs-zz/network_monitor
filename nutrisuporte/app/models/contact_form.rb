class ContactForm
	include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  attr_accessor :name, :email, :phone, :message, :utf8, :authenticity_token, :controller, :action, :commit

  validates :name, :email, :phone, :message, :presence => true
  validates :email, :format => { :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
	
  def persisted?
    false
  end

  def send_message
    ContactMailer.contact(self).deliver
  end
end