class Brand < ActiveRecord::Base
  attr_accessible :is_available, :name, :url, :image, :image_cache
  validates_presence_of :name, :image
  validates_uniqueness_of :name
  mount_uploader :image, BrandImageUploader
  acts_as_url :name, :sync_url => true
  scope :available, where(is_available: true)
end
