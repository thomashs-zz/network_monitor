class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :ip
      t.string :community
      t.integer :frequency
      t.timestamps
    end
  end
end
