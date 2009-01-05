class Classification < ActiveRecord::Base
  belongs_to :catalog
  has_many :labelings, :dependent => :destroy
  has_many :labels, :through => :labelings
  belongs_to :asset, :counter_cache => true

end
