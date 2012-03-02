require 'acts_as_asset'
module FassetsPresentations
  class Presentation < ActiveRecord::Base
    acts_as_asset
    after_create :create_root_frame
    has_one :root_frame, :class_name => 'Frame', :readonly => true, :dependent => :destroy
    validates_presence_of :title,:template

    def root_frame=(value)
      raise "can't overwrite root frame"
    end

    def media_type
      "Presentation"
    end

    def to_jq_upload
      {
        "edit_box_url" => "/edit_box/"+id.to_s,
        "content_type" => "Presentation" 
      }
    end
    protected
    def create_root_frame
      Frame.create!(:title => root_frame_title, :template => "title", :presentation_id => id, :position => 1)
    end

    def root_frame_title
      # this is a user-visible string, we might want to translate it one day
      # since it’s in the parent selection for frames, it might be called "none" to indicate a no parent situation
      # also don’t forget to write a migraton to change the titles for existing presentations
      "root_frame"
    end
  end
end
