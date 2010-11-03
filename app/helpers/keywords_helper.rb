module KeywordsHelper
  def keyword_link(keyword)
    link_to keyword.name, "/keywords/#{URI.escape keyword.name}"
  end
end
