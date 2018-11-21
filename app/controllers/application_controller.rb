class ApplicationController < ActionController::Base
  include SessionsHelper
  include MoviesHelper
  include TagsHelper
  include PagesHelper

  def search
    values = {}

    unless params[:minimum].blank?
      params[:minimum] = params[:minimum].to_i
      values = { minimum: params[:minimum] }
    end

    values[:q] = params[:q].sub('.', '') unless params[:q].blank?
    values[:type] = params[:type] if controller_name == 'tags'

    redirect_to send("formatted_search_#{controller_name}_path", values)
  end
end
