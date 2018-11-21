require 'rails_helper'

describe Credit do
  describe 'Associations' do
    let(:credit) { Credit.new }

    it 'belongs to Person' do
      expect(credit.person).to be_blank
    end

    it 'belongs to Movie' do
      expect(credit.movie).to be_blank
    end
  end

  describe 'Validations' do
    let(:empty_credit) { Credit.create }
    let(:credit) { create :credit }

    it 'has required attributes/associations' do
      %i[person movie job].each do |attribute|
        expect(empty_credit.errors[attribute]).to include "can't be blank"
      end
    end

    it 'has a unique person/movie/type combination' do
      @duplicate_credit = build :credit

      @duplicate_credit.person = credit.person
      @duplicate_credit.movie = credit.movie
      @duplicate_credit.job = credit.job

      expect(@duplicate_credit).not_to be_valid
    end

    it 'has a valid type' do
      credit.job = 'not valid'
      expect(credit).not_to be_valid

      credit.job = Credit::JOBS.keys.first
      expect(credit).to be_valid
    end
  end

  describe 'Callbacks' do
    let(:credit) { create :credit }

    it 'is deleted when the associated person is deleted' do
      @movie = credit.movie

      credit.person.destroy

      expect { credit.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { @movie.reload }.not_to raise_error
    end

    it 'is deleted when the associated movie is deleted' do
      @person = credit.person

      credit.movie.destroy

      expect { credit.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { @person.reload }.not_to raise_error
    end
  end
end
