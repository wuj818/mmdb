$ ->
  $('.close').live 'click', ->
    $(@).parent().fadeOut 500

  $('.icons a, .graph-link').hover(
    -> $(@).animate opacity: 0.5, 200
    -> $(@).animate opacity: 1.0, 200
  )

  $('.table-striped tr').hover(
    -> $(@).addClass 'highlighted-row'
    -> $(@).removeClass 'highlighted-row'
  )

  $('.scroll').on 'click', (e) ->
    anchor = $(@).attr 'href'
    $.scrollTo anchor, 1000, offset: -50
