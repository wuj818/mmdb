<% movies = j render('movies/list') %>
$('#movies-container').html "<%= movies %>"
