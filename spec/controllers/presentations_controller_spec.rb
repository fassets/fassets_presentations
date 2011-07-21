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

  describe "GET 'show'" do
    let(:presentation) { double(Presentation, :id => 1) }

    context "with working presentation" do
      before(:each) do
        my_p = presentation
        controller.stub!(:find_content) {}
        controller.instance_eval { @content = my_p }
      end

      it "should be successful and render partials" do
        get 'show', :id => presentation.id
        assigns(:presentation).should_not be_nil
        response.should be_success
        response.should render_template("layouts/slide")
        response.should render_template("presentations/show")
      end
    end

    it "should redirect to root with error message on error" do
      get 'show', :id => presentation.id
      response.should redirect_to(root_path)
      request.flash[:error].should =~ /not found$/
    end
  end
end
