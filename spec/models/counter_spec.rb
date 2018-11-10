require 'rails_helper'

describe Counter do
  describe 'Associations' do
    it 'belongs to Countable (Movie/Person)' do
      @counter = Counter.new
      expect(@counter.countable).to be_blank
    end
  end

  describe 'Callbacks' do
    it 'is deleted when the associated countable object is deleted' do
      @movie = create :movie
      @counter = @movie.counter
      @movie.destroy
      expect { @counter.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
