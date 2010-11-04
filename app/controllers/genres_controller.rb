class GenresController < ApplicationController
  before_filter :get_genre, :only => :show

  def index
    @title = 'Genres'
    @genres = Tag.order(tag_order)
    @genres = @genres.select('name, COUNT(*) AS total, AVG(rating) AS average')
    @genres = @genres.joins(:taggings)
    @genres = @genres.joins('INNER JOIN movies ON taggings.taggable_id = movies.id')
    @genres = @genres.where('context = ?', 'genres')
    @genres = @genres.group(:name)
    @genres = @genres.having(tag_minimum)
    @genres = @genres.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
  end

  def show
    @title = @genre
    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.with_genres @genre
  end

  private

  def get_genre
    @genre = params[:id]
    raise ActiveRecord::RecordNotFound if Tag.find_by_name(@genre).blank?
  end
end
