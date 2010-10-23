class MoviesController < ApplicationController
  before_filter :authorize, :except => [:index, :show]
  before_filter :get_movie, :only => [:show, :edit, :update, :destroy]

  def index
    @movies = Movie.order(order).paginate(:page => page, :per_page => per_page)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @movies }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @movie }
    end
  end

  def new
    @movie = Movie.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @movie }
    end
  end

  def edit
  end

  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        format.html do
          flash[:success] = %("#{@movie.title}" was successfully added.)
          redirect_to movies_path
        end
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html do
          flash[:success] = %("#{@movie.title}" was successfully edited.)
          redirect_to @movie
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    title = @movie.title
    @movie.destroy

    respond_to do |format|
      format.html do
        flash[:success] = %("#{title}" was successfully deleted.)
        redirect_to movies_path
      end
      format.xml  { head :ok }
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
    @movie = Movie.find_by_permalink(params[:id])
    raise ActiveRecord::RecordNotFound if @movie.blank?
  end
end
