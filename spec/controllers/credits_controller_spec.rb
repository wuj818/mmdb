require 'spec_helper'

describe CreditsController do
  def mock_person(stubs={})
    (@mock_person ||= mock_model(Person).as_null_object).tap do |person|
      person.stub(stubs.merge({:blank? => false}))
    end
  end

  describe 'GET new' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        Person.stub(:find_by_permalink => mock_person)
        get :new, :person_id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'POST create' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        Person.stub(:find_by_permalink => mock_person)
        post :create, :person_id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        Person.stub(:find_by_permalink => mock_person)
        delete :destroy, :person_id => '1', :id => '1'
        response.should redirect_to login_path
      end
    end
  end
end
