require 'spec_helper'

describe LabelsController do
  include_examples "every authenticated controller"

  before(:each) do
    Catalog.create!(:title => "TestCatalog")
    f = Facet.create({:caption => "TestFacet"})
    f.catalog = Catalog.all.first
    request.env["HTTP_REFERER"] = "/somewhere"
  end
  let(:context_params) do
    { :facet_id => 1,
      :catalog_id => 1}
  end

  describe "POST 'create'" do
    let(:params) do
      { :label => {:caption => "TestLabel"} }.merge(context_params)
    end
    before(:each) do
      post 'create', params
    end

    it { assigns(:label).errors.messages.should == {} }
    it { response.should redirect_to controller.edit_catalog_facet_path(params[:catalog_id], params[:facet_id]) }
    it { request.flash[:notice].should =~ /^Label was successfully created.$/ }

    context "without valid label data" do
      let(:params) do
        { :label => {} }.merge(context_params)
      end

      it { assigns(:label).should have(1).error_on(:caption) }
      it { response.should redirect_to "/somewhere" }
      it { request.flash[:error].should =~ /^Label could not be created!/ }
    end
  end

  describe "PUT 'update'" do
    let(:params) do
      Label.create!(:caption => "TestLabel")
      { :id => 1,
        :label => {:caption => "TestLabelChanged"}}.merge(context_params)
    end
    before(:each) { put 'update', params }

    it { assigns(:label).caption.should == "TestLabelChanged" }
    it { response.should redirect_to controller.edit_catalog_facet_path(params[:catalog_id], params[:facet_id]) }
    it { request.flash[:notice].should =~ /^Label was successfully updated.$/ }

    context "without valid label data" do
      let(:params) do
        Label.create!(:caption => "TestLabel")
        { :id => 1,
          :label => {}}.merge(context_params)
      end

      it { response.should redirect_to "/somewhere" }
      it { request.flash[:error].should =~ /^Label could not be updated! Caption cannot be empty!$/ }
    end
  end

  describe "PUT 'sort'" do
    before(:each) do
      Label.create!(:caption => "Testlabel1")
      Label.create!(:caption => "Testlabel2")
      Label.create!(:caption => "Testlabel3")
      Label.all.map{ |l| l.id }.should == [1,2,3]
    end

    it "labels are sorted in reverse" do
      order = [3,2,1]
      put 'sort', { :label => order }.merge(context_params)
      Label.all.sort_by{ |l| l.position }.map{ |l| l.id }.should == order
    end
    it "labels are sorted correctly for each permutation" do
      [1,2,3].permutation.each do |p|
        put 'sort', { :label => p }.merge(context_params)
        Label.all.sort_by{ |l| l.position }.map{ |l| l.id }.should == p
      end
    end
  end
end
