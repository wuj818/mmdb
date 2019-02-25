class AddMoviePosterDbUrlToMovies < ActiveRecord::Migration[5.2]
  def self.up
    add_column :movies, :movie_poster_db_url, :string
  end

  def self.down
    remove_column :movies, :movie_poster_db_url
  end
end
