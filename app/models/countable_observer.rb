class CountableObserver < ActiveRecord::Observer
  observe :movie, :person

  def after_create(record)
    record.create_counter
  end
end
