$ ->
  $('.close').live 'click', ->
    $(@).parent().fadeOut 500

  $('#genre_checkboxes label').live 'click', ->
    $(@).prev().attr 'checked', not $(@).prev().is ':checked'

  $('#ajax_button').live 'click', ->
    $('#ajax_button_indicator').fadeIn()

  $('.icons a, .graph-link').hover(
    -> $(@).animate opacity: 0.5, 200
    -> $(@).animate opacity: 1.0, 200
  )

  $('.btn.loading').click ->
    $(@).button 'loading'

  $('.table-striped tr').hover(
    -> $(@).addClass 'highlighted-row'
    -> $(@).removeClass 'highlighted-row'
  )
