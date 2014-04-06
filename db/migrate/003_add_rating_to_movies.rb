class AddRatingToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :rating, :integer, default: 0
  end

  def self.down
    remove_column :movies, :rating
  end
end
