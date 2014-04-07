require 'spec_helper'

describe ItemListsController do
  def mock_list(stubs={})
    (@mock_list ||= mock_model(ItemList).as_null_object).tap do |list|
      list.stub stubs.merge({ blank?: false })
    end
  end

  describe 'GET new' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        ItemList.stub find_by_permalink: mock_list

        get :new

        response.should redirect_to login_path
      end
    end
  end

  describe 'GET edit' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        ItemList.stub find_by_permalink: mock_list

        get :edit, id: '1'

        response.should redirect_to login_path
      end
    end
  end

  describe 'POST create' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        ItemList.stub find_by_permalink: mock_list

        post :create

        response.should redirect_to login_path
      end
    end
  end

  describe 'PUT update' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        ItemList.stub find_by_permalink: mock_list

        put :update, id: '1'

        response.should redirect_to login_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        ItemList.stub find_by_permalink: mock_list

        delete :destroy, id: '1'

        response.should redirect_to login_path
      end
    end
  end

  describe 'PUT reorder' do
    context 'when not logged in' do
      it 'redirect_to to the login page' do
        ItemList.stub find_by_permalink: mock_list

        put :reorder, id: '1'

        response.should redirect_to login_path
      end
    end
  end
end
