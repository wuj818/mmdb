class AddYearToMovies < ActiveRecord::Migration[5.2]
  def self.up
    add_column :movies, :year, :integer
  end

  def self.down
    remove_column :movies, :year
  end
end
