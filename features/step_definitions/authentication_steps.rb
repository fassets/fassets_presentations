Given /^no User$/ do
  @current_user = nil
end

When /^I provide login as "([^"]*)" with password "([^"]*)"$/ do |login, password|
  @current_user = User.authenticate(login, password)
end

Then /^I should be authenticated$/ do
  @current_user.should_not be_nil
end
