require 'spec_helper'

describe SessionsController do
  describe "GET 'new'" do
    context "logged in" do
      it "should redirect to the home page" do
        test_login
        get :new
        response.should redirect_to root_path
      end
    end

    context "logged out" do
      it "should render the login form" do
        get :new
        response.should_not be_redirect
      end
    end
  end

  describe "POST 'create'" do
    context "success" do
      it "should login the admin" do
        post :create, :session => { :password => PASSWORD }
        controller.should be_admin
        response.should redirect_to root_path
      end
    end

    context "failure" do
      it "should re-render the login form" do
        post :create, :session => { :password => 'wrong' }
        controller.should_not be_admin
        response.should_not be_redirect
      end
    end
  end

  describe "DELETE 'destroy'" do
    context "logged in" do
      it "should logout the admin" do
        test_login
        delete :destroy
        controller.should_not be_admin
        response.should redirect_to root_path
      end
    end

    context "logged out" do
      it "should redirect to the home page" do
        controller.should_not_receive :logout_admin
        delete :destroy
        response.should redirect_to root_path
      end
    end
  end
end
