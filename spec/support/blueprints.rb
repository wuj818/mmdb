require 'machinist/active_record'

Movie.blueprint do
  title    { "Movie #{sn}" }
  imdb_url { "http://www.imdb.com/title/#{sn}/" }
end
