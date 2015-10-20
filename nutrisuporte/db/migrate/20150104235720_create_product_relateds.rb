class CreateProductRelateds < ActiveRecord::Migration
  def change
    create_table :product_relateds do |t|
      t.belongs_to :product
      t.integer :related_product_id

      t.timestamps
    end
    add_index :product_relateds, :product_id
  end
end
