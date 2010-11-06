module MoviesHelper
  def colorized_rating(movie)
    rating = movie.rating
    color = case rating
    when 0..4 then 'red'
    when 5..7 then 'orange'
    when 8..10 then 'green'
    end
    content_tag :span, rating, :class => color
  end

  def colorized_average(tag)
    average = tag.average
    color = if average <= 5
      'red'
    elsif average <= 6
      'orange'
    else
      'green'
    end
    content_tag :span, format('%.2f', average), :class => color
  end
end
