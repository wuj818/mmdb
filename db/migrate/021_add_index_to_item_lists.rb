class AddIndexToItemLists < ActiveRecord::Migration
  def self.up
    add_index :item_lists, :permalink
  end

  def self.down
    remove_index :item_lists, :permalink
  end
end
