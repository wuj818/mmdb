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
      expect(@person.credits_count).to eq 0
    end
  end

  describe 'Validations' do
    let(:empty_person) { Person.create }
    let(:person) { create :person }

    it 'has required attributes' do
      [:name, :imdb_url].each do |attribute|
        expect(empty_person.errors[attribute]).to include "can't be blank"
      end
    end

    it 'has a unique IMDB url' do
      empty_person.imdb_url = person.imdb_url

      empty_person.save

      expect(empty_person.errors[:imdb_url]).to include 'has already been taken'
    end

    it 'has a unique permalink' do
      empty_person.permalink = person.permalink

      empty_person.save

      expect(empty_person.errors[:permalink]).to include 'has already been taken'
    end
  end

  describe 'Callbacks' do
    describe 'Permalink creation' do
      it 'automatically creates a permalink from the name' do
        @person = build :person, name: 'Paul Thomas Anderson'
        expect(@person.permalink).to be_blank

        @person.save

        expect(@person.permalink).to eq 'paul-thomas-anderson'
      end

      it 'resolves duplicates by appending an integer to the permalink' do
        @person1 = create :person, name: 'Paul Thomas Anderson'
        expect(@person1.permalink).to eq 'paul-thomas-anderson'

        @person2 = create :person, name: 'Paul Thomas Anderson'
        expect(@person2.permalink).to eq 'paul-thomas-anderson-2'
      end
    end

    describe 'Sort name creation' do
      it 'copies a lowercase transliterated version of the name if the sort name is blank' do
        @person = build :person
        expect(@person.sort_name).to be_blank

        @person.save

        expect(@person.sort_name).to eq @person.name.to_sort_column
      end
    end
  end
end
