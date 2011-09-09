require 'spec_helper'

describe Frame do
  let(:presentation) do
    root = Frame.create!(:title => "root_frame", :template => "title", :position => 1)
    p = Presentation.create!(:title => "Test Title", :template => "default")
    p.root_frame.children << Frame.create!(:title => "Test Frame", :template => "title", :presentation => p)
    p
  end

  describe "containing slots" do
    it "should return a slot for named content" do
      presentation.root_frame.descendants.first.content = { "title" => "Testcontent" }
      presentation.root_frame.descendants.first.slot("title").should_not be_nil
    end
  end

  describe "returns a path" do
    it "should contain presentation id and frame id" do
      frame_id = presentation.root_frame.descendants.first.id
      presentation.root_frame.descendants.first.path.should =~ /^\/presentations\/#{presentation.id}\/frames\/#{frame_id}/
    end
  end

end