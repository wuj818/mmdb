class AddRatingToMovies < ActiveRecord::Migration[5.2]
  def self.up
    add_column :movies, :rating, :integer, default: 0
  end

  def self.down
    remove_column :movies, :rating
  end
end
