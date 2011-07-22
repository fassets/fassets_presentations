require 'spec_helper'

describe FileAssetsController do
  let(:asset) { double(FileAsset, :id => 1, :format => "png") }
  let(:create_params) do
    {"file_asset" => {:file_file_name => "test.png"}}
  end
  include_examples "Every AssetsController"

  it "assigns content with FileAsset class" do
    get 'new'
    assigns(:content).class.should == FileAsset
  end

  context "actions with assets" do
    before(:each) { setup_content }

    it "should redirect into the thumb folder" do
      get 'thumb', :id => asset.id, :format => asset.format
      response.should redirect_to("#{root_path}public/uploads/#{asset.id}/thumb.#{asset.format}")
    end

    it "should redirect into the preview folder" do
      get 'preview', :id => asset.id, :format => asset.format
      response.should redirect_to("#{root_path}public/uploads/#{asset.id}/small.#{asset.format}")
    end

    it "should redirect into the original image folder" do
      get 'original', :id => asset.id, :format => asset.format
      response.should redirect_to("#{root_path}public/uploads/#{asset.id}/original.#{asset.format}")
    end

    it "should render partials" do
      get 'show', :id => asset.id
      response.should render_template("layouts/application")
      response.should render_template("assets/show")
    end
  end
end