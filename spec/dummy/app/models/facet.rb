class Facet < ActiveRecord::Base
  LABEL_ORDER = [["ascending", "value ASC, caption ASC"],
                 ["descending", "value DESC, caption DESC"],
                 ["manual", "position"]]
  
  belongs_to :catalog
  has_many :labels, :dependent => :destroy
  validates_presence_of :caption

  scope :exclude, lambda {|ids|
    { :conditions => ["id NOT IN(?)", ids]}
  }
      
  def ordered_labels
    #self.labels.find(:all, :order => self.label_order)
	self.labels.order(self.label_order)
  end
end
