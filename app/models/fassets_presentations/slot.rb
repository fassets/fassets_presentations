module FassetsPresentations
  class Slot 
    def initialize(name, content, in_template=true)
      @name = name
      @content = content || {}
      @in_template = in_template
    end
    def in_template?
      @in_template
    end
    def name
      @name
    end
    def [](key)
      @content[key]
    end
    def asset
      return nil if self['asset_id'].blank?
      begin
        FassetsCore::Asset.find(self['asset_id'])    
      rescue Exception => e
        nil
      end
    end
  end
end
