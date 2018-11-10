require 'rails_helper'

describe CountableObserver do
  it 'creates a counter for a countable object after creation' do
    @countable = build :movie
    @countable.counter.should be_blank
    @countable.save
    @countable.counter.should_not be_blank

    @countable = build :person
    @countable.counter.should be_blank
    @countable.save
    @countable.counter.should_not be_blank
  end
end
