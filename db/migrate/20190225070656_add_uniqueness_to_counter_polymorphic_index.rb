class AddUniquenessToCounterPolymorphicIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :counters, [:countable_id, :countable_type]
    add_index :counters, [:countable_id, :countable_type], unique: true
  end
end
