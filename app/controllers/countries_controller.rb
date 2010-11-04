class CountriesController < ApplicationController
  before_filter :get_country, :only => :show

  def index
    @title = 'Countries'
    @countries = Tag.order(tag_order)
    @countries = @countries.select('name, COUNT(*) AS total, AVG(rating) AS average')
    @countries = @countries.joins(:taggings)
    @countries = @countries.joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    @countries = @countries.where('context = ?', 'countries')
    @countries = @countries.group(:name)
    @countries = @countries.having(tag_minimum)
    @countries = @countries.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
  end

  def show
    @title = "Country - #{@country}"
    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.with_countries @country
  end

  private

  def get_country
    @country = params[:id]
    raise ActiveRecord::RecordNotFound if Tag.find_by_name(@country).blank?
  end
end
