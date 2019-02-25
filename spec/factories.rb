FactoryBot.define do
  factory :movie do
    sequence(:title) { |n| "Movie #{n}" }
    sequence(:imdb_url) { |n| "http://www.imdb.com/title/#{n}/" }
    year { 2000 }
    rating { 8 }
    runtime { 155 }
  end

  factory :person do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:imdb_url) { |n| "http://www.imdb.com/name/#{n}/" }
  end

  factory :credit do
    job { 'Director' }
    person
    movie
  end

  factory :counter do
    directing_credits_count { 0 }
    writing_credits_count { 0 }
    composing_credits_count { 0 }
    editing_credits_count { 0 }
    cinematography_credits_count { 0 }
    acting_credits_count { 0 }
  end
end
