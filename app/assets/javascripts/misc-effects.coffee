$(document).on 'turbolinks:load', ->
  $('.icons a').hover(
    -> $(@).animate opacity: 0.5, 200
    -> $(@).animate opacity: 1.0, 200
  )
