require 'spec_helper'

describe Movie do
  describe 'Defaults' do
    before { @movie = Movie.new }

    it 'has a default rating of 0' do
      @movie.rating.should == 0
    end

    it 'has a default runtime of 0' do
      @movie.runtime.should == 0
    end
  end

  describe 'Validations' do
    before do
      @empty_movie = Movie.create
      @movie = Movie.make!
    end

    it 'has required attributes' do
      [:title, :imdb_url, :year].each do |attribute|
        @empty_movie.errors[attribute].should include "can't be blank"
      end
    end

    it 'has a unique title/year combination' do
      @duplicate_movie = Movie.make
      @duplicate_movie.title = @movie.title
      @duplicate_movie.year = @movie.year
      @duplicate_movie.should_not be_valid
    end

    it 'has a unique IMDB url' do
      @empty_movie.imdb_url = @movie.imdb_url
      @empty_movie.save
      @empty_movie.errors[:imdb_url].should include 'has already been taken'
    end

    it 'has a unique permalink' do
      @empty_movie.permalink = @movie.permalink
      @empty_movie.save
      @empty_movie.errors[:permalink].should include 'has already been taken'
    end

    it 'has a valid year (1890..3000)' do
      [1889, 3001, 'foo'].each do |year|
        @movie.year = year
        @movie.should_not be_valid
      end

      @movie.year = 2000
      @movie.should be_valid
    end

    it 'has a valid rating (0..10)' do
      [-1, 11, 9000].each do |rating|
        @movie.rating = rating
        @movie.should_not be_valid
      end

      @movie.rating = 10
      @movie.should be_valid
    end

    it 'has a valid runtime (0..300)' do
      [-1, -8, 301].each do |runtime|
        @movie.runtime = runtime
        @movie.should_not be_valid
      end

      @movie.runtime = 120
      @movie.should be_valid
    end
  end

  describe 'Callbacks' do
    describe 'Permalink creation' do
      it 'automatically creates a permalink from the title' do
        @movie = Movie.make(:title => 'Boogie Nights')
        @movie.permalink.should be_blank
        @movie.save
        @movie.permalink.should == 'boogie-nights'
      end

      it 'resolves duplicates by appending the year to the permalink and the title' do
        @movie1 = Movie.make!(:title => 'The Fly', :year => 1958)
        @movie1.permalink.should == 'the-fly'
        @movie2 = Movie.make!(:title => 'The Fly', :year => 1986)
        @movie2.title.should == 'The Fly (1986)'
        @movie2.permalink.should == 'the-fly-1986'
      end
    end

    describe 'Sort title creation' do
      it 'copies a lowercase version of the title if the sort title is blank' do
        @movie = Movie.make
        @movie.sort_title.should be_blank
        @movie.save
        @movie.sort_title.should == @movie.title.downcase
      end
    end
  end
end
