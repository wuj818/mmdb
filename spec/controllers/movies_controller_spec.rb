require 'spec_helper'

describe MoviesController do
  def mock_movie(stubs={})
    @mock_movie ||= mock_model(Movie, stubs).as_null_object
  end

  describe 'GET index' do
    it 'assigns all movies as @movies' do
      Movie.stub(:all) { [mock_movie] }
      get :index
      assigns(:movies).should eq([mock_movie])
    end
  end

  describe 'GET show' do
    it 'assigns the requested movie as @movie' do
      Movie.stub(:find_by_permalink).with('37') { mock_movie }
      get :show, :id => '37'
      assigns(:movie).should be(mock_movie)
    end
  end

  describe 'GET new' do
    it 'assigns a new movie as @movie' do
      Movie.stub(:new) { mock_movie }
      get :new
      assigns(:movie).should be(mock_movie)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested movie as @movie' do
      Movie.stub(:find_by_permalink).with('37') { mock_movie }
      get :edit, :id => '37'
      assigns(:movie).should be(mock_movie)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'assigns a newly created movie as @movie' do
        Movie.stub(:new).with({'these' => 'params'}) { mock_movie(:save => true) }
        post :create, :movie => {'these' => 'params'}
        assigns(:movie).should be(mock_movie)
      end

      it 'redirects to the index page' do
        Movie.stub(:new) { mock_movie(:save => true) }
        post :create, :movie => {}
        response.should redirect_to(movies_url)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved movie as @movie' do
        Movie.stub(:new).with({'these' => 'params'}) { mock_movie(:save => false) }
        post :create, :movie => {'these' => 'params'}
        assigns(:movie).should be(mock_movie)
      end

      it 're-renders the "new" template' do
        Movie.stub(:new) { mock_movie(:save => false) }
        post :create, :movie => {}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested movie' do
        Movie.should_receive(:find_by_permalink).with('37') { mock_movie }
        mock_movie.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => '37', :movie => {'these' => 'params'}
      end

      it 'assigns the requested movie as @movie' do
        Movie.stub(:find_by_permalink) { mock_movie(:update_attributes => true) }
        put :update, :id => '1'
        assigns(:movie).should be(mock_movie)
      end

      it 'redirects to the movie' do
        Movie.stub(:find_by_permalink) { mock_movie(:update_attributes => true) }
        put :update, :id => '1'
        response.should redirect_to(movie_url(mock_movie))
      end
    end

    describe 'with invalid params' do
      it 'assigns the movie as @movie' do
        Movie.stub(:find_by_permalink) { mock_movie(:update_attributes => false) }
        put :update, :id => '1'
        assigns(:movie).should be(mock_movie)
      end

      it 're-renders the "edit" template' do
        Movie.stub(:find_by_permalink) { mock_movie(:update_attributes => false) }
        put :update, :id => '1'
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested movie' do
      Movie.should_receive(:find_by_permalink).with('37') { mock_movie }
      mock_movie.should_receive(:destroy)
      delete :destroy, :id => '37'
    end

    it 'redirects to the movies list' do
      Movie.stub(:find_by_permalink) { mock_movie }
      delete :destroy, :id => '1'
      response.should redirect_to(movies_url)
    end
  end
end
