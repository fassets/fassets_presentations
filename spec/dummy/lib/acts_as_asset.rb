module ActiveRecord
  module Acts
    module Asset
      def self.included(base)
        base.extend(ClassMethods)  
      end
      module ClassMethods
        def acts_as_asset
          has_one :asset, :as => :content, :dependent => :destroy
          accepts_nested_attributes_for :asset
          include ActiveRecord::Acts::Asset::InstanceMethods
        end
      end
      module InstanceMethods
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
          def put_on_tray
            tray_positions.create(:user_id => self.user_id)
          end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Asset)
