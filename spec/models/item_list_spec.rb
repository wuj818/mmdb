require 'rails_helper'

describe ItemList do
  describe 'Defaults' do
    it 'has a default position of 0' do
      @list = ItemList.new
      expect(@list.position).to eq 0
    end
  end

  describe 'Validations' do
    let(:empty_list) { ItemList.create }
    let(:list) { create :item_list }

    it 'has required attributes' do
      [:name].each do |attribute|
        expect(empty_list.errors[attribute]).to include "can't be blank"
      end
    end

    it 'has a unique name' do
      empty_list.name = list.name

      empty_list.save

      expect(empty_list.errors[:name]).to include 'has already been taken'
    end

    it 'has a valid position (positive integer or zero)' do
      list.position = -1
      expect(list).not_to be_valid

      list.position = 1
      expect(list).to be_valid
    end
  end

  describe 'Callbacks' do
    describe 'Permalink creation' do
      it 'automatically creates a permalink from the title' do
        @list = build :item_list, name: 'Best Movies of 2010'
        expect(@list.permalink).to be_blank

        @list.save

        expect(@list.permalink).to eq 'best-movies-of-2010'
      end
    end
  end
end
