require 'mechanize'

class DirkDiggler
  ITEMS = [
    # general info
    :title, :aka, :year, :runtime, :blurb,
    # tags
    :genres, :keywords, :languages, :countries,
    # people
    :directors, :writers, :composers, :editors, :cinematographers, :actors ]

  ITEMS.each { |item| attr_reader item }
  attr_reader :target

  IMDB_URL = 'http://www.imdb.com'

  def initialize(target)
    @target = target
    @target << '/' unless @target[-1] == '/'
    @agent = Mechanize.new
    @agent.user_agent = 'Dirk Diggler'
    @page = @agent.get @target
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
    @title = @page.at('title').text.gsub(/ \(\d{4}\) - IMDb/, '') rescue ''
  end

  def get_aka
    @aka = @page.at('.title-extra').text.delete("\n").gsub(' (original title)', '') rescue ''
  end

  def get_year
    @year = @page.at('h1 > span > a').text.to_i rescue 0
  end

  def get_runtime
    @runtime = @page.at('.infobar').text.scan(/\d+/).first.to_i rescue 0
  end

  def get_blurb
    @blurb = @page.at('#overview-top p + p').text.strip rescue ''
  end

  def get_genres
    @genres = @page.links_with(:href => %r(/genre/[\w-])).map(&:text).uniq.sort rescue []
  end

  def get_keywords
    page = @agent.get "#{@target}keywords"
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
    page = @agent.get "#{@target}fullcredits"
    links = page.at('a[name="directors"]').parent.parent.parent.parent.search('a[href^="/name/"]') rescue return
    links.each do |link|
      url = "#{IMDB_URL}#{link[:href]}"
      @directors[url] = {}
      @directors[url][:name] = link.text
      @directors[url][:detail] = link.parent.parent.search('td')[2].text.strip
    end
  end

  def get_writers
    @writers = {}
    page = @agent.get "#{@target}fullcredits"
    links = page.at('a[name="writers"]').parent.parent.parent.parent.search('a[href^="/name/"]') rescue return
    links.each do |link|
      url = "#{IMDB_URL}#{link[:href]}"
      @writers[url] = {}
      @writers[url][:name] = link.text
      @writers[url][:detail] = link.parent.parent.search('td')[2].text.strip
    end
  end

  def get_composers
    @composers = {}
    page = @agent.get "#{@target}fullcredits"
    links = page.at('a[name="music_original"]').parent.parent.parent.parent.search('a[href^="/name/"]') rescue return
    links.each do |link|
      url = "#{IMDB_URL}#{link[:href]}"
      @composers[url] = {}
      @composers[url][:name] = link.text
      @composers[url][:detail] = link.parent.parent.search('td')[2].text.strip
    end
  end

  def get_editors
    @editors = {}
    page = @agent.get "#{@target}fullcredits"
    links = page.at('a[name="editors"]').parent.parent.parent.parent.search('a[href^="/name/"]') rescue return
    links.each do |link|
      url = "#{IMDB_URL}#{link[:href]}"
      @editors[url] = {}
      @editors[url][:name] = link.text
      @editors[url][:detail] = link.parent.parent.search('td')[2].text.strip
    end
  end

  def get_cinematographers
    @cinematographers = {}
    page = @agent.get "#{@target}fullcredits"
    links = page.at('a[name="cinematographers"]').parent.parent.parent.parent.search('a[href^="/name/"]') rescue return
    links.each do |link|
      url = "#{IMDB_URL}#{link[:href]}"
      @cinematographers[url] = {}
      @cinematographers[url][:name] = link.text
      @cinematographers[url][:detail] = link.parent.parent.search('td')[2].text.strip
    end
  end

  def get_actors
    @actors = {}
    page = @agent.get "#{@target}fullcredits"
    rows = page.search('.cast').search('tr') rescue return
    rows.each do |row|
      link = row.at('.nm').children.search('a[href^="/name/"]').first rescue next
      url = "#{IMDB_URL}#{link[:href]}"
      @actors[url] = {}
      @actors[url][:name] = link.text
      @actors[url][:detail] = link.parent.parent.search('td.char').text.strip
    end
  end
end
