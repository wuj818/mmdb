class AddPermalinkIndexesToMoviesAndPeople < ActiveRecord::Migration[5.2]
  def self.up
    add_index :movies, :permalink
    add_index :people, :permalink
  end

  def self.down
    remove_index :movies, :permalink
    remove_index :people, :permalink
  end
end
