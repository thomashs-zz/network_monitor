class Product < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include PgSearch

  pg_search_scope :regular_search, 
                  :against => [:name,:subtitle],
                  :using => { :tsearch => { :dictionary => 'portuguese', :prefix => true } },
                  :ignoring => :accents
                  
  belongs_to :brand
  belongs_to :product_category
  attr_accessible :description, :is_available, :is_featured, :name, :original_price, :price, :image, :image_cache, :product_types_attributes, :product_category_id, :brand_id, :subtitle, :url, :product_relateds_attributes, :is_new_product
  mount_uploader :image, ProductImageUploader
  acts_as_url :name, sync_url: true
  
  validates_uniqueness_of :name, :url
  validates_presence_of :name, :price, :brand, :product_category, :image
  validates_presence_of :description, :unless => Proc.new{ self.importing }
  
  has_many :product_relateds
  accepts_nested_attributes_for :product_relateds

  validates_numericality_of :price, greather_than: 0
  validates_numericality_of :original_price, greather_than: Proc.new{ self.price }, :if => Proc.new { self.original_price }
  
  has_many :product_types, :dependent => :destroy
  accepts_nested_attributes_for :product_types
  
  has_many :product_subscriptions

  attr_accessor :importing

  validate :at_least_one_type, :unless => Proc.new{ self.importing }
  def at_least_one_type
    self.errors[:base] << "Produto deve ter pelo menos um tipo" if self.product_types.size <= 0
  end
  
  scope :featured, lambda{
    where(is_featured: true)
  }

  scope :deals, lambda{
    where("original_price > price")
  }

  scope :by_product_category, lambda{
    |url|
    where("product_category_id IN (SELECT id FROM product_categories WHERE url = ? OR product_category_id IN (SELECT id FROM product_categories WHERE url = ?))",url,url)
  }
  
  def self.is_there_any_deals
    Product.where("original_price != NULL OR original_price > 0").count > 0
  end
  
  def max_payments(shipping = 0.0,qty = 1.0)
    PaymentCalculator.new((price * qty)+shipping).max_installments
  end

  def max_payments_display
    NutrisuporteSetting.max_payments_display.to_i < max_payments ? NutrisuporteSetting.max_payments_display : max_payments
  end
  
  def payment_price(x,shipping = 0.0,qty = 1)
    PaymentCalculator.new((price*qty)+shipping).installment_price(x)
  end
  
  def best_payment_price
    discount = NutrisuporteSetting.debit_discount > NutrisuporteSetting.boleto_discount ? NutrisuporteSetting.debit_discount : NutrisuporteSetting.boleto_discount
    (price - (price * discount / 100)).round(2)
  end

  def price_str
    number_to_currency(price)
  end

  def best_payment_price_str
    number_to_currency(best_payment_price)
  end 

  def brand_name
    self.brand.name
  end

  def product_category_name
    self.product_category.name
  end

  def is_really_available
    is_available and (product_types.sum(:qty) > 0)
  end

  def is_deal
    original_price.present? and original_price > 0
  end
  
end