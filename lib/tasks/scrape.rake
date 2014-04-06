namespace :scrape do
  def timestamp
    timestamp = Time.now.strftime '%m-%d-%Y-%H-%M-%S'
  end

  def log_file(type)
    log = File.open "#{Rails.root}/log/#{type}-#{timestamp}.txt", 'w'
  end

  def progress_bar(type)
    ProgressBar.new type, Movie.count
  end

  desc 'Grabs genre lists for movies without genres'
  task genres: 'environment' do
    Movie.find_each do |movie|
      next unless movie.genre_list.empty?

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :genres

      if diggler.genres.empty?
        puts %(Could not find genres for "#{movie.title}").color(:red)
      else
        puts %(Updating genre list for "#{movie.title}").color(:green)
      end

      movie.genre_list = diggler.genres.join ', '
      movie.save
    end
  end

  desc 'Grabs keyword lists for movies'
  task keywords: 'environment' do
    log = log_file 'keywords'
    bar = progress_bar 'Keywords'
    diggler = DirkDiggler.new ''
    total_count = 0

    Movie.find_each do |movie|
      bar.inc
      diggler.refresh movie.imdb_url
      diggler.get :keywords
      keywords = diggler.keywords

      if keywords.empty?
        log.puts %(Could not find keywords for "#{movie.title}").color(:red)
      elsif keywords.count == movie.keyword_list.count
        log.puts %("#{movie.title}" is up to date.).color(:yellow)
      else
        new_keywords = keywords - movie.keyword_list
        movie.add_keyword new_keywords
        count = new_keywords.count
        total_count += count
        log.puts %(Added #{count} keywords to "#{movie.title}").color(:green)
      end
    end

    bar.finish
    puts "\n\n"
    puts "Added #{total_count} keywords.".color(:green)
  end

  desc 'Grabs language lists for movies without languages'
  task languages: 'environment' do
    Movie.find_each do |movie|
      next unless movie.language_list.empty?

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :languages

      if diggler.languages.empty?
        puts %(Could not find languages for "#{movie.title}").color(:red)
      else
        puts %(Updating language list for "#{movie.title}").color(:green)
      end

      movie.language_list = diggler.languages.join ', '
      movie.save
    end
  end

  desc 'Grabs country lists for movies without countries'
  task countries: 'environment' do
    Movie.find_each do |movie|
      next unless movie.country_list.empty?

      diggler = DirkDiggler.new movie.imdb_url
      diggler.get :countries

      if diggler.countries.empty?
        puts %(Could not find countries for "#{movie.title}").color(:red)
      else
        puts %(Updating country list for "#{movie.title}").color(:green)
      end

      movie.country_list = diggler.countries.join ', '
      movie.save
    end
  end

  desc 'Grabs directors for movies'
  task directors: 'environment' do
    log = log_file 'directors'
    bar = progress_bar 'Directors'
    diggler = DirkDiggler.new ''
    total_count = 0

    Movie.includes(:counter).each do |movie|
      bar.inc
      diggler.refresh movie.imdb_url
      diggler.get :directors
      directors = diggler.directors

      if directors.empty?
        log.puts %(Could not find directors for "#{movie.title}").color(:red)
      elsif directors.count == movie.number_of_directing_credits
        log.puts %("#{movie.title}" is up to date.).color(:yellow)
      else
        count = 0
        directors.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          credit = person.directing_credits.create movie: movie, job: 'Director', details: info[:details]

          if credit.valid?
            count += 1
            total_count += 1
          end
        end
        log.puts %(Added #{count} director(s) to "#{movie.title}").color(:green)
      end
    end

    bar.finish
    puts "\n\n"
    puts "Added #{total_count} directors.".color(:green)
  end

  desc 'Grabs writers for movies'
  task writers: :environment do
    log = log_file 'writers'
    bar = progress_bar 'Writers'
    diggler = DirkDiggler.new ''
    total_count = 0

    Movie.includes(:counter).each do |movie|
      bar.inc
      diggler.refresh movie.imdb_url
      diggler.get :writers
      writers = diggler.writers

      if writers.empty?
        log.puts %(Could not find writers for "#{movie.title}").color(:red)
      elsif writers.count == movie.number_of_writing_credits
        log.puts %("#{movie.title}" is up to date.).color(:yellow)
      else
        count = 0
        writers.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          credit = person.writing_credits.create movie: movie, job: 'Writer', details: info[:details]

          if credit.valid?
            count += 1
            total_count += 1
          end
        end
        log.puts %(Added #{count} writer(s) to "#{movie.title}").color(:green)
      end
    end

    bar.finish
    puts "\n\n"
    puts "Added #{total_count} writers.".color(:green)
  end

  desc 'Grabs composers for movies'
  task composers: :environment do
    log = log_file 'composers'
    bar = progress_bar 'Composers'
    diggler = DirkDiggler.new ''
    total_count = 0

    Movie.includes(:counter).each do |movie|
      bar.inc
      diggler.refresh movie.imdb_url
      diggler.get :composers
      composers = diggler.composers

      if composers.empty?
        log.puts %(Could not find composers for "#{movie.title}").color(:red)
      elsif composers.count == movie.number_of_composing_credits
        log.puts %("#{movie.title}" is up to date.).color(:yellow)
      else
        count = 0
        composers.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          credit = person.composing_credits.create movie: movie, job: 'Composer', details: info[:details]

          if credit.valid?
            count += 1
            total_count += 1
          end
        end
        log.puts %(Added #{count} composer(s) to "#{movie.title}").color(:green)
      end
    end

    bar.finish
    puts "\n\n"
    puts "Added #{total_count} composers.".color(:green)
  end

  desc 'Grabs editors for movies'
  task editors: :environment do
    log = log_file 'editors'
    bar = progress_bar 'Editors'
    diggler = DirkDiggler.new ''
    total_count = 0

    Movie.includes(:counter).each do |movie|
      bar.inc
      diggler.refresh movie.imdb_url
      diggler.get :editors
      editors = diggler.editors

      if editors.empty?
        log.puts %(Could not find editors for "#{movie.title}").color(:red)
      elsif editors.count == movie.number_of_editing_credits
        log.puts %("#{movie.title}" is up to date.).color(:yellow)
      else
        count = 0
        editors.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          credit = person.editing_credits.create movie: movie, job: 'Editor', details: info[:details]

          if credit.valid?
            count += 1
            total_count += 1
          end
        end
        log.puts %(Added #{count} editor(s) to "#{movie.title}").color(:green)
      end
    end

    bar.finish
    puts "\n\n"
    puts "Added #{total_count} editors.".color(:green)
  end

  desc 'Grabs cinematographers for movies'
  task cinematographers: :environment do
    log = log_file 'cinematographers'
    bar = progress_bar 'Cinematographers'
    diggler = DirkDiggler.new ''
    total_count = 0

    Movie.includes(:counter).each do |movie|
      bar.inc
      diggler.refresh movie.imdb_url
      diggler.get :cinematographers
      cinematographers = diggler.cinematographers

      if cinematographers.empty?
        log.puts %(Could not find cinematographers for "#{movie.title}").color(:red)
      elsif cinematographers.count == movie.number_of_cinematography_credits
        log.puts %("#{movie.title}" is up to date.).color(:yellow)
      else
        count = 0
        cinematographers.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          credit = person.cinematography_credits.create movie: movie, job: 'Cinematographer', details: info[:details]

          if credit.valid?
            count += 1
            total_count += 1
          end
        end
        log.puts %(Added #{count} cinematographer(s) to "#{movie.title}").color(:green)
      end
    end

    bar.finish
    puts "\n\n"
    puts "Added #{total_count} cinematographers.".color(:green)
  end

  desc 'Grabs actors for movies'
  task actors: 'environment' do
    log = log_file 'actors'
    bar = progress_bar 'Actors'
    diggler = DirkDiggler.new ''
    total_count = 0

    Movie.includes(:counter).each do |movie|
      bar.inc
      diggler.refresh movie.imdb_url
      diggler.get :actors
      actors = diggler.actors

      if actors.empty?
        log.puts %(Could not find actors for "#{movie.title}").color(:red)
      elsif actors.count == movie.number_of_acting_credits
        log.puts %("#{movie.title}" is up to date.).color(:yellow)
      else
        count = 0
        actors.each do |imdb_url, info|
          person = Person.find_or_create_by_imdb_url imdb_url
          person.update_attribute(:name, info[:name]) if person.name.blank?
          credit = person.acting_credits.create movie: movie, job: 'Actor', details: info[:details]

          if credit.valid?
            count += 1
            total_count += 1
          end
        end
        log.puts %(Added #{count} actor(s) to "#{movie.title}").color(:green)
      end
    end

    bar.finish
    puts "\n\n"
    puts "Added #{total_count} actors.".color(:green)
  end
end
