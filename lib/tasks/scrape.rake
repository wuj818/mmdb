namespace :scrape do
  desc 'Grabs genre lists for movies without genres'
  task :genres => :environment do
    Movie.find_each do |movie|
      next unless movie.genre_list.empty?

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :genres

      if diggler.genres.empty?
        puts "Could not find genres for '#{movie.title}'".color(:red)
      else
        puts "Updating genre list for '#{movie.title}'".color(:green)
      end

      movie.genre_list = diggler.genres.join ', '
      movie.save
    end
  end

  desc 'Grabs keyword lists for movies without keywords'
  task :keywords => :environment do
    Movie.find_each do |movie|
      next unless movie.keyword_list.empty?

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :keywords

      if diggler.keywords.empty?
        puts "Could not find keywords for '#{movie.title}'".color(:red)
      else
        puts "Updating keyword list for '#{movie.title}'".color(:green)
      end

      movie.keyword_list = diggler.keywords.join ', '
      movie.save
    end
  end

  desc 'Grabs language lists for movies without languages'
  task :languages => :environment do
    Movie.find_each do |movie|
      next unless movie.language_list.empty?

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :languages

      if diggler.languages.empty?
        puts "Could not find languages for '#{movie.title}'".color(:red)
      else
        puts "Updating language list for '#{movie.title}'".color(:green)
      end

      movie.language_list = diggler.languages.join ', '
      movie.save
    end
  end

  desc 'Grabs country lists for movies without countries'
  task :countries => :environment do
    Movie.find_each do |movie|
      next unless movie.country_list.empty?

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :countries

      if diggler.countries.empty?
        puts "Could not find countries for '#{movie.title}'".color(:red)
      else
        puts "Updating country list for '#{movie.title}'".color(:green)
      end

      movie.country_list = diggler.countries.join ', '
      movie.save
    end
  end

  desc 'Grabs directors for movies without directors'
  task :directors => :environment do
    Movie.find_each do |movie|
      next unless movie.directing_credits_count == 0

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :directors
      directors = diggler.directors

      if directors.empty?
        puts "Could not find directors for '#{movie.title}'".color(:red)
      else
        puts "Adding #{diggler.directors.count} director(s) to '#{movie.title}'".color(:green)

        directors.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          person.directing_credits.create :movie => movie, :job => 'Director', :details => info[:details]
        end
      end
    end
  end

  desc 'Grabs writers for movies without writers'
  task :writers => :environment do
    Movie.find_each do |movie|
      next unless movie.writing_credits_count == 0

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :writers
      writers = diggler.writers

      if writers.empty?
        puts "Could not find writers for '#{movie.title}'".color(:red)
      else
        puts "Adding #{diggler.writers.count} writer(s) to '#{movie.title}'".color(:green)

        writers.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          person.writing_credits.create :movie => movie, :job => 'Writer', :details => info[:details]
        end
      end
    end
  end

  desc 'Grabs composers for movies without composers'
  task :composers => :environment do
    Movie.find_each do |movie|
      next unless movie.composing_credits_count == 0

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :composers
      composers = diggler.composers

      if composers.empty?
        puts "Could not find composers for '#{movie.title}'".color(:red)
      else
        puts "Adding #{diggler.composers.count} composer(s) to '#{movie.title}'".color(:green)

        composers.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          person.composing_credits.create :movie => movie, :job => 'Composer', :details => info[:details]
        end
      end
    end
  end

  desc 'Grabs editors for movies without editors'
  task :editors => :environment do
    Movie.find_each do |movie|
      next unless movie.editing_credits_count == 0

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :editors
      editors = diggler.editors

      if editors.empty?
        puts "Could not find editors for '#{movie.title}'".color(:red)
      else
        puts "Adding #{diggler.editors.count} editor(s) to '#{movie.title}'".color(:green)

        editors.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          person.editing_credits.create :movie => movie, :job => 'Editor', :details => info[:details]
        end
      end
    end
  end

  desc 'Grabs cinematographers for movies without cinematographers'
  task :cinematographers => :environment do
    Movie.find_each do |movie|
      next unless movie.cinematography_credits_count == 0

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :cinematographers
      cinematographers = diggler.cinematographers

      if cinematographers.empty?
        puts "Could not find cinematographers for '#{movie.title}'".color(:red)
      else
        puts "Adding #{diggler.cinematographers.count} cinematographer(s) to '#{movie.title}'".color(:green)

        cinematographers.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          person.cinematography_credits.create :movie => movie, :job => 'Cinematographer', :details => info[:details]
        end
      end
    end
  end

  desc 'Grabs actors for movies without actors'
  task :actors => :environment do
    Movie.find_each do |movie|
      next unless movie.acting_credits_count == 0

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :actors
      actors = diggler.actors

      if actors.empty?
        puts "Could not find actors for '#{movie.title}'".color(:red)
      else
        puts "Adding #{diggler.actors.count} actor(s) to '#{movie.title}'".color(:green)

        actors.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          person.acting_credits.create :movie => movie, :job => 'Actor', :details => info[:details]
        end
      end
    end
  end
end
