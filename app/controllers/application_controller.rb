class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :admin?

  def admin?
    session[:admin]
  end

  def login_admin
    session[:admin] = true
  end

  def logout_admin
    session[:admin] = nil
  end

  def deny_access
    session[:return_to] = request.fullpath
    flash[:notice] = 'You must be logged in to access this page.'
    redirect_to login_path
  end

  def redirect_back_or_to(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def authorize
    deny_access unless admin?
  end

  def movie_order
    params[:sort] ||= 'title'
    column = params[:sort] == 'title' ? 'sort_title' : params[:sort]
    params[:order] ||= 'asc'
    result = "#{column} #{params[:order]}"
    result << ', sort_title asc' unless params[:sort] == 'title'
    result
  end

  def tag_order
    params[:sort] ||= 'name'
    column = case params[:sort]
    when 'total' then 'COUNT(*)'
    when 'average' then 'AVG(rating)'
    else 'name'
    end

    params[:order] ||= 'asc'
    result = "#{column} #{params[:order]}"
    result << ', COUNT(*) DESC' unless params[:sort] == 'total'
    result
  end
end
