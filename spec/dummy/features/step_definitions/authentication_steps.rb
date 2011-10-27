Given /^no User$/ do
  @current_user = nil
end

When /^I provide login as "([^"]*)" with password "([^"]*)"$/ do |login, password|
  unless login.blank?
    visit new_user_session_path
    fill_in "Email", :with => email
    fill_in "Password", :with => password
    click_button "Sign In"
  end
end

Then /^I should be authenticated$/ do
  @current_user.should_not be_nil
end
