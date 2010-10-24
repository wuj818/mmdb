require 'spec_helper'

describe Person do
  it_behaves_like 'a creditable object' do
    let(:object) { Person.new }
  end

  describe 'Validations' do
    before do
      @empty_person = Person.create
      @person = Person.make!
    end

    it 'has required attributes' do
      [:name, :imdb_url].each do |attribute|
        @empty_person.errors[attribute].should include "can't be blank"
      end
    end

    it 'has a unique IMDB url' do
      @empty_person.imdb_url = @person.imdb_url
      @empty_person.save
      @empty_person.errors[:imdb_url].should include 'has already been taken'
    end

    it 'has a unique permalink' do
      @empty_person.permalink = @person.permalink
      @empty_person.save
      @empty_person.errors[:permalink].should include 'has already been taken'
    end
  end

  describe 'Callbacks' do
    describe 'Permalink creation' do
      it 'automatically creates a permalink from the name' do
        @person = Person.make(:name => 'Paul Thomas Anderson')
        @person.permalink.should be_blank
        @person.save
        @person.permalink.should == 'paul-thomas-anderson'
      end

      it 'resolves duplicates by appending an integer to the permalink' do
        @person1 = Person.make!(:name => 'Paul Thomas Anderson')
        @person1.permalink.should == 'paul-thomas-anderson'
        @person2 = Person.make!(:name => 'Paul Thomas Anderson')
        @person2.permalink.should == 'paul-thomas-anderson-2'
      end
    end
  end
end
