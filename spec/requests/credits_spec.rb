require 'spec_helper'

describe 'Credits' do
  before do
    @movie = Movie.make!
    @person = Person.make!
    integration_login
  end

  describe 'Add new credit' do
    it 'creates a credit for the specified person/movie combination' do
      visit edit_person_path @person
      click_link 'Add Credit'

      select @movie.title, :from => 'Movie'
      select 'Director'
      fill_in 'Details', :with => '(uncredited)'
      click_button 'Submit'

      should_see %(#{@person.name} was successfully added as a director for "#{@movie.title}".)
    end
  end

  describe 'Delete credit' do
    before { Credit.make! :job => 'Director', :person => @person, :movie => @movie }

    it 'removes a credit for the specified person/movie combination' do
      visit edit_person_path @person

      within '#directing_credits' do
        click_link 'Delete'
      end

      should_see %(#{@person.name}'s directing credit was successfully removed from "#{@movie.title}".)
    end
  end
end
