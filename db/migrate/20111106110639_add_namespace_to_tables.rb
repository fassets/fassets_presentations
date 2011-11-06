class AddNamespaceToTables < ActiveRecord::Migration
  def change
    rename_table 'presentations', 'fassets_presentations_presentations'
    rename_table 'frames', 'fassets_presentations_frames'
    rename_table 'slots', 'fassets_presentations_slots'
  end
end
