class TrayPosition < ActiveRecord::Base
  belongs_to :asset, :include => :content
  belongs_to :user
  belongs_to :clipboard, :polymorphic => true
  validates_associated :asset, :clipboard
  validates_presence_of :position
  #validates_uniqueness_of :asset_id, :scope => [:user_id], :message => "Asset is already on tray!"
end
