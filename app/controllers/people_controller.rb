class PeopleController < ApplicationController
  before_filter :authorize, :except => [:index, :show]
  before_filter :get_person, :only => [:show, :edit, :update, :destroy]

  def index
    @people = Person.order(order)
    @people = @people.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @people = @people.paginate(:page => page, :per_page => per_page)
  end

  def show
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def create
    @person = Person.new(params[:person])

    if @person.save
      flash[:success] = %("#{@person.name}" was successfully added.)
      redirect_to people_path
    else
      render :new
    end
  end

  def update
    if @person.update_attributes(params[:person])
      flash[:success] = %("#{@person.name}" was successfully edited.)
      redirect_to @person
    else
      render :edit
    end
  end

  def destroy
    name = @person.name
    @person.destroy

    flash[:success] = %("#{name}" was successfully deleted.)
    redirect_to people_path
  end

  private

  def order
    params[:sort] ||= 'name'
    params[:order] ||= 'asc'
    "#{params[:sort]} #{params[:order]}"
  end

  def page
    params[:page]
  end

  def per_page
    params[:per_page] || 50
  end

  def get_person
    @person = Person.find_by_permalink(params[:id])
    raise ActiveRecord::RecordNotFound if @person.blank?
  end
end
