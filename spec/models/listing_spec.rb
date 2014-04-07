require 'spec_helper'

describe Listing do
  describe 'Associations' do
    before { @listing = Listing.new }

    it 'belongs to Item List' do
      @listing.item_list.should be_blank
    end

    it 'belongs to Movie' do
      @listing.movie.should be_blank
    end
  end

  describe 'Validations' do
    before do
      @empty_listing = Listing.create
      @listing = Listing.make!
    end

    it 'has required attributes/associations' do
      [:item_list, :movie].each do |attribute|
        @empty_listing.errors[attribute].should include "can't be blank"
      end
    end

    it 'has a unique item list/movie combination' do
      @duplicate_listing = Listing.make

      @duplicate_listing.item_list = @listing.item_list
      @duplicate_listing.movie = @listing.movie

      @duplicate_listing.should_not be_valid
    end

    it 'has a valid position (positive integer or zero)' do
      @listing.position = -1
      @listing.should_not be_valid

      @listing.position = 1
      @listing.should be_valid
    end
  end

  describe 'Callbacks' do
    it 'is deleted when the associated item list is deleted' do
      @listing = Listing.make!
      @list = @listing.item_list

      @listing.item_list.destroy

      lambda { @listing.reload }.should raise_error
      lambda { @list.reload }.should raise_error
    end

    it 'is deleted when the associated movie is deleted' do
      @listing = Listing.make!
      @movie = @listing.movie

      @listing.movie.destroy

      lambda { @listing.reload }.should raise_error
      lambda { @movie.reload }.should raise_error
    end
  end
end
