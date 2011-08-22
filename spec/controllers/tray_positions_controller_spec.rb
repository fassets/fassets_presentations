require 'spec_helper'

describe TrayPositionsController do
  before(:each) do
    @mock_user = mock_model(User, {:tray_positions => double(TrayPosition, {:maximum => 1})}).as_null_object
  end

  include_examples "every authenticated controller"

  describe "POST 'create'" do
    before(:each) do
      request.env["HTTP_REFERER"] = "http://test.host/"
      post 'create', { :user_id => 1, :tray_position => {:clipboard_type => 'something'} }
    end
    it { response.should redirect_to(:back) }
    it "should capitalize the clipboard_type attribute" do
      TrayPosition.all.last.clipboard_type.should eq('something'.capitalize)
    end
  end
end
