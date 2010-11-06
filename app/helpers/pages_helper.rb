module PagesHelper
  def page
    params[:page]
  end

  def per_page
    params[:per_page] || 100
  end
end
