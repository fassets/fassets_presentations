require 'acts_as_asset'
class Presentation < ActiveRecord::Base
  acts_as_asset
  has_many :frames, :order => :position

  validates_presence_of :title,:template
  
  def media_type
    "Presentation"
  end
end
