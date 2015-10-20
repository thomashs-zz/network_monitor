class CreateUserAddresses < ActiveRecord::Migration
  def change
    create_table :user_addresses do |t|
      t.belongs_to :user
      t.boolean :is_default
      t.string :name
      t.string :address
      t.string :number
      t.string :complement
      t.string :neighbourhood
      t.string :cep
      t.string :city
      t.string :state
      t.timestamps
    end
    add_index :user_addresses, :user_id
  end
end