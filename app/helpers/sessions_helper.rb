module SessionsHelper
  def admin?
    cookies.signed[:admin] == Figaro.env.mmdb_password
  end

  def login_admin
    cookies.permanent.signed[:admin] = Figaro.env.mmdb_password
  end

  def logout_admin
    cookies.delete :admin
  end

  def deny_access
    session[:return_to] = request.fullpath

    flash[:danger] = 'You must be logged in to access this page.'

    redirect_to login_path
  end

  def redirect_back_or_to(default)
    redirect_to session[:return_to] || default

    session[:return_to] = nil
  end

  def authorize
    deny_access unless admin?
  end
end
