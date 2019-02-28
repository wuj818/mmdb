class CreditsController < ApplicationController
  before_action :authorize
  before_action :set_person

  def new
    @title = %(New Credit for "#{@person.name}")
    @credit = Credit.new
  end

  def create
    @title = %(New Credit for "#{@person.name}")
    @credit = Credit.new params[:credit]

    if @credit.save
      flash[:success] = %(#{@person.name} was successfully added as a #{@credit.job.downcase} for "#{@credit.movie.title}".)

      redirect_to @person
    else
      render :new
    end
  end

  def destroy
    @credit = Credit.find(params[:id])
    person = @credit.person.name
    credit_type = Credit::JOBS[@credit.job]
    movie = @credit.movie.title
    @credit.destroy

    flash[:success] = %(#{person}'s #{credit_type} credit was successfully removed from "#{movie}".)

    redirect_to @person
  end

  private

  def set_person
    @person = Person.find_by!(permalink: params[:person_id])
  end
end
