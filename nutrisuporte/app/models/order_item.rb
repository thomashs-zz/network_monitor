class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  attr_accessible :product_name, :product_subtitle, :product_type, :product_id, :qty, :price, :order, :order_id
  validates_presence_of :product_name, :product_type, :qty, :price, :order
  attr_accessor :importing
  validates_presence_of :product_id, :unless => Proc.new{ self.importing }
end
