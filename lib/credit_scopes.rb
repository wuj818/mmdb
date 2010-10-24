module CreditScopes
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
end
