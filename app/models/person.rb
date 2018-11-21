class Person < ApplicationRecord
  include CreditScopesAndCounts

  validates :name,
    presence: true

  validates :imdb_url,
    presence: true,
    uniqueness: true

  validates :permalink,
    uniqueness: true

  after_create :create_counter

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
    permalink
  end

  %w[directing writing composing editing cinematography acting].each do |credit_type|
    define_method "sorted_#{credit_type}_credits" do
      send("#{credit_type}_credits").joins(:movie).order('year DESC')
    end
  end

  def movies
    Movie.joins(:credits).where('credits.person_id = ?', id).group('movie_id')
  end

  def movie_ids
    movies.map(&:id)
  end

  def movie_history
    averages = { name: 'Average Rating', data: [] }
    totals = { name: 'Total Movies', data: [] }

    Movie.where('id IN (?)', movie_ids).select('year, AVG(rating) AS average, COUNT(*) AS total').group(:year).order(:year).each do |row|
      averages[:data] << [row.year, row.average.round(2)]
      totals[:data] << [row.year, row.total]
    end

    [averages, totals]
  end

  def movie_ratings_history
    Movie.where('id IN (?)', movie_ids).select('rating, COUNT(*) AS total').group(:rating).inject({}) do |hash, row|
      hash[row.rating] = row.total
      hash
    end
  end

  def relevant_genres(limit = 5)
    movies.genre_counts.order('count DESC').limit(limit)
  end

  def relevant_languages(limit = 5)
    movies.language_counts.order('count DESC').limit(limit)
  end

  def relevant_countries(limit = 5)
    movies.country_counts.order('count DESC').limit(limit)
  end

  def keywords
    movies.keyword_counts
  end

  def relevant_keywords(limit = 10)
    keywords.order('count DESC').limit(limit)
  end

  def frequent_collaborators(limit = 25)
    people = Person.select('people.id, name, permalink, COUNT(DISTINCT(movie_id)) AS count')
    people = people.joins(:credits)
    people = people.where('movie_id IN (?) AND person_id <> ?', movies.map(&:id), id)
    people = people.group(:person_id)
    people = people.order('COUNT(DISTINCT(movie_id)) DESC')
    people = people.limit(limit)
  end

  def score
    ratings = movies.map(&:rating)
    total = ratings.inject(0) { |sum, n| sum + (n * RATING_WEIGHTS[n]) }
    count = ratings.inject(0) { |sum, n| sum + RATING_WEIGHTS[n] }

    format('%.2f', total / count.to_f).to_f
  end

  def approval_percentage
    (movies.where('rating >= 6').length / movies.length.to_f * 100).ceil rescue 0
  end

  def self.[](name)
    find_by_name name
  end

  private

  def create_permalink
    return unless permalink.blank?

    return if name.blank?

    result = name.to_permalink
    dup_count = Person.where(name: name).count
    result << "-#{dup_count + 1}" unless dup_count == 0

    self.permalink = result
  end

  def create_sort_name
    return unless sort_name.blank?

    self.sort_name = name.to_sort_column
  end
end
