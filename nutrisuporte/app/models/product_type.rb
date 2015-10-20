# encoding: UTF-8
class ProductType < ActiveRecord::Base

  belongs_to :product
  attr_accessible :name, :qty, :weight, :height, :width, :length
  validates_presence_of :name, :qty, :weight, :width, :height, :length
  validates_uniqueness_of :name, scope: :product_id
  validates_numericality_of :qty, :weight, :weight, :height, :length, greather_than: 0
  scope :available, where("qty > 0")

  #
  # sum of dimensions validation
  # see: http://www.correios.com.br/para-voce/precisa-de-ajuda/limites-de-dimensoes-e-de-peso
  #
  validate :sum_of_dimensions_validation
  def sum_of_dimensions_validation
  	self.errors[:base] << "Soma das dimensões do produto não pode superar 200cm" if (self.height + self.width + self.length) > 200
  end
  
  #
  # calculates shipping price for this item
  #
  def calculate_shipping(cep,qty)
    h = {}
    h[self.id.to_s] = qty
    ShippingCalculator.new(h).calculate_for_cep(cep)
  end
  
end