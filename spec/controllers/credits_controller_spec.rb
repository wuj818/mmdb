require 'spec_helper'

describe CreditsController do
  def mock_credit(stubs={})
    (@mock_credit ||= mock_model(Credit).as_null_object).tap do |credit|
      credit.stub(stubs)
    end
  end

  def mock_person(stubs={})
    (@mock_person ||= mock_model(Person).as_null_object).tap do |person|
      person.stub(stubs.merge({:blank? => false}))
    end
  end

  describe 'GET index' do
    it 'does not exist' do
      lambda { get :index }.should raise_error ActionController::RoutingError
    end
  end

  describe 'GET show' do
    it 'does not exist' do
      lambda { get :show, :id => '1' }.should raise_error ActionController::RoutingError
    end
  end

  describe 'GET new' do
    before { Person.stub(:find_by_permalink => mock_person) }

    context 'when logged in' do
      before { test_login }

      it 'assigns a new credit as @credit' do
        Credit.stub(:new) { mock_credit }
        get :new, :person_id => '1'
        assigns(:credit).should be mock_credit
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        get :new, :person_id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'GET edit' do
    it 'does not exist' do
      lambda { get :edit, :id => '1' }.should raise_error ActionController::RoutingError
    end
  end

  describe 'POST create' do
    before { Person.stub(:find_by_permalink => mock_person) }

    context 'when logged in' do
      before { test_login }

      describe 'with valid params' do
        before do
          Credit.stub(:new) { mock_credit(:save => true) }
          post :create, :person_id => '1', :credit => {'these' => 'params'}
        end

        it 'assigns a newly created credit as @credit' do
          assigns(:credit).should be mock_credit
        end

        it 'redirects to the person page' do
          response.should redirect_to mock_person
        end
      end

      describe 'with invalid params' do
        before do
          Credit.stub(:new) { mock_credit(:save => false) }
          post :create, :person_id => '1', :credit => {}
        end

        it 'assigns a newly created but unsaved credit as @credit' do
          assigns(:credit).should be(mock_credit)
        end

        it 're-renders the "new" template' do
          response.should render_template :new
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        post :create, :person_id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'PUT update' do
    it 'does not exist' do
      lambda { put :update, :id => '1' }.should raise_error ActionController::RoutingError
    end
  end

  describe 'DELETE destroy' do
    before { Person.stub(:find_by_permalink => mock_person) }

    context 'when logged in' do
      before do
        test_login
        Credit.stub(:find) { mock_credit }
      end

      it 'destroys the requested credit' do
        mock_credit.should_receive :destroy
        delete :destroy, :person_id => '1', :id => '1'
      end

      it 'redirects to the person' do
        delete :destroy, :person_id => '1', :id => '1'
        response.should redirect_to mock_person
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        delete :destroy, :person_id => '1', :id => '1'
        response.should redirect_to login_path
      end
    end
  end
end
