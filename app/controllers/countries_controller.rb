class CountriesController < ApplicationController
  before_filter :get_country, :only => :show

  def index
    @title = 'countries'
    @countries = Tag.order(tag_order)
    @countries = @countries.select('name, COUNT(*) AS total, AVG(rating) AS average')
    @countries = @countries.joins(:taggings)
    @countries = @countries.joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    @countries = @countries.where('context = ?', 'countries')
    @countries = @countries.group(:name)
    @countries = @countries.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @countries = @countries.paginate(:page => page, :per_page => per_page)
  end

  def show
    @title = @country
    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.with_countries @country
    @movies = @movies.paginate(:page => page, :per_page => per_page)
  end

  def search
    redirect_to formatted_search_countries_path :q => params[:q]
  end

  private

  def page
    params[:page]
  end

  def per_page
    params[:per_page] || 50
  end

  def get_country
    @country = params[:id]
    raise ActiveRecord::RecordNotFound if Tag.find_by_name(@country).blank?
  end
end
