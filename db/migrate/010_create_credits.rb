class CreateCredits < ActiveRecord::Migration[5.2]
  def self.up
    create_table :credits do |t|
      t.references :person
      t.references :movie
      t.string :job
      t.string :details

      t.timestamps
    end
  end

  def self.down
    drop_table :credits
  end
end
