class PeopleController < ApplicationController
  before_filter :authorize, :except => [:index, :show, :search]
  before_filter :get_person, :only => [:show, :edit, :update, :destroy]

  def index
    @title = 'People'
    @people = Person.order(order)
    @people = @people.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @people = @people.joins(:counter)
  end

  def show
    @title = @person.name
  end

  def edit
    @title = %(Edit "#{@person.name}")
  end

  def update
    @title = %(Edit "#{@person.name}")
    if @person.update_attributes params[:person]
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
    column = params[:sort] == 'name' ? 'sort_name' : params[:sort]
    column = case params[:sort]
    when 'credits' then 'credits_count'
    when 'directing' then 'directing_credits_count'
    when 'writing' then 'writing_credits_count'
    when 'composing' then 'composing_credits_count'
    when 'editing' then 'editing_credits_count'
    when 'cinematography' then 'cinematography_credits_count'
    when 'acting' then 'acting_credits_count'
    else 'sort_name'
    end

    params[:order] ||= 'asc'
    result = "#{column} #{params[:order]}"
    result << ', sort_name asc' unless params[:sort] == 'name'
    result
  end

  def get_person
    @person = Person.find_by_permalink params[:id]
    raise ActiveRecord::RecordNotFound if @person.blank?
  end
end
