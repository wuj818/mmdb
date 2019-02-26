class TagsController < ApplicationController
  before_action :get_type

  caches_action :index, :show,
                cache_path: -> { request.path },
                expires_in: 2.weeks

  TYPES = %w[countries genres keywords languages]

  def index
    @title = @type.capitalize

    @tags = Tag.order(order)
    @tags = @tags.select('name, COUNT(*) AS total, AVG(rating) AS average')
    @tags = @tags.joins(:taggings)
    @tags = @tags.where(taggings: { taggable_type: 'Movie', context: @type })
    @tags = @tags.joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    @tags = @tags.group(:name)
    @tags = @tags.having(minimum)
    @tags = @tags.where('name LIKE ?', "%#{params[:q]}%") if params[:q].present?
    @tags = @tags.page(page).per(per_page)
  end

  def show
    @tag = CGI.unescape(params[:id])

    Tag.find_by!(name: @tag)

    @title = "#{@type.capitalize} - #{@tag}"

    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") if params[:q].present?
    @movies = @movies.send('tagged_with', @tag, on: @type)
    @movies = @movies.page(page).per(per_page)
  end

  private

  def get_type
    @type = params[:type]

    raise ActiveRecord::RecordNotFound unless TYPES.include?(@type)
  end

  def order
    params[:sort] ||= 'name'

    column = case params[:sort]
    when 'total' then :total
    when 'average' then 'AVG(rating)'
    else 'name'
    end

    params[:order] ||= 'asc'

    result = "#{column} #{params[:order]}"
    result << ', total DESC' unless params[:sort] == 'total'

    Arel.sql(result)
  end

  def minimum
    "COUNT(*) >= #{params[:minimum].to_i}"
  end
end
