class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.references :item_list
      t.references :movie
      t.integer :position, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
