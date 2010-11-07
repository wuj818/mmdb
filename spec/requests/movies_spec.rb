require 'spec_helper'

describe "Movies" do
  describe "index" do
    it "should list all movies" do
      movies = Movie.make! 3

      visit root_path

      movies.each do |movie|
        should_see movie.title
      end
    end
  end

  describe "new" do
    it "should create a movie and redirect to the index" do
      visit new_movie_path

      fill_in 'Title', :with => 'Boogie Nights'
      fill_in 'IMDB Url', :with => 'http://www.imdb.com/title/tt0118749/'
      click_button 'Submit'

      should_be_on movies_path
      should_see '"Boogie Nights" was successfully added.'
    end
  end

  describe "show" do
    it "should show the details for a movie" do
      movie = Movie.make!

      visit movie_path movie

      should_see movie.title
      link('IMDB')[:href].should == movie.imdb_url
    end
  end

  describe "edit" do
    it "should edit a movie and redirect to its page" do
      movie = Movie.make!

      visit edit_movie_path movie

      field('Title').value.should == movie.title
      field('IMDB Url').value.should == movie.imdb_url

      fill_in 'Title', :with => 'Boogie Nights'
      fill_in 'IMDB Url', :with => 'http://www.imdb.com/title/tt0118749/'
      click_button 'Submit'

      movie.reload

      should_be_on movie_path movie
      should_see %("#{movie.title}" was successfully edited.)
      should_see movie.title
      link('IMDB')[:href].should == movie.imdb_url
    end
  end

  describe "destroy" do
    it "should delete the movie and redirect to the index" do
      movie = Movie.make!
      title = movie.title

      visit movie_path movie

      click_link 'Delete'

      should_be_on movies_path
      should_see %("#{title}" was successfully deleted.)
    end
  end
end
