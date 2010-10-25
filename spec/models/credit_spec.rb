require 'spec_helper'

describe Credit do
  describe 'Associations' do
    before { @credit = Credit.new }

    it 'belongs to Person' do
      @credit.person.should be_blank
    end

    it 'belongs to Movie' do
      @credit.movie.should be_blank
    end
  end

  describe 'Validations' do
    before do
      @empty_credit = Credit.create
      @credit = Credit.make!
    end

    it 'has required attributes/associations' do
      [:person, :movie, :job].each do |attribute|
        @empty_credit.errors[attribute].should include "can't be blank"
      end
    end

    it 'has a unique person/movie/type combination' do
      @duplicate_credit = Credit.make
      @duplicate_credit.person = @credit.person
      @duplicate_credit.movie = @credit.movie
      @duplicate_credit.job = @credit.job
      @duplicate_credit.should_not be_valid
    end

    it 'has a valid type' do
      @credit.job = 'not valid'
      @credit.should_not be_valid
      @credit.job = Credit::JOBS.keys.first
      @credit.should be_valid
    end
  end

  describe 'Callbacks' do
    it 'is deleted when the associated person is deleted' do
      @credit = Credit.make!
      @movie = @credit.movie
      @credit.person.destroy
      lambda { @credit.reload }.should raise_error
      lambda { @movie.reload }.should_not raise_error
    end

    it 'is deleted when the associated movie is deleted' do
      @credit = Credit.make!
      @person = @credit.person
      @credit.movie.destroy
      lambda { @credit.reload }.should raise_error
      lambda { @person.reload }.should_not raise_error
    end
  end
end
