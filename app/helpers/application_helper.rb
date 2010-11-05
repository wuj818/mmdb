module ApplicationHelper
  def sort_link(column, title = nil)
    column = column.to_s
    title ||= column.to_s.titleize
    css_class = (column == params[:sort]) ? "current #{params[:order]}" : nil
    order = (column == params[:sort] && params[:order] == 'asc') ? 'desc' : 'asc'
    link_to title, url_for(:sort => column, :order => order, :minimum => params[:minimum], :page => params[:page], :q => params[:q]), :class => css_class
  end

  def smart_cache(key = '', &block)
    str = URI.decode request.path.slice(1..-1)
    str << "/#{key}" unless key.blank?
    cache(str, :expires_in => 2.weeks, &block)
  end
end
