require 'spec_helper'

describe 'Movies' do
  describe 'Show all movies' do
    it 'lists all movies' do
      movies = Movie.make! 3

      visit root_path

      movies.each do |movie|
        should_see_link movie.title
      end
    end
  end

  describe 'Add new movie' do
    it 'adds a movie and redirects to the index' do
      visit new_movie_path

      fill_in 'Title', :with => 'Boogie Nights'
      fill_in 'IMDB', :with => 'http://www.imdb.com/title/tt0118749/'
      click_button 'Submit'

      should_be_on movies_path
      should_see '"Boogie Nights" was successfully added.'
    end
  end

  describe 'Show movie details' do
    it 'shows the details for a movie' do
      movie = Movie.make!

      visit movie_path movie

      should_see movie.title
      link('IMDB')[:href].should == movie.imdb_url
    end
  end

  describe 'Edit movie' do
    it 'edits a movie and redirects to its page' do
      movie = Movie.make!

      visit edit_movie_path movie

      should_see %(Editing "#{movie.title}")
      field('Title').value.should == movie.title
      field('IMDB').value.should == movie.imdb_url

      fill_in 'Title', :with => 'Boogie Nights'
      fill_in 'IMDB', :with => 'http://www.imdb.com/title/tt0118749/'
      click_button 'Submit'

      movie.reload

      should_be_on movie_path movie
      should_see %("#{movie.title}" was successfully edited.)
      should_see movie.title
      link('IMDB')[:href].should == movie.imdb_url
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
