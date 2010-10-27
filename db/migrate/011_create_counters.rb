class CreateCounters < ActiveRecord::Migration
  def self.up
    create_table :counters do |t|
      t.references :countable, :polymorphic => true
      t.integer :directing_credits, :default => 0
      t.integer :writing_credits, :default => 0
      t.integer :composing_credits, :default => 0
      t.integer :editing_credits, :default => 0
      t.integer :cinematography_credits, :default => 0
      t.integer :acting_credits, :default => 0

      t.timestamps
    end

    Movie.find_each do |movie|
      puts "Creating counter for '#{movie.title}'."
      movie.create_counter
      movie.counter.update_attribute :directing_credits, movie.directing_credits.count
      movie.counter.update_attribute :writing_credits, movie.writing_credits.count
      movie.counter.update_attribute :composing_credits, movie.composing_credits.count
      movie.counter.update_attribute :editing_credits, movie.editing_credits.count
      movie.counter.update_attribute :cinematography_credits, movie.cinematography_credits.count
      movie.counter.update_attribute :acting_credits, movie.acting_credits.count
    end

    Person.find_each do |person|
      puts "Creating counter for '#{person.name}'."
      person.create_counter
      person.counter.update_attribute :directing_credits, person.directing_credits.count
      person.counter.update_attribute :writing_credits, person.writing_credits.count
      person.counter.update_attribute :composing_credits, person.composing_credits.count
      person.counter.update_attribute :editing_credits, person.editing_credits.count
      person.counter.update_attribute :cinematography_credits, person.cinematography_credits.count
      person.counter.update_attribute :acting_credits, person.acting_credits.count
    end
  end

  def self.down
    drop_table :counters
  end
end
