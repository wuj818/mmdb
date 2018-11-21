module CreditScopesAndCounts
  # scopes

  def directing_credits
    credits.where(job: 'Director')
  end

  def writing_credits
    credits.where(job: 'Writer')
  end

  def composing_credits
    credits.where(job: 'Composer')
  end

  def editing_credits
    credits.where(job: 'Editor')
  end

  def cinematography_credits
    credits.where(job: 'Cinematographer')
  end

  def acting_credits
    credits.where(job: 'Actor')
  end

  # counts

  def number_of_directing_credits
    counter.directing_credits_count
  end

  def number_of_writing_credits
    counter.writing_credits_count
  end

  def number_of_composing_credits
    counter.composing_credits_count
  end

  def number_of_editing_credits
    counter.editing_credits_count
  end

  def number_of_cinematography_credits
    counter.cinematography_credits_count
  end

  def number_of_acting_credits
    counter.acting_credits_count
  end
end
