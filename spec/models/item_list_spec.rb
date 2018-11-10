require 'rails_helper'

describe ItemList do
  describe 'Defaults' do
    it 'has a default position of 0' do
      @list = ItemList.new
      @list.position.should == 0
    end
  end

  describe 'Validations' do
    let(:empty_list) { ItemList.create }
    let(:list) { create :item_list }

    it 'has required attributes' do
      [:name].each do |attribute|
        empty_list.errors[attribute].should include "can't be blank"
      end
    end

    it 'has a unique name' do
      empty_list.name = list.name

      empty_list.save

      empty_list.errors[:name].should include 'has already been taken'
    end

    it 'has a valid position (positive integer or zero)' do
      list.position = -1
      list.should_not be_valid

      list.position = 1
      list.should be_valid
    end
  end

  describe 'Callbacks' do
    describe 'Permalink creation' do
      it 'automatically creates a permalink from the title' do
        @list = build :item_list, name: 'Best Movies of 2010'
        @list.permalink.should be_blank

        @list.save

        @list.permalink.should == 'best-movies-of-2010'
      end
    end
  end
end
