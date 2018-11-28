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

  has_many :movies, -> { distinct }, through: 'credits'

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

  def movie_ids
    movies.map(&:id)
  end

  # def movie_history
  #   averages = { name: 'Average Rating', data: [] }
  #   totals = { name: 'Total Movies', data: [] }

  #   Movie.where('id IN (?)', movie_ids).select('year, AVG(rating) AS average, COUNT(*) AS total').group(:year).order(:year).each do |row|
  #     averages[:data] << [row.year, row.average.round(2)]
  #     totals[:data] << [row.year, row.total]
  #   end

  #   [averages, totals]
  # end

  # def movie_ratings_history
  #   Movie.where('id IN (?)', movie_ids).select('rating, COUNT(*) AS total').group(:rating).each_with_object({}) do |row, hash|
  #     hash[row.rating] = row.total
  #   end
  # end

  def movie_credits_column_chart_data
    years = movies.pluck(:year).each_with_object(Hash.new(0)) do |year, hash|
      hash[year] += 1
    end

    empty_years = (years.keys.first..years.keys.last).each_with_object({}) do |year, hash|
      hash[year] = 0
    end

    empty_years.merge(years).sort
  end

  def movie_ratings_pie_chart_data
    ratings = movies.pluck(:rating).each_with_object(Hash.new(0)) do |rating, hash|
      hash[rating] += 1
    end

    data = ratings.each_with_object([]) do |rating, array|
      array << {
        name: rating.first,
        y: rating.last
      }
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
    people = people.where('movie_id IN (?) AND person_id <> ?', movies.pluck(:id), id)
    people = people.group(:person_id)
    people = people.order('COUNT(DISTINCT(movie_id)) DESC')
    people = people.limit(limit)
  end

  def score
    ratings = movies.pluck :rating
    total = ratings.inject(0) { |sum, n| sum + (n * RATING_WEIGHTS[n]) }
    count = ratings.inject(0) { |sum, n| sum + RATING_WEIGHTS[n] }

    format('%.2f', total / count.to_f).to_f
  end

  def approval_percentage
    (movies.where('rating >= 6').count / movies.count.to_f * 100).ceil rescue 0
  end

  def self.[](name)
    find_by_name name
  end

  private

  def create_permalink
    return if permalink.present?

    return if name.blank?

    result = name.to_permalink
    dup_count = Person.where(name: name).count
    result << "-#{dup_count + 1}" unless dup_count.zero?

    self.permalink = result
  end

  def create_sort_name
    return if sort_name.present?

    self.sort_name = name.to_sort_column
  end
end
