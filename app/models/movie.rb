class Movie < ApplicationRecord
  include CreditScopesAndCounts

  acts_as_taggable_on :genres, :keywords, :languages, :countries

  validates :title,
    presence: true,
    uniqueness: {
      scope: 'year',
      message: 'or Title/Year combination has already been taken'
    }

  validates :imdb_url,
    presence: true,
    uniqueness: true

  validates :year,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 1890,
      less_than_or_equal_to: 3000
    }

  validates :rating,
    inclusion: { in: 0..10, message: 'is invalid' }

  validates :runtime,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 300
    }

  validates :permalink, uniqueness: true

  after_create :create_counter

  before_save :create_permalink

  before_save :create_sort_title

  before_validation :save_remote_poster, if: -> { poster_url_changed? && poster_url.present? }
  before_validation :delete_poster, if: -> { poster_url.blank? }

  has_many :credits, dependent: :destroy

  has_one :counter, as: 'countable', dependent: :destroy

  has_many :listings, dependent: :destroy

  has_attached_file :poster,
    styles: { large: '300x420!', medium: '150x210!', tiny: '20x28!' },
    default_url: ':asset_default_url',
    path: '/posters/:style/:id/:filename'

  validates_attachment_content_type :poster, content_type: /\Aimage\/.*\z/

  before_post_process :shorten_filename

  GENRES = %w[
    Action       Adventure  Animation  Biography  Comedy     Crime
    Documentary  Drama      Family     Fantasy    Film-Noir  History
    Horror       Music      Musical    Mystery    Romance    Sci-Fi
    Short Sport  Thriller   War        Western
  ]

  def to_param
    permalink
  end

  def full_title
    title.match(/\(\d{4}\)\z/) ? title : "#{title} (#{year})"
  end

  def get_preliminary_info
    return false unless new_record?

    diggler = DirkDiggler.new imdb_url
    diggler.get :info

    self.attributes = diggler.data
  end

  def rate(rating)
    update_attribute :rating, rating
  end

  %w[genre keyword language country].each do |tag_type|
    define_method "add_#{tag_type}" do |*tags|
      send("#{tag_type}_list") << tags
      send("#{tag_type}_list").flatten!

      save validate: false
    end

    define_method "remove_#{tag_type}" do |*tags|
      return if tags.empty?

      original_tags = send "#{tag_type}_list"
      send("#{tag_type}_list=", original_tags - tags)

      save validate: false
    end
  end

  %w[directing writing composing editing cinematography acting].each do |credit_type|
    define_method "sorted_#{credit_type}_credits" do
      send("#{credit_type}_credits").joins(:person).order('sort_name')
    end
  end

  def sorted_keywords
    keywords.order(:name)
  end

  def relevant_keywords(limit = 10)
    keywords = Tagging.select('name, COUNT(*), AVG(rating)')
    keywords = keywords.joins(:tag).joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    keywords = keywords.where('name IN (?)', keyword_list)
    keywords = keywords.group(:name).having('COUNT(*) >= 5')
    keywords = keywords.order('AVG(rating) DESC').limit(limit)
  end

  def related_movies
    keywords = relevant_keywords(25).map(&:name)
    movies = find_related_genres.where('rating >= 7')
    movies = movies.tagged_with(keywords, on: :keywords, any: true).limit(25) rescue []
  end

  def self.[](title)
    find_by_title title
  end

  private

  def create_permalink
    return unless permalink.blank?

    return if title.blank? || year.blank?

    result = title.to_permalink

    unless Movie.where(permalink: result).empty?
      result << "-#{year}"
      title << " (#{year})"
    end

    self.permalink = result
  end

  def create_sort_title
    return unless sort_title.blank?

    self.sort_title = title.to_sort_column
  end

  def save_remote_poster
    self.poster = URI.parse poster_url
  end

  def delete_poster
    self.poster = nil
  end

  def shorten_filename
    short_filename = Digest::SHA2.file(poster.queued_for_write[:original].path).hexdigest[0..2]
    extension = File.extname(poster_file_name).downcase

    poster.instance_write :file_name, "#{short_filename}#{extension}"
  end
end
