require 'rails_helper'

describe MoviesController do
  describe 'GET new' do
    context 'when logged in' do
      it 'renders the "from_imdb" template if the param is present' do
        controller.login_admin

        get :new, params: { from_imdb: true }

        expect(response).to render_template :from_imdb
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        get :new

        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET edit' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        get :edit, params: { id: '1' }

        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'POST create' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        post :create

        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'PUT update' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        put :update, params: { id: '1' }

        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        delete :destroy, params: { id: '1' }

        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'POST scrape_info' do
    context 'when logged in' do
      before { controller.login_admin }

      describe 'with valid params' do
        it 'renders the "new" template' do
          post :scrape_info, params: { imdb_url: 'http://www.imdb.com/title/tt0118749/' }

          expect(response).to render_template :new
        end
      end

      describe 'with invalid params' do
        it 'redirects to the new movie from IMDB url page' do
          post :scrape_info 

          expect(response).to redirect_to new_movie_path(from_imdb: true)
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        post :scrape_info

        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET search' do
    it 'filters the index page by the search parameter' do
      get :search, params: { q: 'Boogie Nights' }

      expect(response).to redirect_to formatted_search_movies_path q: 'Boogie Nights'
    end
  end
end
