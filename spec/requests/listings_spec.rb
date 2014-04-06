require 'spec_helper'

describe 'Listings' do
  before do
    @list = ItemList.make!
    @movie = Movie.make!
    integration_login
  end

  describe 'Add new listing' do
    it 'creates a listing for the specified list/movie combination' do
      visit item_list_path @list
      click_link 'Add Listing'

      select @movie.title, from: 'Movie'
      click_button 'Submit'

      should_see %("#{@movie.title}" was successfully added to "#{@list.name}".)
    end
  end

  describe 'Delete credit' do
    it 'removes a listing for the specified list/movie combination' do
      Listing.make! item_list: @list, movie: @movie
      visit edit_item_list_path @list

      within '#sortable-list' do
        click_link 'Delete'
      end

      should_see %("#{@movie.title}" was successfully removed from "#{@list.name}".)
    end
  end
end
