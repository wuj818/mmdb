class MovieObserver < ActiveRecord::Observer
  def after_create(movie)
    return if Rails.env.test?

    @diggler = DirkDiggler.new movie.imdb_url

    get_tags movie
    get_people movie
  end

  private

  def get_tags(movie)
    @diggler.get_tags

    movie.genre_list = @diggler.genres
    movie.keyword_list = @diggler.keywords
    movie.language_list = @diggler.languages
    movie.country_list = @diggler.countries

    movie.save
  end

  def get_people(movie)
    @diggler.get :directors, :writers, :composers, :editors, :cinematographers, :actors

    @diggler.directors.each do |imdb_url, info|
      person = Person.find_or_create_by imdb_url: imdb_url
      person.update_attribute(:name, info[:name]) if person.name.blank?
      person.directing_credits.create movie: movie, job: 'Director', details: info[:details]
    end

    @diggler.writers.each do |imdb_url, info|
      person = Person.find_or_create_by imdb_url: imdb_url
      person.update_attribute(:name, info[:name]) if person.name.blank?
      person.writing_credits.create movie: movie, job: 'Writer', details: info[:details]
    end

    @diggler.composers.each do |imdb_url, info|
      person = Person.find_or_create_by imdb_url: imdb_url
      person.update_attribute(:name, info[:name]) if person.name.blank?
      person.composing_credits.create movie: movie, job: 'Composer', details: info[:details]
    end

    @diggler.editors.each do |imdb_url, info|
      person = Person.find_or_create_by imdb_url: imdb_url
      person.update_attribute(:name, info[:name]) if person.name.blank?
      person.editing_credits.create movie: movie, job: 'Editor', details: info[:details]
    end

    @diggler.cinematographers.each do |imdb_url, info|
      person = Person.find_or_create_by imdb_url: imdb_url
      person.update_attribute(:name, info[:name]) if person.name.blank?
      person.cinematography_credits.create movie: movie, job: 'Cinematographer', details: info[:details]
    end

    @diggler.actors.each do |imdb_url, info|
      person = Person.find_or_create_by imdb_url: imdb_url
      person.update_attribute(:name, info[:name]) if person.name.blank?
      person.acting_credits.create movie: movie, job: 'Actor', details: info[:details]
    end
  end
end
