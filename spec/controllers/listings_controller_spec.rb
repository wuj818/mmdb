require 'spec_helper'

describe ListingsController do
  def mock_list(stubs={})
    (@mock_list ||= mock_model(ItemList).as_null_object).tap do |list|
      list.stub stubs.merge({ blank?: false })
    end
  end

  describe 'GET new' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        ItemList.stub find_by_permalink: mock_list
        get :new, item_list_id: '1'
        response.should redirect_to login_path
      end
    end
  end

  describe 'POST create' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        ItemList.stub find_by_permalink: mock_list
        post :create, item_list_id: 1
        response.should redirect_to login_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not logged in' do
      it 'redirects to the login page' do
        ItemList.stub find_by_permalink: mock_list
        delete :destroy, item_list_id: 1, id: '1'
        response.should redirect_to login_path
      end
    end
  end
end
