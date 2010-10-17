class MoviesController < ApplicationController
  before_filter :authorize, :except => [:index, :show]

  def index
    @movies = Movie.order(order).paginate(:page => page, :per_page => per_page)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @movies }
    end
  end

  def show
    @movie = Movie.find_by_permalink(params[:id])

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
    @movie = Movie.find_by_permalink(params[:id])
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
    @movie = Movie.find_by_permalink(params[:id])

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
    @movie = Movie.find_by_permalink(params[:id])
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
    params[:order] ||= 'asc'
    result = "#{params[:sort]} #{params[:order]}"
    result << ', title asc' unless params[:sort] == 'title'
    result
  end

  def page
    params[:page]
  end

  def per_page
    params[:per_page] || 50
  end
end
