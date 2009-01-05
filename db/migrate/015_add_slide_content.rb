class AddSlideContent< ActiveRecord::Migration
  def self.up
    add_column :slides, :content, :text
  end

  def self.down
  end
end
