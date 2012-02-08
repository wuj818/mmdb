module MoviesHelper
  def movie_order
    params[:sort] ||= 'title'
    column = params[:sort] == 'title' ? 'sort_title' : params[:sort]
    params[:order] ||= 'asc'
    result = "#{column} #{params[:order]}"
    result << ', sort_title asc' unless params[:sort] == 'title'
    result
  end

  def colorized_rating(movie)
    content_tag :span, movie.rating, :class => movie_rating_class(movie)
  end

  def movie_rating_class(movie)
    color = case movie.rating
      when 0..4 then 'red'
      when 5..7 then 'orange'
      when 8..10 then 'green'
    end
    "colorized #{color}"
  end

  def tiny_movie_poster(movie)
    image_tag movie.poster.url(:tiny),
      :class => 'tiny-poster',
      :width => 20,
      :height => 30
  end

  def tiny_movie_poster_link(movie, job = nil)
    rel = job.blank? ? 'gallery' : "#{job.downcase}-gallery"
    title = job.blank? ? movie.full_title : "#{movie.full_title} - #{job}"
    link_to tiny_movie_poster(movie), movie.poster.url(:original),
      :class => 'tiny-poster-link',
      :rel => rel,
      :title => title,
      :'data-movie-url' => movie_path(movie)
  end
end
