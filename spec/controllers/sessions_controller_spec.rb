require 'rails_helper'

describe SessionsController do
  describe 'GET new' do
    context 'when logged in' do
      it 'redirects to the home page' do
        controller.login_admin

        get :new

        expect(response).to redirect_to root_path
      end
    end

    context 'when logged out' do
      it 'renders the login form' do
        get :new

        expect(response).to_not be_redirect
      end
    end
  end

  describe 'POST create (Login)' do
    context 'with valid password' do
      it 'logs in the admin' do
        post :create, params: { password: Rails.application.credentials.password[Rails.env.to_sym] }

        expect(response).to redirect_to root_path
        expect(controller).to be_admin
      end
    end

    context 'with invalid password' do
      it 're-renders the login form' do
        post :create, params: { password: 'wrong' }

        expect(response).to_not be_redirect
        expect(controller).to_not be_admin
      end
    end
  end

  describe 'DELETE destroy (Logout)' do
    before { request.env["HTTP_REFERER"] = root_path }

    context 'when logged in' do
      it 'logs out the admin' do
        controller.login_admin

        delete :destroy

        expect(response).to redirect_to root_path
        expect(controller).to_not be_admin
      end
    end

    context 'when logged out' do
      it 'redirects to the home page' do
        expect(controller).not_to receive :logout_admin

        delete :destroy

        expect(response).to redirect_to root_path
      end
    end
  end
end
