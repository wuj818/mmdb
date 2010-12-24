module PeopleHelper
  def colorized_score(person)
    color = if person.score < 6
      'red'
    elsif person.score < 8
      'orange'
    else
      'green'
    end

    content_tag :span, "#{format '%.2f', person.score}/10", :class => color
  end

  def approval_icon(person)
    icon = person.approval_percentage >= 60 ? 'icons/thumb-up.png' : 'icons/thumb-down.png'
    image_tag icon, :title => 'Approval Percentage'
  end

  def colorized_approval_percentage(person)
    color = person.approval_percentage >= 60 ? 'green' : 'red'
    content_tag :span, "#{person.approval_percentage}%", :class => color
  end
end
