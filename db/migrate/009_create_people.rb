class CreatePeople < ActiveRecord::Migration[5.2]
  def self.up
    create_table :people do |t|
      t.string :name
      t.string :imdb_url
      t.string :permalink

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
