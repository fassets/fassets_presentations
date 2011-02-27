require "acts_as_asset"
class Url < ActiveRecord::Base
  URL_2_MEDIA = [
    [/http:\/\/xmendel\.imis\.uni-luebeck\.de.*/, "XMendeL"],
    [/http:\/\/(www\.)?youtube\.com\/watch\?.*v=(\w*)(\&.*)*/, "YouTube"]
  ]
  acts_as_asset
  
  def media_type
    URL_2_MEDIA.each{|p| break p.last if self.url =~ p.first }
  end
  def regexp
    URL_2_MEDIA.each{|p| break p.first if self.url =~ p.first }
  end
end