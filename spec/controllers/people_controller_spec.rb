require 'spec_helper'

describe PeopleController do
  def mock_person(stubs={})
    (@mock_person ||= mock_model(Person).as_null_object).tap do |person|
      person.stub(stubs.merge({:blank? => false}))
    end
  end

  describe 'GET new' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        get :new
        response.should redirect_to login_path
      end
    end
  end

  describe 'GET edit' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        get :edit, :id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'POST create' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        post :create
        response.should redirect_to login_path
      end
    end
  end

  describe 'PUT update' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        post :edit, :id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        delete :destroy, :id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'GET search' do
    it 'filters the index page by the search parameter' do
      get :search, :q => 'Paul Thomas Anderson'
      response.should redirect_to formatted_search_people_path :q => 'Paul Thomas Anderson'
    end
  end
end
