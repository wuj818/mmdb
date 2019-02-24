class DecadesController < ApplicationController
  before_action :get_decade, only: [:show]

  caches_action :index, :show,
                cache_path: -> { request.path },
                expires_in: 2.weeks

  DECADES = (1890..Time.zone.now.year).step 10

  def index
    @title = 'Decades'

    @decades = Movie.order(order)
    @decades = @decades.select('(year / 10) || "0" AS decade, COUNT(*) AS total, AVG(rating) AS average')
    @decades = @decades.group('(year / 10) || "0"')
    @decades = @decades.having(minimum)
    @decades = @decades.where('((year / 10) || "0") LIKE ?', "%#{params[:q]}%") if params[:q].present?
    @decades = @decades.page(page).per(per_page)
  end

  def show
    @title = "Decades - #{@decade}s"

    @movies = Movie.order(movie_order)
    @movies = @movies.where('year >= ? AND year < ?', @decade, @decade + 10)
    @movies = @movies.page(page).per(per_page)
  end

  private

  def get_decade
    @decade = params[:id].to_i

    raise ActiveRecord::RecordNotFound unless DECADES.include? @decade
  end

  def order
    params[:sort] ||= 'decade'

    column = case params[:sort]
    when 'total' then 'COUNT(*)'
    when 'average' then 'AVG(rating)'
    else '(year / 10) || "0"'
    end

    params[:order] ||= 'asc'

    result = "#{column} #{params[:order]}"
    result << ', COUNT(*) DESC' unless params[:sort] == 'total'
    result
  end

  def minimum
    "COUNT(*) >= #{params[:minimum].to_i}"
  end
end
