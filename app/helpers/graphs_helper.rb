module GraphsHelper
  def movie_history_line_graph(person)
    history = person.movie_history

    average_rating_values = history.map { |h| { x: h.year, y: h.average } }
    total_movies_values = history.map { |h| { x: h.year, y: h.total } }

    graph_data = [
      { key: 'Average Rating', values: average_rating_values },
      { key: 'Total Movies', values: total_movies_values }
    ]

    data = {
      'graph-data' => graph_data.to_json,
      'y-max' => [10, history.map(&:total).max].max
    }

    content_tag :div, id: 'movie-history-line-graph', data: data do
      content_tag :svg
    end
  end

  def movie_ratings_pie_graph(person)
    history = person.movie_ratings_history

    graph_data = history.map { |h| { label: h.rating, value: h.total, percent: 9 } }
    puts graph_data.inspect

    data = {
      'graph-data' => graph_data.to_json,
      total: history.map(&:total).sum
    }

    content_tag :div, id: 'movie-ratings-pie-graph', data: data do
      content_tag :svg
    end
  end
end
