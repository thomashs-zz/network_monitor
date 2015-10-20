class ProductSubscription < ActiveRecord::Base
  belongs_to :product
  attr_accessible :email, :name, :product_id
  validates_uniqueness_of :email, :scope => :product_id
end
