$ ->
  $('.icons a, .graph-link').hover(
    -> $(@).animate opacity: 0.5, 200
    -> $(@).animate opacity: 1.0, 200
  )
