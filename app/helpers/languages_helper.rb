module LanguagesHelper
  def language_link(language)
    link_to language.name, "/languages/#{URI.escape language.name}"
  end
end
