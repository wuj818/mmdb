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

    if params[:password] == Rails.application.secrets.password
      login_admin

      flash[:success] = 'Logged in successfully.'

      respond_to do |format|
        format.html { redirect_back fallback_location: root_path }
        format.js
      end
    else
      flash.now[:danger] = 'Incorrect password.'

      respond_to do |format|
        format.html { render :new }
        format.js
      end
    end
  end

  def destroy
    if admin?
      logout_admin

      flash[:success] = 'Logged out successfully.'
    else
      flash[:warning] = 'You are not logged in.'
    end

    redirect_back fallback_location: root_path
  end
end
