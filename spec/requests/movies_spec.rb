require 'spec_helper'

describe 'Movies' do
  describe 'Show all movies' do
    it 'lists all movies' do
      movies = Movie.make! 3
      visit root_path
      movies.each { |movie| should_see_link movie.title }
    end

    it 'has customizable sorting options' do
      Movie.make! :title => 'Boogie Nights',
        :year => 1997, :runtime => 155, :rating => 2
      Movie.make! :title => 'Robocop',
        :year => 1987, :runtime => 102, :rating => 3
      Movie.make! :title => 'Dumb and Dumber',
        :year => 1994, :runtime => 107, :rating => 1

      # ascending title by default
      visit root_path
      movies = all('td:first-child a').map(&:text)
      movies.should == ['Boogie Nights', 'Dumb and Dumber', 'Robocop']

      # descending title
      click_link 'Title'
      movies = all('td:first-child a').map(&:text)
      movies.should == ['Robocop', 'Dumb and Dumber', 'Boogie Nights']

      # ascending year
      click_link 'Year'
      movies = all('td:first-child a').map(&:text)
      movies.should == ['Robocop', 'Dumb and Dumber', 'Boogie Nights']

      # descending year
      click_link 'Year'
      movies = all('td:first-child a').map(&:text)
      movies.should == ['Boogie Nights', 'Dumb and Dumber', 'Robocop']

      # ascending runtime
      click_link 'Runtime'
      movies = all('td:first-child a').map(&:text)
      movies.should == ['Robocop', 'Dumb and Dumber', 'Boogie Nights']

      # descending runtime
      click_link 'Runtime'
      movies = all('td:first-child a').map(&:text)
      movies.should == ['Boogie Nights', 'Dumb and Dumber', 'Robocop']

      # ascending rating
      click_link 'Rating'
      movies = all('td:first-child a').map(&:text)
      movies.should == ['Dumb and Dumber', 'Boogie Nights', 'Robocop']

      # descending rating
      click_link 'Rating'
      movies = all('td:first-child a').map(&:text)
      movies.should == ['Robocop', 'Boogie Nights', 'Dumb and Dumber']
    end

    it 'has pagination info and links' do
      visit root_path
      should_see 'No entries found'

      @movies = Movie.make! 2
      visit root_path :per_page => 1

      should_see 'Displaying movies'
      should_see '2 in total'
      should_see_link '2'
      should_not_see_link @movies.last.title

      click_link '2'
      should_not_see_link @movies.first.title
      should_see_link @movies.last.title
    end
  end

  describe 'Add new movie' do
    context 'when logged in' do
      before do
        integration_login
        visit movies_path
        click_link 'Add Movie'
      end

      context 'with valid info' do
        it 'adds a movie and redirects to the index' do
          should_not_see_field 'Permalink'
          fill_in 'Title', :with => 'Boogie Nights'
          fill_in 'IMDB', :with => 'http://www.imdb.com/title/tt0118749/'
          fill_in 'Year', :with => '1997'
          fill_in 'Runtime', :with => '155'
          select '10', :from => 'Rating'
          click_button 'Submit'

          should_be_on movies_path
          should_not_have_css '#error_explanation'
          should_see '"Boogie Nights" was successfully added.'
        end
      end

      context 'with invalid info' do
        it 'shows an error message' do
          click_button 'Submit'
          should_have_css '#error_explanation'
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        visit new_movie_path
        should_not_be_on new_movie_path
        should_be_on login_path
        should_see 'You must be logged in to access this page.'
      end

      it 'is not shown on the movies page as a link' do
        visit movies_path
        should_not_see_link 'Add Movie'
      end
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
      link('IMDB')[:href].should == movie.imdb_url
    end
  end

  describe 'Edit movie' do
    before { @movie = Movie.make! }

    context 'when logged in' do
      before do
        integration_login
        visit movie_path @movie
        click_link 'Edit'
      end

      context 'with valid info' do
        it 'edits a movie and redirects to its page' do
          should_see %(Editing "#{@movie.title}")
          should_see_field 'Permalink'
          field('Title').value.should == @movie.title
          field('IMDB').value.should == @movie.imdb_url

          fill_in 'Title', :with => 'Boogie Nights'
          fill_in 'IMDB', :with => 'http://www.imdb.com/title/tt0118749/'
          fill_in 'Year', :with => '1997'
          fill_in 'Runtime', :with => '155'
          select '10', :from => 'Rating'
          click_button 'Submit'

          @movie.reload

          should_be_on movie_path @movie
          should_see %("#{@movie.title}" was successfully edited.)
          should_see @movie.title
          link('IMDB')[:href].should == @movie.imdb_url
        end
      end

      context 'with invalid info' do
        it 'shows an error message' do
          fill_in 'Title', :with => ''
          click_button 'Submit'
          should_have_css '#error_explanation'
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        visit edit_movie_path @movie
        should_not_be_on new_movie_path
        should_be_on login_path
        should_see 'You must be logged in to access this page.'
      end

      it 'is not shown on the movie page as a link' do
        visit movie_path @movie
        should_not_see_link 'Edit'
      end
    end
  end

  describe 'Delete movie' do
    before { @movie = Movie.make! }

    context 'when logged in' do
      before { integration_login }

      it 'deletes the movie and redirects to the index page' do
        title = @movie.title
        visit movie_path @movie
        click_link 'Delete'
        should_be_on movies_path
        should_see %("#{title}" was successfully deleted.)
      end
    end

    context 'when not logged in' do
      it 'is not shown on the movie page as a link' do
        visit movie_path @movie
        should_not_see_link 'Delete'
      end
    end
  end
end
