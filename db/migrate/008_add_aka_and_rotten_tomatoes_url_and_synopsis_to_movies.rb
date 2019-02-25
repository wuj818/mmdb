class AddAkaAndRottenTomatoesUrlAndSynopsisToMovies < ActiveRecord::Migration[5.2]
  def self.up
    add_column :movies, :aka, :string
    add_column :movies, :rotten_tomatoes_url, :string
    add_column :movies, :synopsis, :text
  end

  def self.down
    remove_column :movies, :synopsis
    remove_column :movies, :rotten_tomatoes_url
    remove_column :movies, :aka
  end
end
