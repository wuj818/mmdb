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
    content_tag :span, movie.rating, :class => rating_class(movie)
  end

  def rating_class(movie)
    case movie.rating
    when 0..4 then 'red'
    when 5..7 then 'orange'
    when 8..10 then 'green'
    end
  end

  def original_movie_poster(movie)
    image_tag movie.poster.url(:original), :class => 'original_poster'
  end

  def tiny_movie_poster(movie)
    image_tag movie.poster.url(:tiny), :class => 'tiny_poster', :width => 20, :height => 30
  end
end
