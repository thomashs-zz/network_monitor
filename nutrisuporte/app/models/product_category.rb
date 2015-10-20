class ProductCategory < ActiveRecord::Base
  attr_accessible :product_category_id, :name, :relevance, :subtitle, :url
  acts_as_url :name, sync_url: true, scope: :product_category_id
  belongs_to :product_category
  has_many :product_categories
  validate :max_one_level
  def max_one_level
  	self.errors[:base] << "No máximo 1 nível de hierarquia" if product_category and product_category.product_category
  end
  default_scope order("relevance ASC")
  scope :roots, where(product_category_id: nil)
end