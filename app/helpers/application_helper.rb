module ApplicationHelper
  def icon(name)
    content_tag :span, nil, class: "glyphicon glyphicon-#{name.to_s.parameterize}"
  end

  def sort_link(column)
    column = column.to_s
    new_order = (column == params[:sort] && params[:order] == 'asc') ? 'desc' : 'asc'
    url_options = {
      sort: column,
      order: new_order,
      minimum: params[:minimum],
      page: params[:page],
      q: params[:q]
    }

    link = link_to column.titleize, url_for(url_options), remote: true

    if column == params[:sort]
      direction = params[:order] == 'asc' ? 'up' : 'down'
      arrow = icon "arrow-#{direction}"
      "#{link} #{arrow}".html_safe
    else
      link
    end
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

  def active_tab_link?(action)
    action.to_s == action_name ? 'active' : nil
  end

  def colorized_average(obj)
    average = obj.average
    color = if average <= 5
      'red'
    elsif average <= 6
      'orange'
    else
      'green'
    end
    content_tag :span, format('%.2f', average), :class => "colorized #{color}"
  end

  def colorized_credit_average(average)
    color = if average <= 5
      'red'
    elsif average <= 6
      'orange'
    else
      'green'
    end
    content_tag :span, format('%.2f', average), :class => "colorized #{color}"
  end

  def tag_link(tag, type, options = {})
    type = type.to_s.pluralize
    link_to tag.name, "/#{type}/#{CGI::escape tag.name}", options
  end
end
