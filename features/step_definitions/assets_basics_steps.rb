When /^I create a "([^"]*)" named "([^"]*)"$/ do |asset, name|
  a = asset.constantize.new({:asset_attributes => {:name => name}})
  a.asset.user=@user
  a.save!
  @last_asset = a
end

Then /^my tray should contain a "([^"]*)"$/ do |asset|
  found = false
  @user.tray_positions.each do |item|
    found = true if item.asset.content_type == asset
  end
  found.should == true
end

When /^I set the "([^"]*)" attribute of the last asset to "([^"]*)"$/ do |attr, value|
  @last_asset.write_attribute(attr, value)
end

