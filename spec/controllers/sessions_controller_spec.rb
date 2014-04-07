require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    context 'when logged in' do
      it 'redirects to the home page' do
        test_login

        get :new

        response.should redirect_to root_path
      end
    end

    context 'when logged out' do
      it 'renders the login form' do
        get :new

        response.should_not be_redirect
      end
    end
  end

  describe 'POST create (Login)' do
    context 'with valid password' do
      it 'logs in the admin' do
        post :create, session: { password: Figaro.env.mmdb_password }

        response.should redirect_to root_path
        controller.should be_admin
      end
    end

    context 'with invalid password' do
      it 're-renders the login form' do
        post :create, session: { password: 'wrong' }

        response.should_not be_redirect
        controller.should_not be_admin
      end
    end
  end

  describe 'DELETE destroy (Logout)' do
    before { request.env["HTTP_REFERER"] = root_path }

    context 'when logged in' do
      it 'logs out the admin' do
        test_login

        delete :destroy

        response.should redirect_to root_path
        controller.should_not be_admin
      end
    end

    context 'when logged out' do
      it 'redirects to the home page' do
        controller.should_not_receive :logout_admin

        delete :destroy

        response.should redirect_to root_path
      end
    end
  end
end
