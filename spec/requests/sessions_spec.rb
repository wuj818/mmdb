require 'spec_helper'

describe 'Sessions', js: true do
  describe 'Login' do
    before { visit root_path }

    context 'with valid password' do
      it 'logs in the admin and loads the appropriate content with ajax' do
        click_link 'Login'
        fill_in 'Password', with: Figaro.env.mmdb_password
        click_button 'Login'

        should_be_on root_path
        should_see 'Logged in successfully.'

        link('Login').should_not be_visible
        link('Logout').should be_visible
      end
    end

    context 'with invalid password' do
      it 're-renders the login form' do
        click_link 'Login'
        click_button 'Login'

        should_be_on root_path
        should_see 'Incorrect password.'

        link('Login').should be_visible
        link('Logout').should_not be_visible
      end
    end
  end

  describe 'Logout' do
    it 'logs out the admin' do
      integration_login

      link('Login').should_not be_visible
      link('Logout').should be_visible

      click_link 'Logout'

      should_be_on root_path
      should_see 'Logged out successfully.'

      link('Login').should be_visible
      link('Logout').should_not be_visible
    end
  end
end
