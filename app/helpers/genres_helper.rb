module GenresHelper
  def genre_link(genre)
    link_to genre.name, "/genres/#{genre.name.downcase}"
  end
end
