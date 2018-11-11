class PagesController < ApplicationController
  before_action :authorize, only: [:clear_cache]

  def main
    @title = 'My Movie Database'
  end

  def admin_controls
    unless admin?
      render body: nil, status: 401
    end
  end

  def clear_cache
    Rails.cache.clear

    flash[:success] = 'Cache was successfully cleared.'

    redirect_to root_path
  end
end
