require 'rails_helper'

describe Counter do
  describe 'Associations' do
    it 'belongs to Countable (Movie/Person)' do
      @counter = Counter.new
      @counter.countable.should be_blank
    end
  end

  describe 'Callbacks' do
    it 'is deleted when the associated countable object is deleted' do
      @movie = create :movie
      @counter = @movie.counter
      @movie.destroy
      lambda { @counter.reload }.should raise_error
    end
  end
end
