module CreditScopesAndCounts
  # scopes

  def directing_credits
    credits.where(:job => 'Director')
  end

  def writing_credits
    credits.where(:job => 'Writer')
  end

  def composing_credits
    credits.where(:job => 'Composer')
  end

  def editing_credits
    credits.where(:job => 'Editor')
  end

  def cinematography_credits
    credits.where(:job => 'Cinematographer')
  end

  def acting_credits
    credits.where(:job => 'Actor')
  end

  # counts

  def number_of_directing_credits
    self.counter.directing_credits_count
  end

  def number_of_writing_credits
    self.counter.writing_credits_count
  end

  def number_of_composing_credits
    self.counter.composing_credits_count
  end

  def number_of_editing_credits
    self.counter.editing_credits_count
  end

  def number_of_cinematography_credits
    self.counter.cinematography_credits_count
  end

  def number_of_acting_credits
    self.counter.acting_credits_count
  end
end
