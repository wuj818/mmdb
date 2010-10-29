class CreditObserver < ActiveRecord::Observer
  def after_create(credit)
    credit_type = Credit::JOBS[credit.job]
    credit.movie.counter.increment! "#{credit_type}_credits_count"
    credit.person.counter.increment! "#{credit_type}_credits_count"
  end

  def after_destroy(credit)
    credit_type = Credit::JOBS[credit.job]
    credit.movie.counter.decrement! "#{credit_type}_credits_count"
    credit.person.counter.decrement! "#{credit_type}_credits_count"
  end
end
