class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.decimal :total
      t.decimal :total_shipping
      t.decimal :total_discount
      t.string :delivery_method
      t.string :status, default: '1'
      t.datetime :canceled_at
      t.datetime :payed_at
      t.datetime :shipped_at
      t.string :payment_method
      t.string :nf_number
      t.boolean :is_gift
      t.string :payment_name
      t.string :payment_address
      t.string :payment_complement
      t.string :payment_neighbourhood
      t.string :payment_cep
      t.string :payment_city
      t.string :payment_state
      t.string :delivery_name
      t.string :delivery_address
      t.string :delivery_complement
      t.string :delivery_neighbourhood
      t.string :delivery_cep
      t.string :delivery_city
      t.string :delivery_state
      t.timestamps
    end
    add_index :orders, :user_id
  end
end