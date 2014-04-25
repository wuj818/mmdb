<% tags = j render('list') %>
$("#<%= @type %>-container").html "<%= tags %>"
