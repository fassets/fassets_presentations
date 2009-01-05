#require 'acts_as_asset'
require "acts_as_asset"
class FileAsset < ActiveRecord::Base
  MIME_2_MEDIA = {
    'image/jpeg' => 'image',
    'image/png' => 'image',
    'image/gif' => 'image',   
    'image/tiff' => 'image',
    'video/flv' => 'video',
    'video/x-flv' => 'video'
  }

  acts_as_asset
  has_attached_file :file,
    :url => "/files/:id/:style.:extension",
    :path => ":rails_root/public/uploads/:id/:style.:extension",
    :styles => {
      :thumb => "48x48#",
      :small => "400x300>"
    }
    
  def media_type
    MIME_2_MEDIA[file_content_type] || 'file'
  end    
  def file_updated_at
    Time.now
  end
end
