module ApplicationHelper
  def sort_link(column, title = nil)
    column = column.to_s
    title ||= column.to_s.titleize
    css_class = (column == params[:sort]) ? "current #{params[:order]}" : nil
    order = (column == params[:sort] && params[:order] == 'asc') ? 'desc' : 'asc'
    link_to title, url_for(:sort => column, :order => order, :minimum => params[:minimum], :page => params[:page], :q => params[:q]), :class => css_class, :remote => true
  end

  def smart_cache(key = '', &block)
    str = CGI::unescape request.path.slice(1..-1)
    str << "/#{key}" unless key.blank?
    cache(str, :expires_in => 2.weeks, &block)
  end

  def random_quote
    quote = QUOTES.sample
    source = quote.scan(/\A(.+?):/).flatten.first
    quote.gsub! "#{source}: ", ''
    content_tag :div, quote, :class => 'random_quote', :alt => source, :title => source
  end

  def active_nav_link?(name)
    name = name.to_s
    active = TagsController::TYPES.include?(name) ? @type : controller_name
    name == active ? 'active' : nil
  end
end
