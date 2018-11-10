require 'rails_helper'

describe CreditsController do
  describe 'GET new' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        get :new, params: { person_id: '1' }

        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'POST create' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        post :create, params: { person_id: '1' }

        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        delete :destroy, params: { person_id: '1', id: '1' }

        expect(response).to redirect_to login_path
      end
    end
  end
end
