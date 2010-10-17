require 'spec_helper'

describe 'Sessions' do
  describe 'Login' do
    context 'when logged in' do
      it 'redirects to the home page' do
        integration_login
        visit login_path
        should_be_on root_path
        should_see 'You are already logged in.'
      end
    end

    context 'when logged out' do
      before { visit new_movie_path }

      context 'with valid password' do
        it 'logs in the admin and redirects to the previous page' do
          fill_in 'Password', :with => PASSWORD
          click_button 'Submit'

          should_be_on new_movie_path
          should_see 'Logged in successfully.'

          should_not_see_link 'Login'
          should_see_link 'Logout'
        end
      end

      context 'with invalid password' do
        it 're-renders the login form' do
          click_button 'Submit'

          should_see 'Incorrect password.'
          should_see_field 'Password'

          should_see_link 'Login'
          should_not_see_link 'Logout'
        end
      end
    end
  end

  describe 'Logout' do
    context 'when logged in' do
      it 'logs out the admin' do
        integration_login

        should_not_see_link 'Login'
        click_link 'Logout'

        should_be_on root_path
        should_see 'Logged out successfully.'

        should_see_link 'Login'
        should_not_see_link 'Logout'
      end
    end

    context 'when logged out' do
      it 'redirects to the home page' do
        visit logout_path
        should_be_on root_path
        should_see 'You are not logged in.'
      end
    end
  end
end
