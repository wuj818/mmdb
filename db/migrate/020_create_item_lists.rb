class CreateItemLists < ActiveRecord::Migration
  def self.up
    create_table :item_lists do |t|
      t.string :name
      t.string :permalink
      t.integer :position, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :item_lists
  end
end
