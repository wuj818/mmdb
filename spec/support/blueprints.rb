require 'machinist/active_record'

Movie.blueprint do
  title    { "Movie #{sn}" }
  imdb_url { "http://www.imdb.com/title/#{sn}/" }
  year     { 2000 }
  rating   { 8 }
  runtime  { 155 }
end

Person.blueprint do
  name     { "Person #{sn}" }
  imdb_url { "http://www.imdb.com/name/#{sn}/" }
end

Credit.blueprint do
  job      { 'Director' }
  person
  movie
end
