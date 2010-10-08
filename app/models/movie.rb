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
end
