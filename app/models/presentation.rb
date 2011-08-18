require 'acts_as_asset'
class Presentation < ActiveRecord::Base
  acts_as_asset
  after_create :create_root_frame
  has_many :frames, :order => :position

  validates_presence_of :title,:template
  
  def media_type
    "Presentation"
  end
  def create_root_frame
    root_frame = Frame.new(:title => "root_frame", :template => "title", :presentation_id => id, :position => 1)
    root_frame.save
  end
end
