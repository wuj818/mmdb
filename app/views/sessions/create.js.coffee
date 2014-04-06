<% flash = j render('shared/flashes').squish.html_safe %>

<% if admin? %>
  $.get '/admin-controls'
  $('#flashes').replaceWith "<%= flash %>"
  $('#login-modal').modal 'hide'
<% else %>
  $('#Password').val('').focus()
  $('#login-modal').effect 'shake', { times: 4, distance: 10 }, 50
  $('#login-button').button 'reset'
  $('.modal-body #flashes').remove()
  $('.modal-body').prepend "<%= flash %>"
<% end %>
