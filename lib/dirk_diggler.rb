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
    @title = @page.at('title').text.gsub(/ \(\d{4}\) - IMDb/, '') rescue nil
  end

  def get_aka
    @aka = @page.at('.title-extra').text.delete("\n").gsub(' (original title)', '') rescue nil
  end

  def get_year
    @year = @page.at('h1 > span > a').text.to_i rescue nil
  end

  def get_runtime
    @runtime = @page.at('.infobar').text.scan(/\d+/).first.to_i rescue nil
  end

  def get_rotten_tomatoes_url
    get_title if title.nil?
    get_year if year.nil?

    page = @agent.get GOOGLE
    form = page.form_with(:name => 'f')
    form.q = "rotten tomatoes #{title} #{year}"
    search_results = form.submit

    url = search_results.link_with(:href => %r(http://www.rottentomatoes.com/m/[\w-]+/\z));

    if url.nil?
      form.q = "rotten tomatoes #{title}"
      search_results = form.submit
      url = search_results.link_with(:href => %r(http://www.rottentomatoes.com/m/[\w-]+/\z))
    end

    @rotten_tomatoes_url = url.href rescue nil
  end

  def get_synopsis
    get_rotten_tomatoes_url if rotten_tomatoes_url.nil?
    page = @agent.get(rotten_tomatoes_url) rescue return
    @synopsis = page.at('#movie_synopsis_all').text rescue nil
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
    links = page.at('a[name="writers"]').parent.parent.parent.parent.search('a[href^="/name/"]') rescue return
    links.each do |link|
      url = "#{IMDB}#{link[:href]}"
      @writers[url] = {}
      @writers[url][:name] = link.text
      @writers[url][:details] = link.parent.parent.search('td')[2].text.strip
    end
  end

  def get_composers
    @composers = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    links = page.at('a[name="music_original"]').parent.parent.parent.parent.search('a[href^="/name/"]') rescue return
    links.each do |link|
      url = "#{IMDB}#{link[:href]}"
      @composers[url] = {}
      @composers[url][:name] = link.text
      @composers[url][:details] = link.parent.parent.search('td')[2].text.strip
    end
  end

  def get_editors
    @editors = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    links = page.at('a[name="editors"]').parent.parent.parent.parent.search('a[href^="/name/"]') rescue return
    links.each do |link|
      url = "#{IMDB}#{link[:href]}"
      @editors[url] = {}
      @editors[url][:name] = link.text
      @editors[url][:details] = link.parent.parent.search('td')[2].text.strip
    end
  end

  def get_cinematographers
    @cinematographers = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    links = page.at('a[name="cinematographers"]').parent.parent.parent.parent.search('a[href^="/name/"]') rescue return
    links.each do |link|
      url = "#{IMDB}#{link[:href]}"
      @cinematographers[url] = {}
      @cinematographers[url][:name] = link.text
      @cinematographers[url][:details] = link.parent.parent.search('td')[2].text.strip
    end
  end

  def get_actors
    @actors = {}
    page = @agent.get("#{@target}fullcredits") rescue return
    rows = page.search('.cast').search('tr') rescue return
    rows.each do |row|
      link = row.at('.nm').children.search('a[href^="/name/"]').first rescue next
      url = "#{IMDB}#{link[:href]}"
      @actors[url] = {}
      @actors[url][:name] = link.text
      @actors[url][:details] = link.parent.parent.search('td.char').text.strip
    end
  end

  def get_info
    get :title, :aka, :year, :runtime, :rotten_tomatoes_url, :synopsis
  end

  def get_tags
    get :genres, :keywords, :languages, :countries
  end
end
