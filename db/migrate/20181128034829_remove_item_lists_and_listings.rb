class RemoveItemListsAndListings < ActiveRecord::Migration[5.2]
  def change
    drop_table :item_lists
    drop_table :listings
  end
end
