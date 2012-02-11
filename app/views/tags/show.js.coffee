<% movies = j render('movies/list').squish.html_safe %>
$('#movies-container').html "<%= movies %>"
