require 'spec_helper'

describe 'People' do
  describe 'All people page' do
    it 'lists all people' do
      people = Person.make! 3
      visit people_path
      people.each { |person| should_see_link person.name }
    end

    it 'filters results based on the search parameter' do
      Person.make! name: 'Paul Thomas Anderson'
      Person.make! name: 'David Fincher'

      visit people_path
      fill_in 'q', with: 'paul'
      click_button 'nav-search-button'

      should_see_link 'Paul Thomas Anderson'
      should_not_see_link 'David Fincher'
    end

    it 'has customizable sorting options' do
      Person.make! name: 'David Fincher'
      Person.make! name: 'David Lynch'
      Person.make! name: 'Paul Thomas Anderson'

      # ascending name by default
      visit people_path
      people = all('.person-link').map(&:text)
      people.should == ['David Fincher', 'David Lynch', 'Paul Thomas Anderson']

      # descending name
      click_link 'Name'
      people = all('.person-link').map(&:text)
      people.should == ['Paul Thomas Anderson', 'David Lynch', 'David Fincher']
    end

    it 'has pagination info and links' do
      visit people_path
      should_see 'No people found'

      @people = Person.make! 2
      visit people_path per_page: 1

      should_see 'Displaying'
      should_see_link '2'
      should_see_link @people.first.name
      should_not_see_link @people.last.name

      click_link '2'
      should_not_see_link @people.first.name
      should_see_link @people.last.name
    end
  end

  describe 'Show person details' do
    it 'shows the details for a person' do
      @person = Person.make!
      visit person_path @person
      should_see @person.name
      find('.imdb')[:href].should == @person.imdb_url
    end
  end

  describe 'Edit person' do
    it 'edits a person and redirects to its page' do
      @person = Person.make!
      integration_login
      visit person_path @person
      click_link 'Edit'

      should_be_on edit_person_path @person
      should_see_field 'Permalink'
      should_see_field 'Sort Name'
      field('Name').value.should == @person.name
      field('IMDb').value.should == @person.imdb_url

      fill_in 'Name', with: 'Paul Thomas Anderson'
      fill_in 'IMDb', with: 'http://www.imdb.com/name/nm0000759/'
      click_button 'Submit'

      @person.reload

      should_be_on person_path @person
      should_see %("#{@person.name}" was successfully edited.)
      should_see @person.name
      find('.imdb')[:href].should == @person.imdb_url
    end
  end

  describe 'Delete person' do
    it 'deletes the person and redirects to the people page' do
      @person = Person.make!
      integration_login
      name = @person.name
      visit person_path @person
      click_link 'Delete'
      should_be_on people_path
      should_see %("#{name}" was successfully deleted.)
    end
  end
end
