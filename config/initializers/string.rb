include ActiveSupport::Inflector

class String
  def to_permalink
    # get rid of periods and apostrophes
    # replace certain characters for better looking results
    self.delete('.').delete("'").gsub('&', 'and').parameterize
  end

  def to_sort_column
    # get rid of unnecessary words like 'a', 'an', and 'the'
    transliterate self.to_permalink.gsub('-', ' ').gsub(/\Aa /, '').gsub(/\Aan /, '').gsub(/\Athe /, '')
  end
end
