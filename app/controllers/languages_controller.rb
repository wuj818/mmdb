class LanguagesController < ApplicationController
  before_filter :get_language, :only => :show

  def index
    @title = 'languages'
    @languages = Tag.order(tag_order)
    @languages = @languages.select('name, COUNT(*) AS total, AVG(rating) AS average')
    @languages = @languages.joins(:taggings)
    @languages = @languages.joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    @languages = @languages.where('context = ?', 'languages')
    @languages = @languages.group(:name)
    @languages = @languages.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @languages = @languages.paginate(:page => page, :per_page => per_page)
  end

  def show
    @title = @language
    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.with_languages @language
    @movies = @movies.paginate(:page => page, :per_page => per_page)
  end

  def search
    redirect_to formatted_search_languages_path :q => params[:q]
  end

  private

  def page
    params[:page]
  end

  def per_page
    params[:per_page] || 50
  end

  def get_language
    @language = params[:id]
    raise ActiveRecord::RecordNotFound if Tag.find_by_name(@language).blank?
  end
end
