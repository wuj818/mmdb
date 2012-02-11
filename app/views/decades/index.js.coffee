<% decades = j render('list').squish.html_safe %>
$("#decades-container").html "<%= decades %>"
