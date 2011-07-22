require 'rspec' # needed for rcov

shared_examples_for "Every AssetsController" do
  include_examples "every authenticated controller"

  def setup_content
    my_a = asset
    my_a.stub!(:destroy)
    controller.stub!(:find_content) {}
    controller.instance_eval { @content = my_a }
  end

  describe "GET 'new'" do
    it "should be successful and render all partials" do
      get 'new'
      response.should be_success
      response.should render_template("assets/new")
    end
  end

  context "actions with assets" do
    before(:each) do
      setup_content
    end

    it "should render the edit template" do
      get 'edit', :id => asset.id
      response.should be_success
      response.should render_template("assets/edit")
    end

    describe "GET 'show'" do
      it "should assign content" do
        get 'show', :id => asset.id
        assigns(:content).should_not be_nil
      end
    end

    describe "DELETE asset" do
      it "should delete the asset and show a notice" do
        delete "destroy", :id => asset.id
        assigns(:content).should respond_to(:destroy).with(0).arguments
        response.should redirect_to root_path
        request.flash[:notice].should =~ /^Asset has been deleted!$/
      end
    end
  end

  context "actions without assets" do
    it "should redirect to root with error message on error" do
      get 'show', :id => asset.id
      response.should redirect_to(root_path)
      request.flash[:error].should =~ /not found$/
    end

    it "should delete the asset and show a notice" do
      delete "destroy", :id => asset.id
      response.should redirect_to(root_path)
      request.flash[:error].should =~ /not found$/
    end
  end
end