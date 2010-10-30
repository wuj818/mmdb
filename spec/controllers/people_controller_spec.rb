require 'spec_helper'

describe PeopleController do
  def mock_person(stubs={})
    (@mock_person ||= mock_model(Person).as_null_object).tap do |person|
      person.stub(stubs.merge({:blank? => false}))
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      before { test_login }

      it 'assigns a new person as @person' do
        Person.stub(:new) { mock_person }
        get :new
        assigns(:person).should be mock_person
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        get :new
        response.should redirect_to login_path
      end
    end
  end

  describe 'GET edit' do
    context 'when logged in' do
      before { test_login }

      it 'assigns the requested person as @person' do
        Person.stub(:find_by_permalink).with('1') { mock_person }
        get :edit, :id => '1'
        assigns(:person).should be mock_person
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        get :edit, :id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      before { test_login }

      describe 'with valid params' do
        before do
          Person.stub(:new) { mock_person(:save => true) }
          post :create, :person => {'these' => 'params'}
        end

        it 'assigns a newly created person as @person' do
          assigns(:person).should be mock_person
        end

        it 'redirects to the index page' do
          response.should redirect_to people_path
        end
      end

      describe 'with invalid params' do
        before do
          Person.stub(:new) { mock_person(:save => false) }
          post :create, :person => {}
        end

        it 'assigns a newly created but unsaved person as @person' do
          assigns(:person).should be(mock_person)
        end

        it 're-renders the "new" template' do
          response.should render_template :new
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        post :create
        response.should redirect_to login_path
      end
    end
  end

  describe 'PUT update' do
    context 'when logged in' do
      before { test_login }

      describe 'with valid params' do
        before do
          Person.stub(:find_by_permalink) { mock_person(:update_attributes => true) }
        end

        it 'updates the requested person' do
          mock_person.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => '1', :person => {'these' => 'params'}
        end

        it 'assigns the requested person as @person' do
          put :update, :id => '1', :person => {'these' => 'params'}
          assigns(:person).should be mock_person
        end

        it 'redirects to the person' do
          put :update, :id => '1', :person => {'these' => 'params'}
          response.should redirect_to mock_person
        end
      end

      describe 'with invalid params' do
        before do
          Person.stub(:find_by_permalink) { mock_person(:update_attributes => false) }
          put :update, :id => '1'
        end

        it 'assigns the person as @person' do
          assigns(:person).should be mock_person
        end

        it 're-renders the "edit" template' do
          response.should render_template :edit
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        post :edit, :id => '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when logged in' do
      before do
        test_login
        Person.stub(:find_by_permalink) { mock_person }
      end

      it 'destroys the requested person' do
        mock_person.should_receive :destroy
        delete :destroy, :id => '1'
      end

      it 'redirects to the people list' do
        delete :destroy, :id => '1'
        response.should redirect_to people_path
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        delete :destroy, :id => '1'
        response.should redirect_to login_path
      end
    end
  end
end
