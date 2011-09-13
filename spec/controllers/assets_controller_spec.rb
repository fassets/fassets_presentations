require 'spec_helper'

describe AssetsController do
  include_examples "every authenticated controller"

  describe "markup preview" do
    it "should render markup" do
      post 'markup_preview', :markup => "# level 1 header"
      response.should be_success
      response.body.should have_css("h1", :text => "level 1 header")
    end
  end
end