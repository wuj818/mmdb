module PeopleHelper
  def colorized_score(person)
    tag.span "#{format '%.2f', person.score}/10", class: color
  end

  def approval_icon(person)
    icon = person.approval_percentage >= 60 ? 'icons/thumb-up-32x32.png' : 'icons/thumb-down-32x32.png'

    image_tag icon, title: 'Approval Percentage', width: 32, height: 32
  end

  def colorized_approval_percentage(person)
    color = person.approval_percentage >= 60 ? 'green' : 'red'

    tag.span "#{person.approval_percentage}%", class: "#{color}-rating"
  end

  def person_rating_class(person)
    color = if person.score < 6
      'red'
    elsif person.score < 8
      'orange'
    else
      'green'
    end

    "#{color}-rating"
  end
end
