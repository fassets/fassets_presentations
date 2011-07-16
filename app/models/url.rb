require "acts_as_asset"
class Url < ActiveRecord::Base
  validates_presence_of :url
  validates_format_of :url, :with => /^(#{URI::regexp(%w(http https))})$/, :message => "is invalid"
  URL_2_MEDIA = [
    [/http:\/\/xmendel\.imis\.uni-luebeck\.de.*/, "XMendeL"],
    [/http:\/\/(www\.)?youtube\.com\/watch\?.*v=(\w*)(\&.*)*/, "Youtube"],
    [/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,"URL"]
  ]
  acts_as_asset
  
  def media_type
    URL_2_MEDIA.each{|p| break p.last if self.url =~ p.first }
  end
  def regexp
    URL_2_MEDIA.each{|p| break p.first if self.url =~ p.first }
  end
end
