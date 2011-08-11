class Topic < ActiveRecord::Base
  acts_as_tree :order => :position
  has_many :slides, :order => :position
end
