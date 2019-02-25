class AddSortIndexesToMoviesAndPeople < ActiveRecord::Migration[5.2]
  def self.up
    add_index :movies, :sort_title
    add_index :people, :sort_name
  end

  def self.down
    remove_index :movies, :sort_title
    remove_index :people, :sort_name
  end
end
