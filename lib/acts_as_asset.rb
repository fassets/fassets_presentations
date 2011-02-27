module ActiveRecord
  module Acts
    module Asset
      def self.included(base)
        base.extend(ClassMethods)  
      end
      module ClassMethods
        def acts_as_asset
          has_one :asset, :as => :content, :dependent => :destroy
          after_save :save_asset
          include ActiveRecord::Acts::Asset::InstanceMethods
        end
      end
      module InstanceMethods
        def asset_attributes=(attributes)
          if asset
            asset.attributes = attributes
          else
            build_asset(attributes)
          end
        end
        def name
          asset.name
        end
        def class_underscore
          self.class.to_s.underscore
        end
        def media_type
          "generic"
        end
        def icon
          "/images/#{media_type}.png"
        end
        protected
          def save_asset
            asset.save(false)
          end
          def put_on_tray
            tray_positions.create(:user_id => self.user_id)
          end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Asset)
