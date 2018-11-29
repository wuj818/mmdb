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
      plotOptions: {
        series: {
          dataLabels: {
            format: '{point.name} ({point.percentage:,.2f}%)'
          }
        }
      },
      series: [
        {
          name: 'Movies',
          data: data
        }
      ]
    }

    chart 'movie-ratings-pie-chart', options
  end

  def movie_genres_bar_chart(person)
    data = person.movie_genres_bar_chart_data
    return no_chart_data if data.blank?

    options = {
      title: { text: 'Genres' },
      chart: { type: 'bar' },
      legend: { enabled: false },
      xAxis: { categories: data.map(&:first) },
      series: [
        {
          name: 'Movies',
          data: data.map(&:last)
        }
      ]
    }

    chart 'movie-genres-bar-chart', options
  end
end
