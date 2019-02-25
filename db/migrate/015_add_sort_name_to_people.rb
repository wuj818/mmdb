class AddSortNameToPeople < ActiveRecord::Migration[5.2]
  def self.up
    add_column :people, :sort_name, :string
  end

  def self.down
    remove_column :people, :sort_name
  end
end
