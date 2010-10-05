require 'spec_helper'

describe "Sessions" do
  describe "login" do
    context "logged in" do
      it "should redirect to the home page" do
        integration_login

        visit login_path

        should_be_on root_path
        should_see 'You are already logged in.'
      end
    end

    context "logged out" do
      context "success" do
        it "should login the admin and redirect to the home page" do
          visit root_path

          should_not_see_link 'Logout'
          click_link 'Login'

          fill_in 'Password', :with => PASSWORD
          click_button 'Submit'

          should_be_on root_path
          should_see 'Logged in successfully.'

          should_not_see_link 'Login'
          should_see_link 'Logout'
        end
      end

      context "failure" do
        it "should inform the user and re-render the login form" do
          visit login_path

          click_button 'Submit'

          should_see 'Incorrect password.'
          should_see_field 'Password'

          should_see_link 'Login'
          should_not_see_link 'Logout'
        end
      end
    end
  end

  describe "logout" do
    context "logged in" do
      it "should logout the admin" do
        integration_login

        should_not_see_link 'Login'
        click_link 'Logout'

        should_be_on root_path
        should_see 'Logged out successfully.'

        should_see_link 'Login'
        should_not_see_link 'Logout'
      end
    end

    context "logged out" do
      it "should redirect to the home page" do
        visit logout_path

        should_be_on root_path
        should_see 'You are not logged in.'
      end
    end
  end
end
