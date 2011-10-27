Then /^the asset should show the "([^"]*)" icon$/ do |type|
  @last_asset.media_type.should == type
end