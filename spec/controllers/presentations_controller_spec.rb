require 'spec_helper'

describe PresentationsController do
  let(:asset) { double(Presentation, :id => 1) }
  let(:create_params) do
      {"presentation" => {:title => "Test", :template => "test_template"}}
     end
  include_examples "Every AssetsController"

  it "should assign content with Presentation class" do
    get 'new'
    assigns(:content).class.should == Presentation
  end

  context "actions with assets" do
    before(:each) { setup_content }
    describe "GET 'show'" do
      it "should be successful and render partials" do
        get 'show', :id => asset.id
        assigns(:presentation).should_not be_nil
        response.should render_template("layouts/slide")
        response.should render_template("presentations/show")
      end
    end
  end
end
