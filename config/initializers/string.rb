class String
  def to_permalink
    # get rid of periods and apostrophes
    # replace certain characters for better looking results
    self.delete('.').delete("'").gsub('&', 'and').parameterize
  end
end
