require 'spec_helper'

describe 'Lists' do
  describe 'All lists page' do
    it 'lists all lists' do
      lists = ItemList.make! 3
      visit item_lists_path
      lists.each { |list| should_see_link list.name }
    end
  end

  describe 'Show list details' do
    it 'shows the details for a list' do
      list = ItemList.make!
      visit item_list_path list
      should_see list.name
    end
  end

  describe 'Edit list' do
    it 'edits a list and redirects to its page' do
      @list = ItemList.make!
      integration_login
      visit item_list_path @list
      click_link 'Edit'

      should_be_on edit_item_list_path @list
      field('Name').value.should == @list.name

      fill_in 'Name', :with => 'Best Movies of 2010'
      click_button 'Submit'

      @list.reload

      should_be_on item_list_path @list
      should_see %("#{@list.name}" was successfully edited.)
      should_see @list.name
    end
  end

  describe 'Delete List' do
    it 'deletes the list and redirects to the lists page' do
      @list = ItemList.make!
      integration_login

      title = @list.name
      visit item_list_path @list
      click_link 'Delete'
      should_be_on item_lists_path
      should_see %("#{title}" was successfully deleted.)
    end
  end

  describe 'Add new list' do
    it 'adds a new list to the database' do
      integration_login
      click_link 'Add List'

      fill_in 'Name', :with => 'Best Movies of 2010'
      click_button 'Submit'

      should_not_have_css '#error_explanation'
      should_see '"Best Movies of 2010" was successfully added.'
    end
  end
end
