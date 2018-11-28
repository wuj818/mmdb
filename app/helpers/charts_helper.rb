module ChartsHelper
  def chart(id, options)
    tag.div id: id, class: 'chart', data: { options: options.to_json }
  end

  def no_chart_data
    tag.code 'no chart data...'
  end

  def movie_credits_column_chart(person)
    data = person.movie_credits_column_chart_data
    return no_chart_data if data.blank?

    options = {
      title: { text: 'Movies Over Time' },
      chart: { type: 'column' },
      yAxis: { allowDecimals: false },
      series: [
        {
          name: 'Movies',
          data: data
        }
      ]
    }

    chart 'movie-credits-column-chart', options
  end

  def movie_ratings_pie_chart(person)
    data = person.movie_ratings_pie_chart_data
    return no_chart_data if data.blank?

    options = {
      title: { text: 'Ratings Breakdown' },
      chart: { type: 'pie' },
      series: [
        {
          name: 'Movies',
          data: data
        }
      ]
    }

    chart 'movie-ratings-pie-chart', options
  end
end
