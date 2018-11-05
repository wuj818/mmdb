class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper
  include MoviesHelper
  include TagsHelper
  include PagesHelper

  before_filter :block_google

  def search
    values = {}

    unless params[:minimum].blank?
      params[:minimum] = params[:minimum].to_i
      values = { minimum: params[:minimum] }
    end

    values.merge!(q: params[:q].sub('.', '')) unless params[:q].blank?
    values.merge!(type: params[:type]) if controller_name == 'tags'

    redirect_to send("formatted_search_#{controller_name}_path", values)
  end

  def block_google
    return if controller_name == 'pages' && action_name == 'main'

    if request.user_agent.to_s.match /googlebot/i
      render nothing: true, status: 410
    end
  end
end
