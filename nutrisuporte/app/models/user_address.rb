class UserAddress < ActiveRecord::Base
  belongs_to :user
  attr_accessible :address, :cep, :city, :is_default, :name, :neighbourhood, :state, :number, :complement
  validates_presence_of :address, :cep, :city, :name, :neighbourhood, :state
  validate :at_least_one_default
  def at_least_one_default
  	if self.is_default == false and self.user.user_addresses.where(is_default: true).count == 0
  	 	self.errors[:base] << "Deve ter um endereço default por usuário"
  	end
  end
  validate :max_one_default_address
  def max_one_default_address
  	if self.is_default and self.user and self.user.user_addresses.count > 0 and self.user.user_addresses.where(is_default: true).where("id != ?",self.id).count > 0
  		self.errors[:base] << "No máximo um endereço padrão por usuário" 
  	end
  end
  before_destroy :at_least_one_address
  def at_least_one_address
    if self.user.user_addresses.count == 0
      false
    end
  end
end