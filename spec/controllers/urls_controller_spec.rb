require 'spec_helper'

describe UrlsController do
  describe "GET 'show'" do
    let(:url) { double(Url, :id => 1, :url => "http://example.com/") }

    context "asset doesn’t exist" do
      it "should redirect to application root" do
        get 'show', :id => url.id
        response.should redirect_to(root_path)
      end

      it "should flash out an error" do
        get 'show', :id => url.id
        response.should redirect_to(root_path)
        request.flash[:error].should =~ /not found$/
      end
    end

    context "asset exists" do
      before(:each) do
        my_url = url
        controller.stub!(:find_content) {}
        controller.instance_eval { @content = my_url }
      end

      it "should redirect to url" do
        get 'show', :id => url.id
        response.should redirect_to(url.url)
      end
    end
  end
end
