class Movie < ActiveRecord::Base
  validates :title,
    :presence => true

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

  validates :permalink,
    :uniqueness => true

  before_save :create_permalink

  def to_param
    self.permalink
  end

  private

  def create_permalink
    return unless self.permalink.blank?
    result = self.title.to_permalink
    unless Movie.where(:title => self.title).empty?
      result << "-#{self.year}"
      self.title << " (#{self.year})"
    end
    self.permalink = result
  end
end
