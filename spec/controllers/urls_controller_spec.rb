require 'spec_helper'

describe UrlsController do
  let(:asset) { double(Url, :id => 1, :url => "http://example.com/") }
  let(:create_params) do
    {"url" => {:url => "http://example.com/"}}
  end
  include_examples "Every AssetsController"

  describe "GET 'show'" do

    context "asset doesn’t exist" do
      it "should redirect to application root" do
        get 'show', :id => asset.id
        response.should redirect_to(root_path)
      end

      it "should flash out an error" do
        get 'show', :id => asset.id
        response.should redirect_to(root_path)
        request.flash[:error].should =~ /not found$/
      end
    end

    context "asset exists" do
      before(:each) { setup_content }

      it "should redirect to url" do
        get 'show', :id => asset.id
        response.should redirect_to(asset.url)
      end
    end
  end
end
