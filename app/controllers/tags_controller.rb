class TagsController < ApplicationController
  before_filter :get_type
  before_filter :get_tag, :only => :show

  TYPES = %(genres keywords languages countries)

  def index
    @title = @type.capitalize

    @tags = Tag.order(tag_order)
    @tags = @tags.select('name, COUNT(*) AS total, AVG(rating) AS average')
    @tags = @tags.joins(:taggings)
    @tags = @tags.joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    @tags = @tags.where('context = ?', @type)
    @tags = @tags.group(:name)
    @tags = @tags.having(tag_minimum)
    @tags = @tags.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @title = "#{@type.capitalize} - #{@tag}"

    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.send "tagged_with", @tag, :on => @type

    respond_to do |format|
      format.html
      format.js
    end
  end

  def stats
    @title = "#{@type.capitalize} - Stats"
  end

  private

  def get_type
    @type = params[:type]
    unless TYPES.include? @type
      render 'public/404.html', :layout => false
      return
    end
  end

  def get_tag
    @tag = params[:id]
    raise ActiveRecord::RecordNotFound if Tag.find_by_name(@tag).blank?
  end
end
