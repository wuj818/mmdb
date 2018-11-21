require 'rails_helper'

describe Listing do
  describe 'Associations' do
    let(:listing) { Listing.new }

    it 'belongs to Item List' do
      expect(listing).to respond_to :item_list
    end

    it 'belongs to Movie' do
      expect(listing).to respond_to :movie
    end
  end

  describe 'Validations' do
    let(:empty_listing) { Listing.create }
    let(:listing) { create :listing }

    it 'has required attributes/associations' do
      %i[item_list movie].each do |attribute|
        expect(empty_listing.errors[attribute]).to include "can't be blank"
      end
    end

    it 'has a unique item list/movie combination' do
      @duplicate_listing = build :listing

      @duplicate_listing.item_list = listing.item_list
      @duplicate_listing.movie = listing.movie

      expect(@duplicate_listing).not_to be_valid
    end

    it 'has a valid position (positive integer or zero)' do
      listing.position = -1
      expect(listing).not_to be_valid

      listing.position = 1
      expect(listing).to be_valid
    end
  end

  describe 'Callbacks' do
    let(:listing) { create :listing }

    it 'is deleted when the associated item list is deleted' do
      @list = listing.item_list

      listing.item_list.destroy

      expect { listing.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { @list.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'is deleted when the associated movie is deleted' do
      @movie = listing.movie

      listing.movie.destroy

      expect { listing.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { @movie.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
