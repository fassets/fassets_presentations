class CreateSlots < ActiveRecord::Migration
  def self.up
    create_table :slots do |t|
      t.integer :slide_id
      t.string :name
      t.text :body
      t.integer :asset_id
    end
  end

  def self.down
    drop_table :slots
  end
end
