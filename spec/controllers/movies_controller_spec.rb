require 'spec_helper'

describe MoviesController do
  def mock_movie(stubs={})
    (@mock_movie ||= mock_model(Movie).as_null_object).tap do |movie|
      movie.stub(stubs.merge({:blank? => false}))
    end
  end

  describe 'GET index' do
    it 'assigns all movies as @movies' do
      Movie.stub(:order) { [mock_movie] }
      get :index
      assigns(:movies).should eq [mock_movie]
    end
  end

  describe 'GET show' do
    it 'assigns the requested movie as @movie' do
      Movie.stub(:find_by_permalink).with('1') { mock_movie }
      get :show, :id => '1'
      assigns(:movie).should be mock_movie
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      before { test_login }

      it 'assigns a new movie as @movie' do
        Movie.stub(:new) { mock_movie }
        get :new
        assigns(:movie).should be mock_movie
      end

      it 'renders the "from_imdb" template is the param is present' do
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
    context 'when logged in' do
      before { test_login }

      it 'assigns the requested movie as @movie' do
        Movie.stub(:find_by_permalink).with('1') { mock_movie }
        get :edit, :id => '1'
        assigns(:movie).should be mock_movie
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        get :edit, :id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      before { test_login }

      describe 'with valid params' do
        before do
          Movie.stub(:new) { mock_movie(:save => true) }
          post :create, :movie => {'these' => 'params'}
        end

        it 'assigns a newly created movie as @movie' do
          assigns(:movie).should be mock_movie
        end

        it 'redirects to the index page' do
          response.should redirect_to movies_path
        end
      end

      describe 'with invalid params' do
        before do
          Movie.stub(:new) { mock_movie(:save => false) }
          post :create, :movie => {}
        end

        it 'assigns a newly created but unsaved movie as @movie' do
          assigns(:movie).should be mock_movie
        end

        it 're-renders the "new" template' do
          response.should render_template :new
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        post :create
        response.should redirect_to login_path
      end
    end
  end

  describe 'PUT update' do
    context 'when logged in' do
      before { test_login }

      describe 'with valid params' do
        before do
          Movie.stub(:find_by_permalink) { mock_movie(:update_attributes => true) }
        end

        it 'updates the requested movie' do
          mock_movie.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => '1', :movie => {'these' => 'params'}
        end

        it 'assigns the requested movie as @movie' do
          put :update, :id => '1', :movie => {'these' => 'params'}
          assigns(:movie).should be mock_movie
        end

        it 'redirects to the movie' do
          put :update, :id => '1', :movie => {'these' => 'params'}
          response.should redirect_to mock_movie
        end
      end

      describe 'with invalid params' do
        before do
          Movie.stub(:find_by_permalink) { mock_movie(:update_attributes => false) }
          put :update, :id => '1'
        end

        it 'assigns the movie as @movie' do
          assigns(:movie).should be mock_movie
        end

        it 're-renders the "edit" template' do
          response.should render_template :edit
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        put :edit, :id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when logged in' do
      before do
        test_login
        Movie.stub(:find_by_permalink) { mock_movie }
      end

      it 'destroys the requested movie' do
        mock_movie.should_receive :destroy
        delete :destroy, :id => '1'
      end

      it 'redirects to the movies list' do
        delete :destroy, :id => '1'
        response.should redirect_to movies_path
      end
    end

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
        before do
          Movie.stub(:new) { mock_movie }
          post :scrape_info, :imdb_url => 'http://www.imdb.com/title/tt0118749/'
        end

        it 'assigns a newly created but unsaved movie as @movie' do
          assigns(:movie).should be mock_movie
        end

        it 'renders the "new" template' do
          response.should render_template :new
        end
      end

      describe 'with invalid params' do
        before { post :scrape_info }

        it 'redirects to the new movie from IMDB url page' do
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
end