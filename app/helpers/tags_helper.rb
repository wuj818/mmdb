module TagsHelper
  def tag_link(tag, type, options = {})
    type = type.to_s.pluralize
    link_to tag.name, "/#{type}/#{CGI::escape tag.name}", options
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
end
