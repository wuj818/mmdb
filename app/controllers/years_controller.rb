class YearsController < ApplicationController
  before_filter :get_year, :only => :show

  def index
    @title = 'Years'

    @years = Movie.order(order)
    @years = @years.select('year, COUNT(*) AS total, AVG(rating) AS average')
    @years = @years.group(:year)
    @years = @years.having(minimum)
    @years = @years.where('year LIKE ?', "%#{params[:q]}%") unless params[:q].blank?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @title = "Years - #{@year}"

    @movies = Movie.order(movie_order)
    @movies = @movies.where(:year => @year)
  end

  def stats
    @title = 'Years - Stats'
  end

  private

  def get_year
    @year = params[:id].to_i
  end

  def order
    params[:sort] ||= 'year'
    column = case params[:sort]
    when 'total' then 'COUNT(*)'
    when 'average' then 'AVG(rating)'
    else 'year'
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
