class AddSortTitleToMovies < ActiveRecord::Migration[5.2]
  def self.up
    add_column :movies, :sort_title, :string
  end

  def self.down
    remove_column :movies, :sort_title
  end
end
