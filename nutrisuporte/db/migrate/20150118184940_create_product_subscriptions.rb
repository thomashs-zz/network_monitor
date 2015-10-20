class CreateProductSubscriptions < ActiveRecord::Migration
  def change
    create_table :product_subscriptions do |t|
      t.belongs_to :product
      t.string :name
      t.string :email

      t.timestamps
    end
    add_index :product_subscriptions, :product_id
  end
end
