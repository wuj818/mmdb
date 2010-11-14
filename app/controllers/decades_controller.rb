class DecadesController < ApplicationController
  before_filter :get_decade, :only => :show

  DECADES = (1890..2010).step(10)

  def index
    @title = 'Deacades'

    @decades = Movie.order(order)
    @decades = @decades.select('(year / 10) || "0" AS decade, COUNT(*) AS total, AVG(rating) AS average')
    @decades = @decades.group(:decade)
    @decades = @decades.having(minimum)
    @decades = @decades.where('decade LIKE ?', "%#{params[:q]}%") unless params[:q].blank?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @title = "Decades - #{@decade}s"

    @movies = Movie.order(movie_order)
    @movies = @movies.where('year >= ? AND year < ?', @decade, @decade + 10)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def stats
    @title = 'Decades - Stats'
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
    else 'decade'
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
