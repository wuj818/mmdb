class Movie < ActiveRecord::Base
  validates :title,
    :presence => true

  validates :imdb_url,
    :presence => true,
    :uniqueness => true
end
