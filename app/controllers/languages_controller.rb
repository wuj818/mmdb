class LanguagesController < ApplicationController
  before_filter :get_language, :only => :show

  def index
    @title = 'Languages'
    @languages = Tag.order(tag_order)
    @languages = @languages.select('name, COUNT(*) AS total, AVG(rating) AS average')
    @languages = @languages.joins(:taggings)
    @languages = @languages.joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    @languages = @languages.where('context = ?', 'languages')
    @languages = @languages.group(:name)
    @languages = @languages.having(tag_minimum)
    @languages = @languages.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @title = "Language - #{@language}"
    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.with_languages @language

    respond_to do |format|
      format.html
      format.js { render 'movies/index' }
    end
  end

  def stats
    @title = 'Languages - Stats'
  end

  private

  def get_language
    @language = params[:id]
    raise ActiveRecord::RecordNotFound if Tag.find_by_name(@language).blank?
  end
end
