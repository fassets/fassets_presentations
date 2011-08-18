require 'spec_helper'

describe SlidesController do
  include_examples "every authenticated controller"

  before(:each) do
    p = Presentation.create!(:title => 'TestPresentation', :template => 'test_template')
    p.slides << Slide.create!(:title => 'Title Slide', :template => 'default')
  end

  describe "GET 'show'" do
    it "should redirect to slide within presentation" do
      get 'show', { :presentation_id => 1, :id => 1 }
      response.should redirect_to presentation_path(1)+"#1"
    end
  end
end