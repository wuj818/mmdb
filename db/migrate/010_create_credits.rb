class CreateCredits < ActiveRecord::Migration
  def self.up
    create_table :credits do |t|
      t.references :person
      t.references :movie
      t.string :job
      t.string :details

      t.timestamps
    end

    add_index :credits, :person_id
    add_index :credits, :movie_id
  end

  def self.down
    drop_table :credits
  end
end
