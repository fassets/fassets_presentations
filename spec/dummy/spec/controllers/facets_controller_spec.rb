require 'spec_helper'

describe FacetsController do
  describe CatalogsController do
    include_examples "every authenticated controller"

    before(:each) do
      Catalog.create!(:title => "TestCatalog")
    end

    describe "GET 'new'" do
      let(:params) do
        { :catalog_id => 1 }
      end
      before(:each) { pending "this is broken" do get 'new', params end }
      it { assigns(:catalog).should_not be_nil }
      it { response.should render_template 'catalogs/new' }
    end

    describe "POST 'create'" do
      before(:each) do
        request.env["HTTP_REFERER"] = "/somewhere"
        post 'create', params
      end
      context "with valid facet data" do
        let(:params) do
          {:catalog_id => 1,
           :facet => {:caption => "TestFacet"}}
        end
        it { assigns(:facet).should be_valid }
        it { request.flash[:notice].should =~ /^Facet was successfully created.$/ }
        it { response.should redirect_to controller.edit_catalog_facet_path(assigns(:catalog), assigns(:facet)) }
      end

      context "with invalid facet data" do
        let(:params) do
          {:catalog_id => 1,
           :facet => {}}
        end
        it { response.should redirect_to "/somewhere" }
        it { request.flash[:error] =~ /^Facet could not be created!/ }
      end
    end

    describe "GET 'edit'" do
      let(:params) do
        Facet.create!({:caption => "TestFacet", :catalog_id => 1})
        { :id => 1,
          :catalog_id => 1}
      end

      before(:each) { get 'edit', params }
      it { assigns(:facet).should_not be_nil }
      it { response.should render_template 'facets/edit' }
    end

    describe "PUT 'update'" do
      let(:params) do
        Facet.create!({:caption => "TestFacet", :catalog_id => 1})
        { :id => 1,
          :catalog_id => 1,
          :facet => {:caption => "TestFacetUpdated"}}
      end

      before(:each) { put 'update', params }
      it { assigns(:facet).caption.should == "TestFacetUpdated" }
      it { response.should redirect_to controller.edit_catalog_facet_path(assigns(:catalog), assigns(:facet)) }
      it { request.flash[:notice].should =~ /^Facet has been updated.$/ }

      context "with invalid facet data" do
        let(:params) do
          request.env["HTTP_REFERER"] = "/somewhere"
          { :id => 1,
            :catalog_id => 1,
            :facet => {}}
        end

        it { response.should redirect_to "/somewhere" }
        it { request.flash[:error].should =~ /^Facet could not be updated! Caption cannot be empty$/ }
      end
    end

    describe "DELETE 'destroy'" do
      let(:params) do
        Facet.create!({:caption => "TestFacet", :catalog_id => 1})
        Facet.create!({:caption => "TestFacet2", :catalog_id => 1})
        { :id => 2,
          :catalog_id => 1}
      end
      before(:each) { delete 'destroy', params }
      it { pending "this is broken" do assigns(:facet).should respond_to(:destroy).with(0).arguments end }
      it { request.flash[:notice].should =~ /^Facet was successfully destroyed.$/ }
      it { pending "this is broken" do response.should redirect_to controller.catalog_path(Catalog.all.first) end }
      it "has deleted the facet" do
        Catalog.all.first.facets.should have(1).item
      end
    end
  end
end