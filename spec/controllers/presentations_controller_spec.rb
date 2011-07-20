require 'spec_helper'

describe PresentationsController do
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end

  before(:each) do
    # mock up an authentication in the underlying warden library
    request.env['warden'] = mock(Warden, :authenticate => mock_user,
                                 :authenticate! => mock_user)
  end

  describe "GET 'new'" do
    it "should be successful and render all partials" do
      get 'new'
      response.should be_success
      response.should render_template("assets/new")
      assigns(:content).class.should == Presentation
    end
  end
end
