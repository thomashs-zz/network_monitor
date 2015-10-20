class CreateSliderHomeItems < ActiveRecord::Migration
  def change
    create_table :slider_home_items do |t|
      t.string :title
      t.string :subtitle
      t.text :description
      t.decimal :price
      t.string :price_subtitle
      t.integer :relevance
      t.text :url
      t.string :background_image
      t.string :image
      t.boolean :is_available
      t.timestamps
    end
  end
end
