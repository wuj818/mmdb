class PeopleController < ApplicationController
  before_action :authorize, only: [:edit, :update, :destroy]
  before_action :get_person, only: [:edit, :update, :destroy]

  caches_action :show, :charts, :keywords, expires_in: 2.weeks

  def index
    @title = 'People'
    @people = Person.order(order)
    @people = @people.where('name LIKE ?', "%#{params[:q]}%") unless params[:q].blank?
    @people = @people.joins(:counter).includes(:counter)
    @people = @people.page(page).per(per_page)
  end

  def show
    @person = Person.find_by_permalink! params[:id]

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

  def charts
    @person = Person.find_by_permalink! params[:id]

    @title = "#{@person.name} - Charts"
  end

  def keywords
    @person = Person.find_by_permalink! params[:id]

    @title = "#{@person.name} - Keywords"
  end

  private

  def person_params
    params.fetch(:person).permit!
  end

  def get_person
    @person = Person.find_by_permalink! params[:id]
  end

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
end
