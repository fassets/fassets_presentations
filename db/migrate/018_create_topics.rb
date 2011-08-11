class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer :presentation_id
      t.integer :topic_slide
      t.string :title
      t.integer :position
      t.integer :parent_id
    end
    add_column :slides, :topic_id, :integer
  end

  def self.down
    remove_column :slides, :topic_id
    drop_table :topics
  end
end
