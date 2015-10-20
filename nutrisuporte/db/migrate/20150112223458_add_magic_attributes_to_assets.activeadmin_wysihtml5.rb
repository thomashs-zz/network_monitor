# This migration comes from activeadmin_wysihtml5 (originally 20130124143200)
class AddMagicAttributesToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :storage_width, :integer
    add_column :assets, :storage_height, :integer
    add_column :assets, :storage_aspect_ratio, :float
    add_column :assets, :storage_depth, :integer
    add_column :assets, :storage_format, :string
    add_column :assets, :storage_mime_type, :string
    add_column :assets, :storage_size, :string
  end
end
