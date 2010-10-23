namespace :scrape do
  desc 'Grabs genre lists for movies without genres'
  task :genres => :environment do
    Movie.find_each do |movie|
      next unless movie.genre_list.empty?

      diggler = DirkDiggler.new(movie.imdb_url)
      diggler.get(:genres) rescue sleep(5) and redo

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

      diggler = DirkDiggler.new(movie.imdb_url)
      diggler.get(:keywords) rescue sleep(5) and redo

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

      diggler = DirkDiggler.new(movie.imdb_url)
      diggler.get(:languages) rescue sleep(5) and redo

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

      diggler = DirkDiggler.new(movie.imdb_url)
      diggler.get(:countries) rescue sleep(5) and redo

      if diggler.countries.empty?
        puts "Could not find countries for '#{movie.title}'".color(:red)
      else
        puts "Updating country list for '#{movie.title}'".color(:green)
      end

      movie.country_list = diggler.countries.join ', '
      movie.save
    end
  end
end
