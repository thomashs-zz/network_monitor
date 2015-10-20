class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.belongs_to :order
      t.belongs_to :product
      t.integer :qty
      t.decimal :price
      t.string :product_name
      t.string :product_subtitle
      t.string :product_type
      t.timestamps
    end
    add_index :order_items, :order_id
    add_index :order_items, :product_id
  end
end
