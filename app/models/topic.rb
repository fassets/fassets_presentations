class Topic < ActiveRecord::Base
  acts_as_nested_set
  has_many :slides, :order => :position
end
