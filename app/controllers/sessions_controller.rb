class SessionsController < ApplicationController
  def new
    @title = 'Login'
    if admin?
      flash[:notice] = 'You are already logged in.'
      redirect_to root_path
    end
  end

  def create
    @title = 'Login'
    if params[:session][:password] == PASSWORD
      login_admin
      flash[:success] = 'Logged in successfully.'
      redirect_back_or_to root_path
    else
      flash.now[:error] = 'Incorrect password.'
      render :new
    end
  end

  def destroy
    if admin?
      logout_admin
      flash[:success] = 'Logged out successfully.'
    else
      flash[:notice] = 'You are not logged in.'
    end
    redirect_to root_path
  end

  def integration_login
    login_admin
    redirect_to root_path
  end
end
