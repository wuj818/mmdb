class SessionsController < ApplicationController
  def new
    @title = 'Login'

    if admin?
      flash[:warning] = 'You are already logged in.'

      redirect_to root_path
    end
  end

  def create
    @title = 'Login'

    if params[:password] == Rails.application.credentials.password[Rails.env.to_sym]
      login_admin

      flash[:success] = 'Logged in successfully.'

      redirect_to root_path
    else
      flash.now[:danger] = 'Incorrect password.'

      render :new
    end
  end

  def destroy
    if admin?
      logout_admin

      flash[:success] = 'Logged out successfully.'
    else
      flash[:warning] = 'You are not logged in.'
    end

    redirect_to root_path
  end
end
