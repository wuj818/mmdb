<% people = j render('list').squish.html_safe %>
$('#people-container').html "<%= people %>"
