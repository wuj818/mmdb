require 'machinist/active_record'

Movie.blueprint do
  title    { "Movie #{sn}" }
  imdb_url { "http://www.imdb.com/title/#{sn}/" }
  year     { 2000 }
  rating   { 8 }
  runtime  { 155 }
end
