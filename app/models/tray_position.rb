class TrayPosition < ActiveRecord::Base
  belongs_to :asset, :include => :content
  belongs_to :user
end
