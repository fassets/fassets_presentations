require 'spec_helper'

describe CatalogsController do
  include_examples "every authenticated controller"

  before(:each) do
    Catalog.create!({:title => "Testcatalog1"})
    Catalog.create!({:title => "Testcatalog2"})
    Catalog.create!({:title => "Testcatalog3"})
  end

  describe "GET 'index'" do
    before(:each) { get 'index' }
    it "should assign all catalogs" do
      assigns(:catalogs).should have(3).items
    end

    it "should render the index template" do
      response.should be_success
      response.should render_template 'catalogs/index'
    end
  end

  describe "GET 'show'" do
    before(:each) { get 'show', :id => 1 }
    it "should render the show template" do
      response.should be_success
      response.should render_template 'catalogs/show'
    end

    it { assigns(:catalog).should eq(Catalog.find(1)) }
    it { assigns(:filter).should be_kind_of(LabelFilter) }
    it { assigns(:counts).should == 0 }
    it { assigns(:assets).should have(:no).items }
  end

  describe "GET 'new'" do
    before(:each) { get 'new' }
    it { assigns(:catalog).should be_a_new(Catalog) }
    it { response.should be_success }
    it { response.should render_template 'catalogs/new' }
  end

  describe "POST 'create'" do
    context "with valid catalog data" do
      before(:each) do
        params = {:catalog => {:title => "Testcatalog4"}}
        post 'create', params
      end
      it { assigns(:catalog).should be_valid }
      it { request.flash[:notice].should =~ /^Catalog was successfully created.$/ }
      it { response.should redirect_to catalogs_path }
      it "saves the catalog" do
        Catalog.all.should have(4).items
      end
    end

    context "with invalid catalog data" do
      before(:each) do
        params = {:catalog => {}}
        post 'create', params
      end
      it { assigns(:catalog).should_not be_valid }
      it { response.should render_template 'catalogs/index' }
      it { request.flash[:error].should =~ /^Catalog could not be created!/ }
    end
  end

  describe "GET 'edit'" do
    before(:each) { get 'edit', :id => 1 }
    it { assigns(:catalog).should_not be_nil }
    it { response.should be_success }
  end

  describe "POST 'update'" do
    context "with valid catalog data" do
      before(:each) do
        params = {:id => 1, :catalog => {:title => "Testcatalog4"}}
        post 'update', params
      end
      it { response.should redirect_to catalog_path(assigns(:catalog)) }
      it "should update the catalog data" do
        Catalog.all.should have(3).items
        Catalog.find(1).title.should eq("Testcatalog4")
      end

      context "but failing save operation" do
        it "should render edit partial" do
          controller.stub!(:find_catalog) {}
          c = double(Catalog)
          c.stub!(:update_attributes) { false }
          controller.instance_eval { @catalog = c }
          params = {:id => 1, :catalog => {:title => "Testcatalog4"}}
          post 'update', params
          response.should render_template 'catalogs/edit'
        end
      end
    end

    context "with invalid catalog data" do
      before(:each) do
        request.env["HTTP_REFERER"] = "/some_path"
        params = { :id => 1, :catalog => {}}
        post 'update', params
      end
      it { request.flash[:error].should =~ /^Catalog could not be updated!/ }
      it { response.should redirect_to '/some_path' }
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) { delete 'destroy', :id => 1 }

    it { response.should redirect_to root_url }
    it { assigns(:catalog).should respond_to(:destroy).with(0).arguments }
    it { request.flash[:notice].should =~ /^Catalog was successfully destroyed.$/ }

    it "should delete the catalog" do
      Catalog.all.should have(2).items
    end
  end
end