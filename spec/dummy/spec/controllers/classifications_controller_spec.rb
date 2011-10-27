require 'spec_helper'

describe ClassificationsController do
  include_examples "every authenticated controller"

  let(:url) do
    url = Url.new(:url => "http://example.com/")
    url.asset = Asset.create(:user => controller.current_user, :name => "TestAsset")
    url.save!
    url
  end

  before(:each) do
    controller.current_user.stub!(:tray_positions) { double(TrayPosition, :maximum => nil) }
    Classification.create!({:asset => url.asset})
    Classification.create!({:asset => url.asset})
  end

  describe "POST 'create'" do
    before(:each) do
      params = { :classification => { :asset_id => url.asset.id}}
      post 'create', params
    end
    it { response.should redirect_to edit_url_path(url) }
    it "creates a classification" do
      Classification.all.should have(3).items
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) { delete 'destroy', :id => 1 }
    it { assigns(:classification).should respond_to(:destroy).with(0).arguments }
    it { response.should redirect_to controller.url_for(assigns(:classification).asset.content) + "/edit" }
    it "delete the first classification" do
      Classification.all.should have(1).item
    end
  end

  describe "POST 'update'" do
    let(:params) do
      {:id => 1,
       :labels => []}
    end
    before(:each) { post 'update', params }
    it { request.flash[:notice] =~ /^Updated Classification$/ }
    it { response.should redirect_to controller.url_for(assigns(:classification).asset.content) + "/edit" }
    it { assigns(:classification).should respond_to(:label_ids=).with(1).argument }
  end
end