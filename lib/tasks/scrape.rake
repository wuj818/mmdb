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
      next unless movie.directing_credits.empty?

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
end
