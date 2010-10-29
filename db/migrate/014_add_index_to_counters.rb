class AddIndexToCounters < ActiveRecord::Migration
  def self.up
    add_index :counters, [:countable_id, :countable_type]
  end

  def self.down
    remove_index :counters, [:countable_id, :countable_type]
  end
end
