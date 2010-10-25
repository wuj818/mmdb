class CreditsController < ApplicationController
  before_filter :authorize
  before_filter :get_person

  def new
    @credit = Credit.new
  end

  def create
    @credit = Credit.new params[:credit]

    if @credit.save
      flash[:success] = %(#{@person.name} was successfully added as a #{@credit.job.downcase} for "#{@credit.movie.title}".)
      redirect_to @person
    else
      render :new
    end
  end

  def destroy
    @credit = Credit.find params[:id]
    person = @credit.person.name
    credit_type = Credit::JOBS[@credit.job]
    movie = @credit.movie.title
    @credit.destroy

    flash[:success] = %(#{person}'s #{credit_type} credit was successfully removed from "#{movie}".)
    redirect_to @person
  end

  private

  def get_person
    @person = Person.find_by_permalink params[:person_id]
    raise ActiveRecord::RecordNotFound if @person.blank?
  end
end
