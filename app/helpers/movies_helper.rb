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
    rating = movie.rating
    color = case rating
    when 0..4 then 'red'
    when 5..7 then 'orange'
    when 8..10 then 'green'
    end
    content_tag :span, rating, :class => color
  end
end
