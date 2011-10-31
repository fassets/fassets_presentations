class CreateFrames < ActiveRecord::Migration
  def self.up
    create_table :frames do |t|
      t.integer :presentation_id
      t.string :title
      t.string :template
      t.integer :position
      t.integer :parent_id
      t.text :content
    end
  end

  def self.down
    drop_table :frames
  end
end
