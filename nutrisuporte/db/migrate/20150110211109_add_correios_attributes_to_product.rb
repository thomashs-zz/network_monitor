class AddCorreiosAttributesToProduct < ActiveRecord::Migration
  def change
  	add_column :product_types, :height, :integer
  	add_column :product_types, :width, :integer
  	add_column :product_types, :length, :integer
  end
end
