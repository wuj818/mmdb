module SessionsHelper
  def login_admin
    # TODO: use cookies for permanent login
    session[:remember_token] = true
  end

  def logout_admin
    session[:remember_token] = false
  end

  def admin?
    session[:remember_token]
  end
end
