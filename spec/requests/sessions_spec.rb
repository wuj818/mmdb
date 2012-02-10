require 'spec_helper'

describe 'Sessions', :js => true do
  describe 'Login' do
    before do
      visit new_movie_from_imdb_path

      link('Login').should be_visible
      link('Logout').should_not be_visible
    end

    context 'with valid password' do
      it 'logs in the admin and redirects to the previous page' do
        fill_in 'Password', :with => PASSWORD
        click_button 'Login'

        should_be_on new_movie_from_imdb_path
        should_see 'Logged in successfully.'

        link('Login').should_not be_visible
        link('Logout').should be_visible
      end
    end

    context 'with invalid password' do
      it 're-renders the login form' do
        click_button 'Login'

        should_see 'Incorrect password.'
        should_see_field 'Password'

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
