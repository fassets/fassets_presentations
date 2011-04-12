Given /^I am logged in as user "([^"]*)"$/ do |login|
  @user = User.find_by_login(login)
  @user.should_not be_nil
end

Given /^this user has no assets on the tray$/ do
  @user.tray_positions.should == []
end

When /^I add the following items to the tray:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |hash|
    a = hash[:type].constantize.new({:asset_attributes => {:name => hash[:name]}})
    a.asset.user = @user
    a.save!
  end
end

Then /^I should see these (\d+) items on the tray named:$/ do |count, table|
  # table is a Cucumber::Ast::Table
  @user.tray_positions.size.should == count.to_i

  table.hashes.each do |hash|
    @user.tray_positions.should contain(hash[:name])
  end
end
