class Movie < ActiveRecord::Base
  include CreditScopesAndCounts

  acts_as_taggable_on :genres, :keywords, :languages, :countries

  validates :title,
    :presence => true,
    :uniqueness => {
      :scope => :year,
      :message => 'or Title/Year combination has already been taken' }

  validates :imdb_url,
    :presence => true,
    :uniqueness => true

  validates :year,
    :presence => true,
    :numericality => {
      :greater_than_or_equal_to => 1890,
      :less_than_or_equal_to => 3000 }

  validates :rating,
    :inclusion => { :in => 0..10, :message => 'is invalid' }

  validates :runtime,
    :presence => true,
    :numericality => {
      :greater_than_or_equal_to => 0,
      :less_than_or_equal_to => 300 }

  validates :permalink, :uniqueness => true

  before_save :create_permalink

  before_save :create_sort_title

  has_many :credits, :include => :person, :dependent => :destroy

  has_one :counter, :as => :countable, :dependent => :destroy

  GENRES = %w(
    Action       Adventure  Animation  Biography  Comedy     Crime
    Documentary  Drama      Family     Fantasy    Film-Noir  History
    Horror       Music      Musical    Mystery    Romance    Sci-Fi
    Short Sport  Thriller   War        Western )

  def to_param
    self.permalink
  end

  def get_preliminary_info
    return false unless new_record?
    diggler = DirkDiggler.new self.imdb_url
    diggler.get :info
    self.attributes = diggler.data
  end

  def rate(rating)
    update_attribute :rating, rating
  end

  %w(genre keyword language country).each do |tag_type|
    define_method "add_#{tag_type}" do |*tags|
      self.send("#{tag_type}_list") << tags
      self.send("#{tag_type}_list").flatten!
      save
    end

    define_method "remove_#{tag_type}" do |*tags|
      return if tags.empty?
      original_tags = self.send "#{tag_type}_list"
      self.send("#{tag_type}_list=", original_tags - tags)
      save
    end
  end

  Credit::JOBS.values.each do |credit_type|
    define_method "sorted_#{credit_type}_credits" do
      self.send("#{credit_type}_credits").joins(:person).order('sort_name')
    end
  end

  def related_movies
    self.find_related_genres.with_keywords(self.keyword_list).limit(25) rescue []
  end

  def self.with_genres(genres)
    tagged_with(genres, :on => :genres, :any => true)
  end

  def self.with_keywords(keywords)
    tagged_with(keywords, :on => :keywords, :any => true)
  end

  def self.with_languages(languages)
    tagged_with(languages, :on => :languages, :any => true)
  end

  def self.with_countries(countries)
    tagged_with(countries, :on => :countries, :any => true)
  end

  def self.[](title)
    self.find_by_title title
  end

  private

  def create_permalink
    return unless self.permalink.blank?
    return if self.title.blank? || self.year.blank?
    result = self.title.to_permalink
    unless Movie.where(:title => self.title).empty?
      result << "-#{self.year}"
      self.title << " (#{self.year})"
    end
    self.permalink = result
  end

  def create_sort_title
    return unless self.sort_title.blank?
    self.sort_title = self.title.to_sort_column
  end
end
