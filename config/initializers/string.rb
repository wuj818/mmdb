class String
  def to_permalink
    # get rid of periods and apostrophes
    # replace certain characters for better looking results
    delete('.').delete("'").gsub('&', 'and').parameterize
  end

  def to_sort_column
    # get rid of unnecessary words like 'a', 'an', and 'the'
    ActiveSupport::Inflector.transliterate to_permalink.tr('-', ' ').gsub(/\Aa /, '').gsub(/\Aan /, '').gsub(/\Athe /, '')
  end
end
