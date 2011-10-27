require 'spec_helper'

describe FramesController do
  include_examples "every authenticated controller"

  before(:each) do
    p = Presentation.create!(:title => 'TestPresentation', :template => 'test_template')
    p.root_frame.children << Frame.create!(:title => 'Title Frame', :template => 'default')
  end

  describe "GET 'show'" do
    it "should redirect to slide within presentation" do
      get 'show', { :presentation_id => 1, :id => 1 }
      response.should redirect_to presentation_path(1)+"#1"
    end
  end

  describe "POST 'create'" do
    let(:params) do
      {:presentation_id => 1, :frame => {}}
    end

    describe "creation is a success" do
      it "assigns a presentation" do
        post 'create', params
        assigns(:presentation).should_not be_nil
      end

      it "creates a frame" do
        frame_count = Presentation.find(1).root_frame.children.count
        post 'create', params.merge({:frame => {:title => "TestTitle", :template => 'none'}})
        request.flash[:notice].should =~ /Frame succesfully created!/
        pending "fails here. need to find out, which params need to be posted to add it correcty."
        Presentation.find(1).root_frame.children.count.should == frame_count+1
      end
    end

    describe "creation fails" do
      it "creates no frame" do
        frame_count = Presentation.find(1).root_frame.children.count
        post 'create', params
        request.flash[:error].should_not be_empty
        Presentation.find(1).root_frame.children.count.should == frame_count
      end
    end
  end

  describe "PUT 'update'" do
    let(:params) do
      {:presentation_id => 1, :id => 2, :frame => {}}
    end

    it "finds presentation and frame" do
      put 'update', params
      assigns(:presentation).should_not be_nil
      assigns(:frame).should_not be_nil
    end

    describe "update successful" do
      it "should update the frame" do
        put 'update', params.merge({:frame => {:title => "changed"}})
        assigns(:frame).title.should == "changed"
        request.flash[:notice].should =~ /succesfully updated/
      end
    end

    describe "update fails" do
      it "should not update the frame" do
      pending "can this ever happen?" do
        put 'update', params.merge({:frame => {:title => "don’t change!"}})
        assigns(:frame).title.should == "Title Frame"
        request.flash[:error].should =~ /not update/
      end
      end
    end
  end

  describe "DELETE a frame" do
    let(:params) { {:presentation_id => 1, :id => 2} }
    it "should delete the frame" do
      frames_count = Presentation.find(1).root_frame.children.count
      delete 'destroy', params
      Presentation.find(1).root_frame.children.count.should == frames_count-1
      request.flash[:notice].should =~ /succesfully deleted/
    end
  end

  describe "change position of frames" do
    before(:each) do
      p = Presentation.find(1)
      p.root_frame.children << Frame.create!(:title => 'Test Frame 2', :template => 'default')
      p.root_frame.children << Frame.create!(:title => 'Test Frame 3', :template => 'default')
      p.root_frame.children << Frame.create!(:title => 'Test Frame 4', :template => 'default')
    end

    let(:params) do
      {:presentation_id => 1}
    end

    it "should update the positions of frames within the root level" do
      pending "something changed in the sort action. spec needs update!"
      [2,3,4,5].permutation.each do |p|
        frames = {:frame => []}
        p.each { |f| frames[:frame] << ["#{f}", 'root'] }
        put 'sort', frames.merge(params)
        Presentation.find(1).root_frame.children.select{ |f| f != Presentation.find(1).root_frame }.map{ |f| f.id }.should == p
      end
    end
  end
end
