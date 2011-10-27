class CreateSlides < ActiveRecord::Migration
  def self.up
    create_table :slides do |t|
      t.integer :presentation_id
      t.string :title
      t.string :template
      t.integer :position
    end
  end

  def self.down
    drop_table :slides
  end
end
