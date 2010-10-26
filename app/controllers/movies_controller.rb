class MoviesController < ApplicationController
  before_filter :authorize, :except => [:index, :show]
  before_filter :get_movie, :only => [:show, :edit, :update, :destroy]

  def index
    @movies = Movie.order(order)
    @movies = @movies.where('title LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @movies = @movies.paginate(:page => page, :per_page => per_page)
  end

  def show
  end

  def new
    @movie = Movie.new
    render :from_imdb if params[:from_imdb]
  end

  def edit
  end

  def create
    @movie = Movie.new params[:movie]

    if @movie.save
      flash[:success] = %("#{@movie.title}" was successfully added.)
      redirect_to movies_path
    else
      render :new
    end
  end

  def update
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
    if params[:imdb_url].blank?
      flash[:error] = 'You must supply an IMDB url.'
      redirect_to new_movie_path(:from_imdb => true)
    else
      @movie = Movie.new :imdb_url => params[:imdb_url]
      @movie.get_preliminary_info
      flash.now[:info] = "Scrape results for '#{params[:imdb_url]}'"
      render :new
    end
  end

  private

  def order
    params[:sort] ||= 'title'
    column = params[:sort] == 'title' ? 'sort_title' : params[:sort]
    params[:order] ||= 'asc'
    result = "#{column} #{params[:order]}"
    result << ', sort_title asc' unless params[:sort] == 'title'
    result
  end

  def page
    params[:page]
  end

  def per_page
    params[:per_page] || 50
  end

  def get_movie
    @movie = Movie.find_by_permalink params[:id]
    raise ActiveRecord::RecordNotFound if @movie.blank?
  end
end