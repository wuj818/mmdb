class Person < ActiveRecord::Base
  include CreditScopesAndCounts

  validates :name,
    presence: true

  validates :imdb_url,
    presence: true,
    uniqueness: true

  validates :permalink,
    uniqueness: true

  before_save :create_permalink

  before_save :create_sort_name

  has_many :credits, dependent: :destroy

  has_one :counter, as: 'countable', dependent: :destroy

  RATING_WEIGHTS = {
    0 => 16,
    1 => 16,
    2 => 4,
    3 => 4,
    4 => 2,
    5 => 2,
    6 => 1,
    7 => 1,
    8 => 2,
    9 => 4,
    10 => 16
  }

  def to_param
    self.permalink
  end

  %w(directing writing composing editing cinematography acting).each do |credit_type|
    define_method "sorted_#{credit_type}_credits" do
      self.send("#{credit_type}_credits").joins(:movie).order('year DESC')
    end
  end

  def movies
    Movie.joins(:credits).where('credits.person_id = ?', self.id).group('movie_id')
  end

  def movie_ids
    self.movies.map(&:id)
  end

  def movie_history
    Movie.where('id IN (?)', self.movie_ids).select('year, AVG(rating) AS average, COUNT(*) AS total').group(:year).order(:year)
  end

  def movie_ratings_history
    Movie.where('id IN (?)', self.movie_ids).select('rating, COUNT(*) AS total').group(:rating)
  end

  def relevant_genres(limit = 5)
    self.movies.genre_counts.order('count DESC').limit(limit)
  end

  def relevant_languages(limit = 5)
    self.movies.language_counts.order('count DESC').limit(limit)
  end

  def relevant_countries(limit = 5)
    self.movies.country_counts.order('count DESC').limit(limit)
  end

  def keywords
    self.movies.keyword_counts
  end

  def relevant_keywords(limit = 10)
    self.keywords.order('count DESC').limit(limit)
  end

  def frequent_collaborators(limit = 25)
    people = Person.select('people.id, name, permalink, COUNT(DISTINCT(movie_id)) AS count')
    people = people.joins(:credits)
    people = people.where('movie_id IN (?) AND person_id <> ?', self.movies.map(&:id), self.id)
    people = people.group(:person_id)
    people = people.order('COUNT(DISTINCT(movie_id)) DESC')
    people = people.limit(limit)
  end

  def score
    ratings = self.movies.map(&:rating)
    total = ratings.inject(0) { |sum, n| sum + (n * RATING_WEIGHTS[n]) }
    count = ratings.inject(0) { |sum, n| sum + RATING_WEIGHTS[n] }

    format('%.2f', total / count.to_f).to_f
  end

  def approval_percentage
    (self.movies.where('rating >= 6').length / self.movies.length.to_f * 100).ceil rescue 0
  end

  def self.[](name)
    self.find_by_name name
  end

  private

  def create_permalink
    return unless self.permalink.blank?

    return if self.name.blank?

    result = self.name.to_permalink
    dup_count = Person.where(name: self.name).count
    result << "-#{dup_count+1}" unless dup_count == 0

    self.permalink = result
  end

  def create_sort_name
    return unless self.sort_name.blank?

    self.sort_name = self.name.to_sort_column
  end
end
