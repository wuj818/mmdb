require 'spec_helper'

describe Movie do
  it_behaves_like 'a creditable object' do
    let(:object) { Movie.new }
  end

  it_behaves_like 'a countable object' do
    let(:object) { Movie.make! }
  end

  describe 'Defaults' do
    before { @movie = Movie.new }

    it 'has a default rating of 0' do
      @movie.rating.should == 0
    end

    it 'has a default runtime of 0' do
      @movie.runtime.should == 0
    end

    it 'has a default credits count of 0' do
      @movie.credits_count.should == 0
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
      [1889, 3001].each do |year|
        @movie.year = year
        @movie.should_not be_valid
      end

      @movie.year = 2000
      @movie.should be_valid
    end

    it 'has a valid rating (0..10)' do
      [-1, 11].each do |rating|
        @movie.rating = rating
        @movie.should_not be_valid
      end

      @movie.rating = 10
      @movie.should be_valid
    end

    it 'has a valid runtime (0..300)' do
      [-8, 301].each do |runtime|
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

  describe 'Scraping methods' do
    before { @movie = Movie.new }

    describe '#get_preliminary_info' do
      it 'scrapes IMDB for general information about the movie (title, year, etc)' do
        DirkDiggler.stub :new => mock('DirkDiggler', :get => true,
          :data => {
            :imdb_url => 'http://www.imdb.com/title/tt0118749/',
            :title => 'Boogie Nights' })

        @movie.get_preliminary_info
        @movie.save
        @movie.imdb_url.should == 'http://www.imdb.com/title/tt0118749/'
        @movie.title.should == 'Boogie Nights'
      end

      it 'can only be called on new records' do
        @movie = Movie.make!
        @movie.get_preliminary_info.should == false
      end
    end
  end

  describe 'Instance methods' do
    before { @movie = Movie.make! }

    describe '#rate(rating)' do
      it 'updates the rating for a movie' do
        @movie.rate 10
        @movie.reload
        @movie.rating.should == 10
      end
    end

    describe 'add_genre(*genres)' do
      before do
        %w(genre keyword language country).each do |tag_type|
          @movie.should respond_to "add_#{tag_type}"
        end
      end

      it "adds the specified genre(s) to a movie's genre list" do
        @movie.add_genre 'Drama'
        @movie.genre_list.should include 'Drama'
        @movie.add_genre 'Comedy', 'Comedy', 'Thriller'
        %w(Drama Comedy Thriller).each do |genre|
          @movie.genre_list.should include genre
        end
      end
    end

    describe 'remove_genre(*genres)' do
      before do
        %w(genre keyword language country).each do |tag_type|
          @movie.should respond_to "remove_#{tag_type}"
        end
      end

      it "removes the specified genre(s) from a movie's genre list" do
        @movie.add_genre 'Drama', 'Comedy', 'Thriller', 'Sci-Fi'
        @movie.remove_genre 'Sci-Fi'
        @movie.genre_list.should_not include 'Sci-Fi'
        @movie.remove_genre 'Drama', 'Comedy'
        %w(Drama Comedy).each do |genre|
          @movie.genre_list.should_not include genre
        end
      end
    end
  end
end
