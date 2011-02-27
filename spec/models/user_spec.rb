require 'spec_helper'

describe User do
  fixtures :users

  before(:each) do
    @valid_attributes = {
      :login => "testuser",
      :email => "test@example.com",
      :password => "thisisatest",
      :password_confirmation => "thisisatest"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

  it "should validate for unique login names" do
    u = User.new(@valid_attributes)
    u.login="agent"
    u.should_not be_valid
  end
end
