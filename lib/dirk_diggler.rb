require 'mechanize'

class DirkDiggler
  ITEMS = [
    # general info
    :title, :aka, :year, :runtime, :rotten_tomatoes_url, :synopsis,
    # tags
    :genres, :keywords, :languages, :countries,
    # people
    :directors, :writers, :composers, :editors, :cinematographers, :actors ]

  ITEMS.each { |item| attr_accessor item }
  attr_reader :target

  IMDB = 'http://www.imdb.com'
  GOOGLE = 'http://google.com'

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
    items.each { |item| self.send "get_#{item}" }
  end

  def data
    result = { :imdb_url => @target }
    ITEMS.each { |item| result[item] = self.send(item) unless self.send(item).nil? }
    result
  end

  private

  def get_title
    @title = @page.search('title').text.gsub(/ \(\d{4}\) - IMDb/, '') rescue nil
  end

  def get_aka
    @aka = @page.search('.title-extra').text.gsub('(original title)', '').strip rescue nil
  end

  def get_year
    @year = @page.search('.header .nobr a').text.to_i rescue nil
  end

  def get_runtime
    @runtime = @page.search('time').first.text.strip.to_i rescue nil
  end

  def get_rotten_tomatoes_url
    get_title if title.nil?
    get_year if year.nil?

    page = @agent.get GOOGLE
    form = page.form_with(:name => 'f')
    form.q = "rotten tomatoes #{title} #{year}"
    search_results = form.submit

    url = search_results.link_with(:href => %r(http://www.rottentomatoes.com/m/[\w-]+/));

    if url.nil?
      form.q = "rotten tomatoes #{title}"
      search_results = form.submit
      url = search_results.link_with(:href => %r(http://www.rottentomatoes.com/m/[\w-]+/))
    end

    @rotten_tomatoes_url = url.href.gsub!('/url?q=', '').gsub!(/&.+/, '') rescue nil
  end

  def get_synopsis
    get_rotten_tomatoes_url if rotten_tomatoes_url.nil?
    page = @agent.get(rotten_tomatoes_url) rescue return
    result = page.at('#movieSynopsis').text rescue ''
    result = result.gsub(/\s{2,}/, ' ').gsub(/\/\*.+/m, '').strip
    @synopsis = result
  end

  def get_genres
    @genres = @page.links_with(:href => %r(/genre/\w)).map(&:text).uniq.sort rescue []
  end

  def get_keywords
    page = @agent.get("#{@target}keywords") rescue return
    @keywords = page.links_with(:href => %r(/keyword/\w)).map(&:text).uniq.sort rescue []
  end

  def get_languages
    @languages = @page.links_with(:href => %r(/language/\w)).map(&:text).uniq.sort rescue []
  end

  def get_countries
    @countries = @page.links_with(:href => %r(/country/\w)).map(&:text).sort rescue []
  end

  def get_directors
    @directors = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    links = page.at('a[name="directors"]').parent.parent.parent.parent.search('a[href^="/name/"]') rescue return
    links.each do |link|
      url = "#{IMDB}#{link[:href]}"
      @directors[url] = {}
      @directors[url][:name] = link.text
      @directors[url][:details] = link.parent.parent.search('td')[2].text.strip
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
      @writers[url][:name] = row.search('.name').text.strip
      @writers[url][:details] = row.search('.credit').text.strip
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
      @composers[url][:name] = row.search('.name').text.strip
      @composers[url][:details] = row.search('.credit').text.strip
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
      @editors[url][:name] = row.search('.name').text.strip
      @editors[url][:details] = row.search('.credit').text.strip
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
      @cinematographers[url][:name] = row.search('.name').text.strip
      @cinematographers[url][:details] = row.search('.credit').text.strip
    end
  end

  def get_actors
    @actors = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    rows = page.search('.cast_list tr') rescue return
    rows.each do |row|
      begin
        link = row.search('.itemprop a').first
        url = "#{IMDB}#{link[:href].gsub /\?.*/, ''}"
      rescue
        next
      end

      @actors[url] = {}
      @actors[url][:name] = link.text.strip.gsub /\s+/, ' '
      @actors[url][:details] = row.search('.character').text.strip.gsub /\s+/, ' '
    end
  end

  def get_info
    get :title, :aka, :year, :runtime, :rotten_tomatoes_url, :synopsis
  end

  def get_tags
    get :genres, :keywords, :languages, :countries
  end
end
