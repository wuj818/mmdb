class RenameColumnsForCounters < ActiveRecord::Migration
  def self.up
    change_table :counters do |t|
      t.rename :directing_credits, :directing_credits_count
      t.rename :writing_credits, :writing_credits_count
      t.rename :composing_credits, :composing_credits_count
      t.rename :editing_credits, :editing_credits_count
      t.rename :cinematography_credits, :cinematography_credits_count
      t.rename :acting_credits, :acting_credits_count
    end
  end

  def self.down
    change_table :counters do |t|
      t.rename :directing_credits_count, :directing_credits
      t.rename :writing_credits_count, :writing_credits
      t.rename :composing_credits_count, :composing_credits
      t.rename :editing_credits_count, :editing_credits
      t.rename :cinematography_credits_count, :cinematography_credits
      t.rename :acting_credits_count, :acting_credits
    end
  end
end
