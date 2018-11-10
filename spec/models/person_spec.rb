require 'rails_helper'

describe Person do
  it_behaves_like 'a creditable object' do
    let(:object) { Person.new }
  end

  it_behaves_like 'a countable object' do
    let(:object) { create :person }
  end

  describe 'Defaults' do
    it 'has a default credits count of 0' do
      @person = Person.new
      @person.credits_count.should == 0
    end
  end

  describe 'Validations' do
    let(:empty_person) { Person.create }
    let(:person) { create :person }

    it 'has required attributes' do
      [:name, :imdb_url].each do |attribute|
        empty_person.errors[attribute].should include "can't be blank"
      end
    end

    it 'has a unique IMDB url' do
      empty_person.imdb_url = person.imdb_url

      empty_person.save

      empty_person.errors[:imdb_url].should include 'has already been taken'
    end

    it 'has a unique permalink' do
      empty_person.permalink = person.permalink

      empty_person.save

      empty_person.errors[:permalink].should include 'has already been taken'
    end
  end

  describe 'Callbacks' do
    describe 'Permalink creation' do
      it 'automatically creates a permalink from the name' do
        @person = build :person, name: 'Paul Thomas Anderson'
        @person.permalink.should be_blank

        @person.save

        @person.permalink.should == 'paul-thomas-anderson'
      end

      it 'resolves duplicates by appending an integer to the permalink' do
        @person1 = create :person, name: 'Paul Thomas Anderson'
        @person1.permalink.should == 'paul-thomas-anderson'

        @person2 = create :person, name: 'Paul Thomas Anderson'
        @person2.permalink.should == 'paul-thomas-anderson-2'
      end
    end

    describe 'Sort name creation' do
      it 'copies a lowercase transliterated version of the name if the sort name is blank' do
        @person = build :person
        @person.sort_name.should be_blank

        @person.save

        @person.sort_name.should == @person.name.to_sort_column
      end
    end
  end
end
