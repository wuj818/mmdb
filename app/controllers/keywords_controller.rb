class KeywordsController < ApplicationController
  before_filter :get_keyword, :only => :show

  def index
    @title = 'Keywords'
    @keywords = Tag.order(tag_order)
    @keywords = @keywords.select('name, COUNT(*) AS total, AVG(rating) AS average')
    @keywords = @keywords.joins(:taggings)
    @keywords = @keywords.joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    @keywords = @keywords.where('context = ?', 'keywords')
    @keywords = @keywords.group(:name)
    @keywords = @keywords.having(tag_minimum)
    @keywords = @keywords.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @title = "Keyword - #{@keyword}"
    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.with_keywords @keyword

    respond_to do |format|
      format.html
      format.js { render 'movies/index' }
    end
  end

  def stats
    @title = 'Keywords - Stats'
  end

  private

  def get_keyword
    @keyword = params[:id]
    raise ActiveRecord::RecordNotFound if Tag.find_by_name(@keyword).blank?
  end
end
