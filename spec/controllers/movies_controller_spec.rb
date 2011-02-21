require 'spec_helper'

describe MoviesController do
  def mock_movie(stubs={})
    (@mock_movie ||= mock_model(Movie).as_null_object).tap do |movie|
      movie.stub(stubs.merge({:blank? => false}))
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      it 'renders the "from_imdb" template if the param is present' do
        test_login
        get :new, :from_imdb => true
        response.should render_template :from_imdb
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        get :new
        response.should redirect_to login_path
      end
    end
  end

  describe 'GET edit' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        get :edit, :id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'POST create' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        post :create
        response.should redirect_to login_path
      end
    end
  end

  describe 'PUT update' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        put :update, :id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        delete :destroy, :id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'POST scrape_info' do
    context 'when logged in' do
      before { test_login }

      describe 'with valid params' do
        it 'renders the "new" template' do
          Movie.stub(:new) { mock_movie }
          post :scrape_info, :imdb_url => 'http://www.imdb.com/title/tt0118749/'
          response.should render_template :new
        end
      end

      describe 'with invalid params' do
        it 'redirects to the new movie from IMDB url page' do
          post :scrape_info 
          response.should redirect_to new_movie_path(:from_imdb => true)
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        post :scrape_info
        response.should redirect_to login_path
      end
    end
  end

  describe 'GET search' do
    it 'filters the index page by the search parameter' do
      get :search, :q => 'Boogie Nights'
      response.should redirect_to formatted_search_movies_path :q => 'Boogie Nights'
    end
  end
end
