class CreateReportQueries < ActiveRecord::Migration
  def change
    create_table :report_queries do |t|
      t.belongs_to :report, index: true, foreign_key: true
      t.string :title
      t.string :subtitle
      t.text :query
      t.string :report_type
      t.integer :relevance
      
      t.timestamps null: false
    end
  end
end
