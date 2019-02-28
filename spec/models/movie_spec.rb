require 'rails_helper'

describe Movie do
  it_behaves_like 'a creditable object' do
    let(:object) { Movie.new }
  end

  it_behaves_like 'a countable object' do
    let(:object) { create :movie }
  end

  describe 'Defaults' do
    let(:movie) { Movie.new }

    it 'has a default rating of 5' do
      expect(movie.rating).to eq 5
    end

    it 'has a default runtime of 0' do
      expect(movie.runtime).to eq 0
    end

    it 'has a default credits count of 0' do
      expect(movie.credits_count).to eq 0
    end
  end

  describe 'Validations' do
    let(:empty_movie) { Movie.create }
    let(:movie) { create :movie }

    it 'has required attributes' do
      %i[title imdb_url year].each do |attribute|
        expect(empty_movie.errors[attribute]).to include "can't be blank"
      end
    end

    it 'has a unique title/year combination' do
      @duplicate_movie = build :movie

      @duplicate_movie.title = movie.title
      @duplicate_movie.year = movie.year

      expect(@duplicate_movie).not_to be_valid
    end

    it 'has a unique IMDB url' do
      empty_movie.imdb_url = movie.imdb_url

      empty_movie.save

      expect(empty_movie.errors[:imdb_url]).to include 'has already been taken'
    end

    it 'has a unique permalink' do
      empty_movie.permalink = movie.permalink

      empty_movie.save

      expect(empty_movie.errors[:permalink]).to include 'has already been taken'
    end

    it 'has a valid year (1890..3000)' do
      [1889, 3001].each do |year|
        movie.year = year
        expect(movie).not_to be_valid
      end

      movie.year = 2000
      expect(movie).to be_valid
    end

    it 'has a valid rating (0..10)' do
      [-1, 11].each do |rating|
        movie.rating = rating
        expect(movie).not_to be_valid
      end

      movie.rating = 10
      expect(movie).to be_valid
    end

    it 'has a valid runtime (0..300)' do
      [-8, 301].each do |runtime|
        movie.runtime = runtime
        expect(movie).not_to be_valid
      end

      movie.runtime = 120
      expect(movie).to be_valid
    end
  end

  describe 'Callbacks' do
    describe 'Permalink creation' do
      it 'automatically creates a permalink from the title' do
        @movie = build :movie, title: 'Boogie Nights'
        expect(@movie.permalink).to be_blank

        @movie.save

        expect(@movie.permalink).to eq 'boogie-nights'
      end

      it 'resolves duplicates by appending the year to the permalink and the title' do
        @movie1 = create :movie, title: 'The Fly', year: 1958
        expect(@movie1.permalink).to eq 'the-fly'

        @movie2 = create :movie, title: 'The Fly', year: 1986
        expect(@movie2.title).to eq 'The Fly (1986)'
        expect(@movie2.permalink).to eq 'the-fly-1986'
      end

      it 'is case sensitive' do
        @movie1 = create :movie, title: 'Robocop', year: 1987
        expect(@movie1.permalink).to eq 'robocop'

        @movie2 = create :movie, title: 'RoboCop', year: 2014
        expect(@movie2.permalink).to eq 'robocop-2014'
      end
    end

    describe 'Sort title creation' do
      it 'copies a lowercase transliterated version of the title if the sort title is blank' do
        @movie = build :movie
        expect(@movie.sort_title).to be_blank

        @movie.save

        expect(@movie.sort_title).to eq @movie.title.to_sort_column
      end
    end
  end

  describe 'Scraping methods' do
    let(:movie) { Movie.new }

    describe '#get_preliminary_info' do
      it 'scrapes IMDB for general information about the movie (title, year, etc)' do
        fake_diggler = instance_double(
          DirkDiggler,
          get: true,
          data: {
            imdb_url: 'http://www.imdb.com/title/tt0118749/',
            title: 'Boogie Nights'
          }
        )

        allow(DirkDiggler).to receive(:new).and_return(fake_diggler)

        movie.get_preliminary_info
        movie.save

        expect(movie.imdb_url).to eq('http://www.imdb.com/title/tt0118749/')
        expect(movie.title).to eq('Boogie Nights')
      end

      it 'can only be called on new records' do
        movie = create(:movie)
        expect(movie.get_preliminary_info).to be(false)
      end
    end
  end
end
