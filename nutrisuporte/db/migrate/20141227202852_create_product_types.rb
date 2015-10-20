class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.belongs_to :product
      t.integer :qty
      t.integer :weight
      t.string :name
      t.boolean :is_available
      t.timestamps
    end
    add_index :product_types, :product_id
  end
end
