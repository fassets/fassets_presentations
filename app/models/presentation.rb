require 'acts_as_asset'
class Presentation < ActiveRecord::Base
  acts_as_asset
  has_many :slides, :order => :position
  
  def media_type
    "Presentation"
  end
end
