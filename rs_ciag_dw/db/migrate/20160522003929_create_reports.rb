class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.integer :relevance

      t.timestamps null: false
    end
  end
end
