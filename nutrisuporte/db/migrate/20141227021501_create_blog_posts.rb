class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.string :url
      t.text :content
      t.string :image
      t.boolean :is_draft
      t.timestamps
    end
    add_index :blog_posts, :url
  end
end
