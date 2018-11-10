require 'rails_helper'

describe CreditObserver do
  it "increments a countable object's credit counts after credit creation" do
    @person = create :person
    expect(@person.counter.directing_credits_count).to eq 0

    @movie = create :movie
    expect(@movie.counter.directing_credits_count).to eq 0

    @person.directing_credits.create movie: @movie, job: 'Director'

    @person.reload
    @movie.reload

    expect(@person.counter.directing_credits_count).to eq 1
    expect(@movie.counter.directing_credits_count).to eq 1
  end

  it "decrements a countable object's credit counts after credit deletion" do
    @person = create :person
    @movie = create :movie

    @person.directing_credits.create movie: @movie, job: 'Director'
    @person.directing_credits.first.destroy

    @person.reload
    @movie.reload

    expect(@person.number_of_directing_credits).to eq 0
    expect(@movie.number_of_directing_credits).to eq 0
  end
end
