class BlogPost < ActiveRecord::Base
  attr_accessible :content, :image, :is_draft, :url, :title, :image_cache
  validates_presence_of :content, :image, :title
  validates_uniqueness_of :title
  acts_as_url :title, :sync_url => true
  mount_uploader :image, BlogImageUploader
  scope :published, where(is_draft: false)
end