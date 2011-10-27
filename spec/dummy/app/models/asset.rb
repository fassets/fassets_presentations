class Asset < ActiveRecord::Base
  belongs_to :user
  belongs_to :content, :polymorphic => true
  has_many :classifications, :dependent => :destroy
  has_many :labelings, :through => :classifications
  has_many :tray_positions, :dependent => :destroy

  validates_associated :content
  validates_presence_of :name,:content_type
 
  after_create :put_on_tray

  def publish=(test)
  end
  def published=(test)
  end
  def published
    1
  end
  def self.filter(filter)
    options = {:select => "assets.*", :order => "name"}
    unless filter.empty?
      options[:joins] = "LEFT OUTER JOIN labelings ON labelings.classification_id=classifications.id"
      options[:conditions] = filter.to_condition
      options[:group] = "assets.id HAVING COUNT(label_id)=#{filter.size}"
    end
    all options
  end

  def self.count_for_labels(filter)
    options = {:include => [:labelings], :group => "label_id"}
    unless filter.empty?
      options[:conditions] = "assets.id IN(
          SELECT DISTINCT assets.id 
            FROM assets 
              LEFT OUTER JOIN classifications ON (assets.id = classifications.asset_id) 
              LEFT OUTER JOIN labelings ON (labelings.classification_id=classifications.id) 
            WHERE (#{filter.to_condition}) 
            GROUP BY assets.id 
          HAVING COUNT(label_id)=#{filter.size})"
      filter.to_condition
    end
    count options
  end

  def put_on_tray
    tray_positions.create(:user_id => user.id, :asset_id => id, :position => user.tray_positions.maximum(:position) ? user.tray_positions.maximum(:position)+1 : 1)
  end
end
