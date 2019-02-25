class AddPermalinkToMovies < ActiveRecord::Migration[5.2]
  def self.up
    add_column :movies, :permalink, :string
  end

  def self.down
    remove_column :movies, :permalink
  end
end
