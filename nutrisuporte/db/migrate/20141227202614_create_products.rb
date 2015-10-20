class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :brand
      t.belongs_to :product_category
      t.string :name
      t.string :url
      t.string :subtitle
      t.text :description
      t.decimal :price
      t.decimal :original_price
      t.boolean :is_available
      t.boolean :is_featured
      t.string :image
      t.timestamps
    end
    add_index :products, :brand_id
    add_index :products, :product_category_id
    add_index :products, :url
  end
end
