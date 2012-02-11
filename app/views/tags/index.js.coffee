<% tags = j render('list').squish.html_safe %>
$("#<%= @type %>-container").html "<%= tags %>"
