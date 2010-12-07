require 'spec_helper'

describe 'Movies' do
  describe 'All movies page' do
    it 'lists all movies' do
      movies = Movie.make! 3
      visit movies_path
      movies.each { |movie| should_see_link movie.title }
    end

    it 'filters results based on the search parameter' do
      Movie.make! :title => 'Boogie Nights'
      Movie.make! :title => 'Oldboy'

      visit movies_path
      fill_in 'q', :with => 'boogie'
      click_button 'Search'

      should_see_link 'Boogie Nights'
      should_not_see_link 'Oldboy'
    end

    it 'has customizable sorting options' do
      Movie.make! :title => 'The Big Lebowski',
        :year => 1998, :runtime => 117, :rating => 3, :sort_title => 'Big Lebowski, The'
      Movie.make! :title => 'Boogie Nights',
        :year => 1997, :runtime => 155, :rating => 2
      Movie.make! :title => 'Dumb and Dumber',
        :year => 1994, :runtime => 107, :rating => 1

      # ascending title by default
      visit movies_path
      movies = all('td:first-child a').map(&:text)
      movies.should == ['The Big Lebowski', 'Boogie Nights', 'Dumb and Dumber']

      # descending title
      click_link 'Title'
      movies = all('td:first-child a').map(&:text)
      movies.should == ['Dumb and Dumber', 'Boogie Nights', 'The Big Lebowski']

      # ascending year
      click_link 'Year'
      movies = all('td:first-child a').map(&:text)
      movies.should == ['Dumb and Dumber', 'Boogie Nights', 'The Big Lebowski']

      # descending year
      click_link 'Year'
      movies = all('td:first-child a').map(&:text)
      movies.should == ['The Big Lebowski', 'Boogie Nights', 'Dumb and Dumber']
    end

    it 'has pagination info and links' do
      visit movies_path
      should_see 'No movies found'

      @movies = Movie.make! 2
      visit movies_path :per_page => 1

      should_see 'Displaying'
      should_see_link '2'
      should_see_link @movies.first.title
      should_not_see_link @movies.last.title

      click_link '2'
      should_not_see_link @movies.first.title
      should_see_link @movies.last.title
    end
  end

  describe 'Show movie details' do
    it 'shows the details for a movie' do
      movie = Movie.make!
      visit movie_path movie
      should_see movie.title
      should_see movie.year.to_s
      should_see "#{movie.rating}/10"
      should_see "#{movie.runtime} min"
      find('.imdb')[:href].should == movie.imdb_url
    end
  end

  describe 'Edit movie' do
    it 'edits a movie and redirects to its page' do
      @movie = Movie.make!
      integration_login
      visit movie_path @movie
      click_link 'Edit'

      should_see %(Editing "#{@movie.title}")
      should_see_field 'Permalink'
      should_see_field 'Sort Title'
      field('Title').value.should == @movie.title
      field('IMDB').value.should == @movie.imdb_url

      fill_in 'Title', :with => 'Boogie Nights'
      fill_in 'IMDB', :with => 'http://www.imdb.com/title/tt0118749/'
      fill_in 'Year', :with => '1997'
      fill_in 'Runtime', :with => '155'
      select '10', :from => 'Rating'
      check 'movie_genre_drama'
      click_button 'Submit'

      @movie.reload

      should_be_on movie_path @movie
      should_see %("#{@movie.title}" was successfully edited.)
      should_see @movie.title
      find('.imdb')[:href].should == @movie.imdb_url
      should_see 'Drama'
    end
  end

  describe 'Delete movie' do
    it 'deletes the movie and redirects to the movies page' do
      @movie = Movie.make!
      integration_login

      title = @movie.title
      visit movie_path @movie
      click_link 'Delete'
      should_be_on movies_path
      should_see %("#{title}" was successfully deleted.)
    end
  end

  describe 'Add new movie' do
    it 'renders the new movie form with info scraped from IMDB' do
      DirkDiggler.stub :new => mock('DirkDiggler', :get => true,
        :data => {
          :imdb_url => 'http://www.imdb.com/title/tt0118749/',
          :title => 'Boogie Nights',
          :year => 1997 })

      integration_login
      click_link 'Add Movie'

      fill_in 'IMDB', :with => 'http://www.imdb.com/title/tt0118749/'
      click_button 'Submit'

      should_see 'Scrape results for "http://www.imdb.com/title/tt0118749/".'
      field('Title').value.should == 'Boogie Nights'
      field('IMDB').value.should == 'http://www.imdb.com/title/tt0118749/'

      should_not_see_field 'Permalink'
      should_not_see_field 'Sort Title'

      click_button 'Submit'

      should_not_have_css '#error_explanation'
      should_see '"Boogie Nights" was successfully added.'
    end
  end
end
