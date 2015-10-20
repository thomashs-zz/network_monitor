# encoding: utf-8

class BannerHomeUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  version :thumb do
    process :resize_to_fit => [300, 300]
  end

  after :store, :delete_old_tmp_file

  # remember the tmp file
  def cache!(new_file)
    super
    @old_tmp_file = new_file
  end
  
  def delete_old_tmp_file(dummy)
    begin
      @old_tmp_file.try :delete
    rescue
      # do nothing
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
