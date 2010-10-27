class AddCreditsCountToMoviesAndPeople < ActiveRecord::Migration
  def self.up
    add_column :movies, :credits_count, :integer, :default => 0
    add_column :people, :credits_count, :integer, :default => 0

    Movie.find_each do |movie|
      puts "Updating credits count for '#{movie.title}'."
      Movie.update_counters movie.id, :credits_count => movie.credits.count
    end

    Person.find_each do |person|
      puts "Updating credits count for '#{person.name}'."
      Person.update_counters person.id, :credits_count => person.credits.count
    end
  end

  def self.down
    remove_column :movies, :credits_count
    remove_column :people, :credits_count
  end
end
