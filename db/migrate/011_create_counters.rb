class CreateCounters < ActiveRecord::Migration[5.2]
  def self.up
    create_table :counters do |t|
      t.references :countable, polymorphic: true
      t.integer :directing_credits, default: 0
      t.integer :writing_credits, default: 0
      t.integer :composing_credits, default: 0
      t.integer :editing_credits, default: 0
      t.integer :cinematography_credits, default: 0
      t.integer :acting_credits, default: 0

      t.timestamps
    end
  end

  def self.down
    drop_table :counters
  end
end
