require 'mechanize'

class DirkDiggler
  ITEMS = [
    # general info
    :title, :aka, :year, :runtime, :rotten_tomatoes_url, :synopsis, :movie_poster_db_url, :poster_url,
    # tags
    :genres, :keywords, :languages, :countries,
    # people
    :directors, :writers, :composers, :editors, :cinematographers, :actors
  ]

  ITEMS.each { |item| attr_accessor item }
  attr_reader :target

  IMDB = 'https://www.imdb.com'

  def initialize(target)
    @target = target
    @target.gsub! /\?.*/, ''
    @target << '/' unless @target[-1] == '/'
    @agent = Mechanize.new
    @agent.user_agent = 'Dirk Diggler'
    @page = @agent.get @target rescue nil
  end

  def refresh(target)
    @target = target
    @page = @agent.get @target rescue nil
  end

  def get(*items)
    items = ITEMS if items.first == :all
    items.each { |item| send "get_#{item}" }
  end

  def data
    result = { imdb_url: @target }
    ITEMS.each { |item| result[item] = send(item) if send(item).present? }
    result
  end

  private

  def get_title
    @title = @page.search('head title').text.gsub(/ \(\d{4}\) - IMDb/, '') rescue nil
  end

  def get_aka
    @aka = @page.search('.originalTitle').text.gsub('(original title)', '').squish rescue nil
  end

  def get_year
    @year = @page.search('#titleYear a').text.to_i rescue nil
  end

  def get_runtime
    @runtime = @page.search('time').last.text.squish.to_i rescue nil
  end

  def get_rotten_tomatoes_url
    get_title if title.blank?
    get_year if year.blank?

    query = CGI.escape "rotten tomatoes #{title} #{year}"
    page = @agent.get("https://www.google.com/search?q=#{query}") rescue return
    url = page.link_with href: %r{https://www.rottentomatoes.com/m/[\w-]+/}

    @rotten_tomatoes_url = url.href.gsub!('/url?q=', '').gsub!(/&.+/, '') rescue nil
  end

  def get_synopsis
    get_rotten_tomatoes_url if rotten_tomatoes_url.blank?

    page = @agent.get(rotten_tomatoes_url) rescue return
    result = page.search('#movieSynopsis').text.squish rescue ''

    @synopsis = result
  end

  def get_movie_poster_db_url
    get_title if title.blank?
    get_year if year.blank?

    query = CGI.escape "cinematerial #{title} #{year}"
    page = @agent.get("https://www.google.com/search?q=#{query}") rescue return
    url = page.link_with href: %r{https://www.cinematerial.com/movies/[\w-]+}

    @movie_poster_db_url = url.href.gsub!('/url?q=', '').gsub!(/&.+/, '') rescue nil
  end

  def get_poster_url
    get_movie_poster_db_url if movie_poster_db_url.blank?

    page = @agent.get(movie_poster_db_url) rescue return
    url = page.search('.flag-US').first.parent.parent.search('img').first[:src] rescue return

    url.gsub! /-\w+\.jpg/, '.jpg'
    url.gsub! %r{/\d+x/}, '/500x/'

    @poster_url = url
  end

  def get_genres
    @genres = @page.links_with(href: %r{genres=}).map(&:text).map(&:squish).uniq.sort rescue []
  end

  def get_keywords
    page = @agent.get("#{@target}keywords") rescue return
    @keywords = page.links_with(href: %r{/keyword/\w}).map(&:text).map(&:squish).uniq.sort rescue []
  end

  def get_languages
    @languages = @page.links_with(href: %r{primary_language=}).map(&:text).map(&:squish).uniq.sort rescue []
  end

  def get_countries
    @countries = @page.links_with(href: %r{country_of_origin=}).map(&:text).map(&:squish).sort rescue []
  end

  def get_directors
    @directors = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    rows = page.search('h4:contains("Directed") + table tr') rescue return
    rows.each do |row|
      begin
        link = row.search('a').first
        url = "#{IMDB}#{link[:href].gsub /\?.*/, ''}"
      rescue
        next
      end

      @directors[url] = {}
      @directors[url][:name] = row.search('.name').text.squish
      @directors[url][:details] = row.search('.credit').text.squish
    end
  end

  def get_writers
    @writers = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    rows = page.search('h4:contains("Writing") + table tr') rescue return
    rows.each do |row|
      begin
        link = row.search('a').first
        url = "#{IMDB}#{link[:href].gsub /\?.*/, ''}"
      rescue
        next
      end

      @writers[url] = {}
      @writers[url][:name] = row.search('.name').text.squish
      @writers[url][:details] = row.search('.credit').text.squish
    end
  end

  def get_composers
    @composers = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    rows = page.search('h4:contains("Music by") + table tr') rescue return
    rows.each do |row|
      begin
        link = row.search('a').first
        url = "#{IMDB}#{link[:href].gsub /\?.*/, ''}"
      rescue
        next
      end

      @composers[url] = {}
      @composers[url][:name] = row.search('.name').text.squish
      @composers[url][:details] = row.search('.credit').text.squish
    end
  end

  def get_editors
    @editors = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    rows = page.search('h4:contains("Film Editing") + table tr') rescue return
    rows.each do |row|
      begin
        link = row.search('a').first
        url = "#{IMDB}#{link[:href].gsub /\?.*/, ''}"
      rescue
        next
      end

      @editors[url] = {}
      @editors[url][:name] = row.search('.name').text.squish
      @editors[url][:details] = row.search('.credit').text.squish
    end
  end

  def get_cinematographers
    @cinematographers = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    rows = page.search('h4:contains("Cinematography") + table tr') rescue return
    rows.each do |row|
      begin
        link = row.search('a').first
        url = "#{IMDB}#{link[:href].gsub /\?.*/, ''}"
      rescue
        next
      end

      @cinematographers[url] = {}
      @cinematographers[url][:name] = row.search('.name').text.squish
      @cinematographers[url][:details] = row.search('.credit').text.squish
    end
  end

  def get_actors
    @actors = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    rows = page.search('.cast_list tr') rescue return
    rows.each do |row|
      begin
        link = row.search('a').first
        url = "#{IMDB}#{link[:href].gsub /\?.*/, ''}"

        name = row.search('td')[1].text.squish
        details = row.search('.character').text.squish
      rescue
        next
      end

      @actors[url] = {}
      @actors[url][:name] = name
      @actors[url][:details] = details
    end
  end

  def get_info
    get :title, :aka, :year, :runtime, :rotten_tomatoes_url, :synopsis, :movie_poster_db_url, :poster_url
  end

  def get_tags
    get :genres, :keywords, :languages, :countries
  end
end
