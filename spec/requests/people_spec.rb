require 'spec_helper'

describe 'People' do
  describe 'All people page' do
    it 'lists all people' do
      people = Person.make! 3
      visit people_path
      people.each { |person| should_see_link person.name }
    end

    it 'has customizable sorting options' do
      Person.make! :name => 'David Fincher'
      Person.make! :name => 'David Lynch'
      Person.make! :name => 'Paul Thomas Anderson'

      # ascending name by default
      visit people_path
      people = all('td:first-child a').map(&:text)
      people.should == ['David Fincher', 'David Lynch', 'Paul Thomas Anderson']

      # descending name
      click_link 'Name'
      people = all('td:first-child a').map(&:text)
      people.should == ['Paul Thomas Anderson', 'David Lynch', 'David Fincher']
    end

    it 'has pagination info and links' do
      visit people_path
      should_see 'No entries found'

      @people = Person.make! 2
      visit people_path :per_page => 1

      should_see 'Displaying people'
      should_see '2 in total'
      should_see_link '2'
      should_see_link @people.first.name
      should_not_see_link @people.last.name

      click_link '2'
      should_not_see_link @people.first.name
      should_see_link @people.last.name
    end
  end

  describe 'Add new person' do
    context 'when logged in' do
      before do
        integration_login
        visit people_path
        click_link 'Add Person'
      end

      context 'with valid info' do
        it 'adds a person and redirects to the people page' do
          should_not_see_field 'Permalink'

          fill_in 'Name', :with => 'Paul Thomas Anderson'
          fill_in 'IMDB', :with => 'http://www.imdb.com/name/nm0000759/'
          click_button 'Submit'

          should_be_on people_path
          should_not_have_css '#error_explanation'
          should_see '"Paul Thomas Anderson" was successfully added.'
        end
      end

      context 'with invalid info' do
        it 'shows an error message' do
          click_button 'Submit'
          should_have_css '#error_explanation'
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        visit new_person_path
        should_not_be_on new_person_path
        should_be_on login_path
        should_see 'You must be logged in to access this page.'
      end

      it 'is not shown in the admin header as a link' do
        visit root_path
        should_not_see_link 'Add Person'
      end
    end
  end

  describe 'Show person details' do
    it 'shows the details for a person' do
      person = Person.make!
      visit person_path person
      should_see person.name
      link('IMDB')[:href].should == person.imdb_url
    end
  end

  describe 'Edit person' do
    before { @person = Person.make! }

    context 'when logged in' do
      before do
        integration_login
        visit person_path @person
        click_link 'Edit'
      end

      context 'with valid info' do
        it 'edits a person and redirects to its page' do
          should_see %(Editing "#{@person.name}")
          should_see_field 'Permalink'
          field('Name').value.should == @person.name
          field('IMDB').value.should == @person.imdb_url

          fill_in 'Name', :with => 'Paul Thomas Anderson'
          fill_in 'IMDB', :with => 'http://www.imdb.com/name/nm0000759/'
          click_button 'Submit'

          @person.reload

          should_be_on person_path @person
          should_see %("#{@person.name}" was successfully edited.)
          should_see @person.name
          link('IMDB')[:href].should == @person.imdb_url;
        end
      end

      context 'with invalid info' do
        it 'shows an error message' do
          fill_in 'Name', :with => ''
          click_button 'Submit'
          should_have_css '#error_explanation'
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        visit edit_person_path @person
        should_not_be_on new_person_path
        should_be_on login_path
        should_see 'You must be logged in to access this page.'
      end

      it 'is not shown on the person page as a link' do
        visit person_path @person
        should_not_see_link 'Edit'
      end
    end
  end

  describe 'Delete person' do
    before { @person = Person.make! }

    context 'when logged in' do
      before { integration_login }

      it 'deletes the person and redirects to the people page' do
        name = @person.name
        visit person_path @person
        click_link 'Delete'
        should_be_on people_path
        should_see %("#{name}" was successfully deleted.)
      end
    end

    context 'when not logged in' do
      it 'is not shown on the person page as a link' do
        visit person_path @person
        should_not_see_link 'Delete'
      end
    end
  end
end
