class CreateMovies < ActiveRecord::Migration[5.2]
  def self.up
    create_table :movies do |t|
      t.string :title
      t.string :imdb_url

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
