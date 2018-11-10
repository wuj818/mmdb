require 'rails_helper'

describe CreditObserver do
  it "increments a countable object's credit counts after credit creation" do
    @person = create :person
    @person.counter.directing_credits_count.should == 0

    @movie = create :movie
    @movie.counter.directing_credits_count.should == 0

    @person.directing_credits.create movie: @movie, job: 'Director'

    @person.reload
    @movie.reload

    @person.counter.directing_credits_count.should == 1
    @movie.counter.directing_credits_count.should == 1
  end

  it "decrements a countable object's credit counts after credit deletion" do
    @person = create :person
    @movie = create :movie

    @person.directing_credits.create movie: @movie, job: 'Director'
    @person.directing_credits.first.destroy

    @person.reload
    @movie.reload

    @person.number_of_directing_credits.should == 0
    @movie.number_of_directing_credits.should == 0
  end
end
