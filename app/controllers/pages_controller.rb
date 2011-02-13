class PagesController < ApplicationController
  before_filter :authorize, :only => [:clear_cache]

  def main
    @title = 'My Movie Database'
  end

  def clear_cache
    Rails.cache.clear
    flash[:success] = 'Cache was successfully cleared.'
    redirect_to root_path
  end
end
