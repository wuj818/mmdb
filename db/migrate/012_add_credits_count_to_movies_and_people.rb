class AddCreditsCountToMoviesAndPeople < ActiveRecord::Migration[5.2]
  def self.up
    add_column :movies, :credits_count, :integer, default: 0
    add_column :people, :credits_count, :integer, default: 0
  end

  def self.down
    remove_column :movies, :credits_count
    remove_column :people, :credits_count
  end
end
