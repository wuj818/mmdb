class AddRuntimeToMovies < ActiveRecord::Migration[5.2]
  def self.up
    add_column :movies, :runtime, :integer, default: 0
  end

  def self.down
    remove_column :movies, :runtime
  end
end
