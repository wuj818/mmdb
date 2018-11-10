require 'rails_helper'

describe PeopleController do
  describe 'GET edit' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        get :edit, params: { id: '1' }

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

  describe 'GET search' do
    it 'filters the index page by the search parameter' do
      get :search, params: { q: 'Paul Thomas Anderson' }

      expect(response).to redirect_to formatted_search_people_path q: 'Paul Thomas Anderson'
    end
  end
end
