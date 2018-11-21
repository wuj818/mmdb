class ApplicationController < ActionController::Base
  include SessionsHelper
  include MoviesHelper
  include TagsHelper
  include PagesHelper

  def search
    values = {}

    if params[:minimum].present?
      params[:minimum] = params[:minimum].to_i
      values = { minimum: params[:minimum] }
    end

    values[:q] = params[:q].sub('.', '') if params[:q].present?
    values[:type] = params[:type] if controller_name == 'tags'

    redirect_to send("formatted_search_#{controller_name}_path", values)
  end
end
