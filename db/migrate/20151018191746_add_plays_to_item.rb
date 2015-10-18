class AddPlaysToItem < ActiveRecord::Migration
  def change
    add_column :items, :plays, :integer, :default => 0
  end
end
