require 'spec_helper'

describe Slot do

  describe "initialisation" do
    let(:slot) do
      Slot.new("name", {"key" => "content"}, true)
    end
    it "should be defined by three parameters" do
      # actually, this is bad design. see: http://doc.qt.nokia.com/qq/qq13-apis.html#thebooleanparametertrap
      s = slot
      s.name.should == "name"
      s["key"].should == "content"
      s.should be_in_template
    end
  end

  describe "can contain assets" do
    let(:slot) do
        Slot.new("name", {"key" => "content", 'asset_id' => 12345}, true)
    end
    it "returns nil if asset doesn’t exist" do
      slot.asset.should be_nil
    end

    it "returns an asset if it exists" do
      Asset.stub!(:find).with(12345) { double(Asset, :title => "asset found!") }
      slot.asset.title.should == "asset found!"
    end
  end
end