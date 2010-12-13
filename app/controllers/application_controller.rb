class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper
  include MoviesHelper
  include TagsHelper
  include PagesHelper

  def search
    values = {}
    values.merge!(:format => :js) if request.xhr?
    unless params[:minimum].blank?
      params[:minimum] = params[:minimum].to_i
      values = {:minimum => params[:minimum]}
    end
    values.merge!(:q => params[:q]) unless params[:q].blank?
    values.merge!(:type => params[:type]) if controller_name == 'tags'
    redirect_to send("formatted_search_#{controller_name}_path", values)
  end
end
