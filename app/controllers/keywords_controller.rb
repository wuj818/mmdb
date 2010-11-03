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
    @keywords = @keywords.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @keywords = @keywords.paginate(:page => page, :per_page => per_page)
  end

  def show
    @title = @keyword
    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.with_keywords @keyword
    @movies = @movies.paginate(:page => page, :per_page => per_page)
  end

  def search
    redirect_to formatted_search_keywords_path :q => params[:q]
  end

  private

  def page
    params[:page]
  end

  def per_page
    params[:per_page] || 50
  end

  def get_keyword
    @keyword = params[:id]
    raise ActiveRecord::RecordNotFound if Tag.find_by_name(@keyword).blank?
  end
end
