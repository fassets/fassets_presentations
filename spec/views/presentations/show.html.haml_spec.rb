require 'spec_helper'

describe 'presentations/show.html.haml' do
  before(:each) do
    @root_frame = double(Frame,{:id => 1, :title => 'root_frame', :descendants => [], :template => 'title', :position => 0})
    @presentation = double(Presentation,{:id => 1, :title => "TestTitle", :template => "default", :root_frame => @root_frame, :frames => [@root_frame]})
    @root_frame.stub!(:presentation) { @presentation }
    @root_frame.stub!(:slot).with("subtitle") { "" }
    @root_frame.stub!(:slot).with("center") { "" }
    @root_frame.stub!(:children) { [] }
    assign(:presentation, @presentation)
  end

  it "should have dimming overlay elements" do
    render
    rendered.should have_selector('div', :id => 'black_dimmer')
    rendered.should have_selector('#white_dimmer')
  end

  describe "rendering presentations without any framess" do
    it "should render an edit button" do
      render
      rendered.should have_selector("a", :href => edit_presentation_path(@presentation))
    end
  end
end