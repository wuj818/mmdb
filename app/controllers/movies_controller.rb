class MoviesController < ApplicationController
  before_filter :authorize, only: [:new, :create, :edit, :update, :destroy, :scrape_info]
  before_filter :get_movie, only: [:edit, :update, :destroy]

  caches_action :show, :keywords, :perfect, expires_in: 2.weeks

  def index
    @title = 'Movies'

    @movies = Movie.order(movie_order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.page(page).per(per_page)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @movie = Movie.find_by_permalink! params[:id]

    @title = @movie.full_title
  end

  def new
    @title = 'New Movie'

    @movie = Movie.new

    render :from_imdb if params[:from_imdb]
  end

  def edit
    @title = %(Edit "#{@movie.full_title}")
  end

  def create
    @title = 'New Movie'

    @movie = Movie.new params[:movie]

    if @movie.save
      flash[:success] = %("#{@movie.title}" was successfully added.)

      redirect_to @movie
    else
      render :new
    end
  end

  def update
    @title = %(Edit "#{@movie.full_title}")

    if @movie.update_attributes params[:movie]
      flash[:success] = %("#{@movie.title}" was successfully edited.)

      redirect_to @movie
    else
      render :edit
    end
  end

  def destroy
    title = @movie.title

    @movie.destroy

    flash[:success] = %("#{title}" was successfully deleted.)

    redirect_to movies_path
  end

  def scrape_info
    @title = 'New Movie'

    if params[:imdb_url].blank?
      flash[:danger] = 'You must supply an IMDb url.'

      redirect_to new_movie_path(from_imdb: true)
    else
      @movie = Movie.new imdb_url: params[:imdb_url]
      @movie.get_preliminary_info

      flash.now[:info] = %(Scrape results for "#{params[:imdb_url]}".)

      render :new
    end
  end

  def keywords
    @movie = Movie.find_by_permalink! params[:id]

    @title = "#{@movie.full_title} - Keywords"
  end

  def perfect
    @title = 'Perfect Movies'

    @movies = Movie.where(rating: 10).order('year DESC, sort_title DESC')
  end

  private

  def get_movie
    @movie = Movie.find_by_permalink! params[:id]
  end
end
