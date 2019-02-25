class AddIndexToItemLists < ActiveRecord::Migration[5.2]
  def self.up
    add_index :item_lists, :permalink
  end

  def self.down
    remove_index :item_lists, :permalink
  end
end
