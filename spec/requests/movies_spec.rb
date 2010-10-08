require 'spec_helper'

describe 'Movies' do
  describe 'Show all movies' do
    it 'lists all movies' do
      movies = Movie.make! 3
      visit root_path
      movies.each { |movie| should_see_link movie.title }
    end
  end

  describe 'Add new movie' do
    before { visit new_movie_path }

    context 'with valid info' do
      it 'adds a movie and redirects to the index' do
        fill_in 'Title', :with => 'Boogie Nights'
        fill_in 'IMDB', :with => 'http://www.imdb.com/title/tt0118749/'
        fill_in 'Year', :with => '1997'
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

  describe 'Show movie details' do
    it 'shows the details for a movie' do
      movie = Movie.make!
      visit movie_path movie
      should_see movie.title
      should_see movie.year.to_s
      should_see "#{movie.rating}/10"
      link('IMDB')[:href].should == movie.imdb_url
    end
  end

  describe 'Edit movie' do
    before do
      @movie = Movie.make!
      visit edit_movie_path @movie
    end

    context 'with valid info' do
      it 'edits a movie and redirects to its page' do
        should_see %(Editing "#{@movie.title}")
        field('Title').value.should == @movie.title
        field('IMDB').value.should == @movie.imdb_url

        fill_in 'Title', :with => 'Boogie Nights'
        fill_in 'IMDB', :with => 'http://www.imdb.com/title/tt0118749/'
        fill_in 'Year', :with => '1997'
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

  describe 'Delete movie' do
    it 'deletes the movie and redirects to the index page' do
      movie = Movie.make!
      title = movie.title

      visit movies_path
      visit movie_path movie

      click_link 'Delete'

      should_be_on movies_path
      should_see %("#{title}" was successfully deleted.)
    end
  end
end
