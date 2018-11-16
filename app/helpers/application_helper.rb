module ApplicationHelper
  def icon(names = 'flag', options = {})
    classes = [:fa].concat names.to_s.split.map { |name| "fa-#{name}" }

    classes << options.delete(:class)
    text = options.delete :text
    icon = content_tag :i, nil, options.merge(class: classes.compact)

    return icon if text.blank?

    result = [icon, ERB::Util.html_escape(text)]
    safe_join (options.delete(:text_first) ? result.reverse : result), ' '
  end

  def sort_link(column, icon_name = nil)
    column = column.to_s
    new_order = (column == params[:sort] && params[:order] == 'asc') ? 'desc' : 'asc'

    url_options = {
      sort: column,
      order: new_order,
      minimum: params[:minimum],
      page: params[:page],
      q: params[:q]
    }

    text = column.titleize

    if icon_name.present?
      link = link_to icon(icon_name), url_for(url_options), class: 'tip', title: text
    else
      link = link_to text, url_for(url_options)
    end

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

    cache str, expires_in: 2.weeks, &block
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

    content_tag :strong, format('%.2f', average), class: "#{color}-rating"
  end

  def colorized_credit_average(average)
    color = if average <= 5
      'red'
    elsif average <= 6
      'orange'
    else
      'green'
    end

    content_tag :strong, format('%.2f', average), class: "#{color}-rating"
  end

  def tag_link(tag, type, options = {})
    type = type.to_s.pluralize

    link_to tag.name, "/#{type}/#{CGI::escape tag.name}", options
  end

  def page_header
    content_tag :div, class: 'pb-2 mb-4 border-bottom' do
      yield
    end
  end

  def no_index?
    return true if action_name == 'show'
    return true if page.to_i > 1
    return true if params[:q].present?

    if params[:sort].present?
      return true unless %w(decade name title year).include? params[:sort]
    end

    if params[:order].present?
      return true unless params[:order] == 'asc'
    end

    false
  end
end
