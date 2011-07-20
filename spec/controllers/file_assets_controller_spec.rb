require 'spec_helper'

describe FileAssetsController do
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
      assigns(:content).class.should == FileAsset
    end
  end

  describe "get actions" do
    let(:file) { double(FileAsset, :id => 1, :format => "png") }
    before(:each) do
      my_f = file
      controller.stub!(:find_content) {}
      controller.instance_eval { @content = my_f }
    end

    it "should redirect into the thumb folder" do
      get 'thumb', :id => file.id, :format => file.format
      response.should redirect_to("#{root_path}public/uploads/#{file.id}/thumb.#{file.format}")
    end

    it "should redirect into the preview folder" do
      get 'preview', :id => file.id, :format => file.format
      response.should redirect_to("#{root_path}public/uploads/#{file.id}/small.#{file.format}")
    end

    it "should redirect into the original image folder" do
      get 'original', :id => file.id, :format => file.format
      response.should redirect_to("#{root_path}public/uploads/#{file.id}/original.#{file.format}")
    end

    it "should be successful and render partials" do
      get 'show', :id => file.id
      assigns(:content).should_not be_nil
      response.should be_success
      response.should render_template("layouts/application")
      response.should render_template("assets/show")
    end
  end
end