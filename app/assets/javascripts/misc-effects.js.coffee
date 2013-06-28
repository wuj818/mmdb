$ ->
  $('.close').on 'click', ->
    $(@).parent().fadeOut 500

  $('.icons a, .graph-link').hover(
    -> $(@).animate opacity: 0.5, 200
    -> $(@).animate opacity: 1.0, 200
  )

  $('.table-striped tr').hover ->
    $(@).toggleClass 'highlighted-row'

  if location.hash.length isnt 0
    $.scrollTo location.hash, 1000, offset: -50

  $('.scroll').on 'click', (e) ->
    anchor = $(@).attr 'href'
    $.scrollTo anchor, 1000, offset: -50
