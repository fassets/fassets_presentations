require "acts_as_asset"
class Url < ActiveRecord::Base
  URL_2_MEDIA = [
    [/http:\/\/xmendel\.imis\.uni-luebeck.de.*/, "XMendeL"]
  ]
  acts_as_asset
  
  def media_type
     pattern = URL_2_MEDIA.select{|p| self.url =~ p.first}.first
     pattern ? pattern.last : "URL"
  end
end
