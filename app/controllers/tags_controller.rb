class TagsController < ApplicationController
  before_action :get_type
  before_action :get_tag, only: [:show]

  TYPES = %w(countries genres keywords languages)

  def index
    @title = @type.capitalize

    @tags = Tag.order(order)
    @tags = @tags.select('name, COUNT(*) AS total, AVG(rating) AS average')
    @tags = @tags.joins(:taggings)
    @tags = @tags.joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    @tags = @tags.where('context = ?', @type)
    @tags = @tags.group(:name)
    @tags = @tags.having(minimum)
    @tags = @tags.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @tags = @tags.page(page).per(per_page)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @title = "#{@type.capitalize} - #{@tag}"

    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.send "tagged_with", @tag, on: @type
    @movies = @movies.page(page).per(per_page)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def get_type
    @type = params[:type]

    unless TYPES.include? @type
      render 'public/404.html', layout: false and return
    end
  end

  def get_tag
    @tag = CGI::unescape params[:id]

    Tag.find_by_name! @tag
  end

  def order
    params[:sort] ||= 'name'

    column = case params[:sort]
    when 'total' then 'COUNT(*)'
    when 'average' then 'AVG(rating)'
    else 'name'
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
