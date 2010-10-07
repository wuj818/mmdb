require 'spec_helper'

describe Movie do
  describe 'Validations' do
    before(:all) do
      @movie = Movie.new
      @movie.save
    end

    it 'has required attributes' do
      [:title, :imdb_url].each do |attribute|
        @movie.errors[attribute].should include "can't be blank"
      end
    end

    it 'has a unique IMDB url' do
      movie = Movie.make!
      @movie.imdb_url = movie.imdb_url
      @movie.save
      @movie.errors[:imdb_url].should include 'has already been taken'
    end
  end
end
