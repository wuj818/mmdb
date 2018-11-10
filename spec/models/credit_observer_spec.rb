require 'rails_helper'

describe CreditObserver do
  it "increments a countable object's credit counts after credit creation" do
    @countable = Person.make!
    @countable.counter.directing_credits_count.should == 0

    @movie = Movie.make!
    @movie.counter.directing_credits_count.should == 0

    @countable.directing_credits.create movie: @movie, job: 'Director'

    @countable.reload
    @movie.reload

    @countable.counter.directing_credits_count.should == 1
    @movie.counter.directing_credits_count.should == 1
  end

  it "decrements a countable object's credit counts after credit deletion" do
    @countable = Person.make!
    @movie = Movie.make!

    @countable.directing_credits.create movie: @movie, job: 'Director'
    @countable.directing_credits.first.destroy

    @countable.reload
    @movie.reload

    @countable.counter.directing_credits_count.should == 0
    @movie.counter.directing_credits_count.should == 0
  end
end
