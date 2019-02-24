class TagsController < ApplicationController
  before_action :get_type

  caches_action :index, :show,
                cache_path: -> { request.path },
                expires_in: 2.weeks

  TYPES = %w[countries genres keywords languages]

  def index
    @title = @type.capitalize

    @tags = Tag.order(order)
    @tags = @tags.select('name, AVG(rating) AS average, taggings_count')
    @tags = @tags.joins(:taggings)
    @tags = @tags.joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    @tags = @tags.where('context = ?', @type)
    @tags = @tags.group(:name)
    @tags = @tags.having(minimum)
    @tags = @tags.where('name LIKE ?', "%#{params[:q]}%") if params[:q].present?
    @tags = @tags.page(page).per(per_page)
  end

  def show
    @tag = CGI.unescape params[:id]

    Tag.find_by!(name: @tag)

    @title = "#{@type.capitalize} - #{@tag}"

    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") if params[:q].present?
    @movies = @movies.send 'tagged_with', @tag, on: @type
    @movies = @movies.page(page).per(per_page)
  end

  private

  def get_type
    @type = params[:type]

    raise ActiveRecord::RecordNotFound unless TYPES.include? @type
  end

  def order
    params[:sort] ||= 'name'

    column = case params[:sort]
    when 'total' then :taggings_count
    when 'average' then 'AVG(rating)'
    else 'name'
    end

    params[:order] ||= 'asc'

    result = "#{column} #{params[:order]}"
    result << ', taggings_count DESC' unless params[:sort] == 'total'
    result
  end

  def minimum
    "taggings_count >= #{params[:minimum].to_i}"
  end
end
