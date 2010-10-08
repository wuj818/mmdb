require 'spec_helper'

describe Movie do
  describe 'Defaults' do
    before { @movie = Movie.new }

    it 'has a default rating of 0' do
      @movie.rating.should == 0
    end
  end
  describe 'Validations' do
    before { @movie = Movie.create }

    it 'has required attributes' do
      [:title, :imdb_url, :year].each do |attribute|
        @movie.errors[attribute].should include "can't be blank"
      end
    end

    it 'has a unique IMDB url' do
      movie = Movie.make!
      @movie.imdb_url = movie.imdb_url
      @movie.save
      @movie.errors[:imdb_url].should include 'has already been taken'
    end

    it 'has a valid year (1890..3000)' do
      movie = Movie.make!

      [1889, 3001, 'foo'].each do |year|
        movie.year = year
        movie.should_not be_valid
      end

      movie.year = 2000
      movie.should be_valid
    end

    it 'has a valid rating (0..10)' do
      movie = Movie.make!

      [-1, 11, 9000].each do |rating|
        movie.rating = rating
        movie.should_not be_valid
      end

      movie.rating = 10
      movie.should be_valid
    end
  end
end
