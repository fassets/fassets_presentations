class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer :presentation_id
      t.string :title
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
    end
    add_column :slides, :topic_id, :integer
  end

  def self.down
    remove_column :slides, :topic_id
    drop_table :topics
  end
end
