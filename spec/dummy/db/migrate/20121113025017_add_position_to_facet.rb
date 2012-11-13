class AddPositionToFacet < ActiveRecord::Migration
  def change
    add_column :facets, :position, :integer
  end
end
