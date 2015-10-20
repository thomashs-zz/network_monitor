class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.integer :product_category_id
      t.string :name
      t.string :subtitle
      t.string :url
      t.integer :relevance
      t.timestamps
    end
  end
end
