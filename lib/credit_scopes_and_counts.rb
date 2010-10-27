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

  def directing_credits_count
    self.counter.directing_credits
  end

  def writing_credits_count
    self.counter.writing_credits
  end

  def composing_credits_count
    self.counter.composing_credits
  end

  def editing_credits_count
    self.counter.editing_credits
  end

  def cinematography_credits_count
    self.counter.cinematography_credits
  end

  def acting_credits_count
    self.counter.acting_credits
  end
end
