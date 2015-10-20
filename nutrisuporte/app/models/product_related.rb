class ProductRelated < ActiveRecord::Base
  belongs_to :product
  belongs_to :related, :class_name => "Product", :foreign_key => "related_product_id"
  attr_accessible :related_product_id, :product_id, :related_product_id
end