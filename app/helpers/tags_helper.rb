module TagsHelper
  def tag_order
    params[:sort] ||= 'name'
    column = case params[:sort]
    when 'total' then 'COUNT(*)'
    when 'average' then 'AVG(rating)'
    else 'name'
    end

    params[:order] ||= 'asc'
    result = "#{column} #{params[:order]}"
    result << ', COUNT(*) DESC' unless params[:sort] == 'total'
    result
  end

  def tag_minimum
    "COUNT(*) >= #{params[:minimum].to_i}"
  end

  def tag_link(tag, type, options = {})
    type = type.to_s.pluralize
    link_to tag.name, "/#{type}/#{URI.escape tag.name}", options
  end

  def colorized_average(tag)
    average = tag.average
    color = if average <= 5
      'red'
    elsif average <= 6
      'orange'
    else
      'green'
    end
    content_tag :span, format('%.2f', average), :class => color
  end
end
