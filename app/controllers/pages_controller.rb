class PagesController < ApplicationController
  before_action :authorize, only: [:clear_cache]

  caches_action :main,
    cache_path: -> { request.path },
    expires_in: 2.weeks

  def main
    @title = 'My Movie Database'
  end

  def admin_controls
    head :unauthorized unless admin?
  end

  def clear_cache
    Rails.cache.clear

    flash[:success] = 'Cache was successfully cleared.'

    redirect_to root_path
  end
end
