module GenresHelper
  def genre_link(genre)
    link_to genre.name, "/genres/#{URI.escape genre.name}"
  end
end
