require 'spec_helper'

describe CountableObserver do
  it 'creates a counter for a countable object after creation' do
    @countable = Movie.make
    @countable.counter.should be_blank
    @countable.save
    @countable.counter.should_not be_blank

    @countable = Person.make
    @countable.counter.should be_blank
    @countable.save
    @countable.counter.should_not be_blank
  end
end
