module CountriesHelper
  def country_link(country)
    link_to country.name, "/countries/#{URI.escape country.name}"
  end
end
