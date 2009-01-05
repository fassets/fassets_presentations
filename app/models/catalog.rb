class Catalog < ActiveRecord::Base
  has_many :facets, :include => :labels, :dependent => :destroy
  has_many :classifications, :dependent => :destroy
  has_many :assets, :through => :classifications

  validates_presence_of :title
  
  
  
  #has_permalink :title
  
  #def to_param
  #  "#{id}-#{permalink}"
  #end
end