class SliderHomeItem < ActiveRecord::Base
  attr_accessible :description, :price, :price_subtitle, :subtitle, :title, :url, :relevance, :background_image, :image, :is_available, :image_cache, :background_image_cache, :display_picture_only
  validates_presence_of :description, :title, :url, :relevance, :image, :unless => Proc.new{ self.display_picture_only }
  validates_presence_of :background_image
  mount_uploader :image, SliderImageUploader
  mount_uploader :background_image, SliderBackgroundImageUploader
  scope :available, lambda{ where(is_available: true) }
end
