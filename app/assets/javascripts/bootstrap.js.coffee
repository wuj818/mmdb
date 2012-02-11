$ ->
  $('.btn.loading').click ->
    $(@).button 'loading'

  if $('#person-carousel .item').length > 1
    $('.carousel').carousel()

  $('.dropdown-toggle').livequery ->
    $(@).dropdown()

  $('.percentage-popover').popover
    animation: false
    placement: 'top'
    title: 'Details'
    content: ->
      fraction = $(@).data 'fraction'
      fraction = "#{fraction} Movies"
      percentage = $(@).data 'percentage'
      percentage = "<span class='percentage'>#{percentage}</span>"
      "<strong>#{fraction} #{percentage}</strong>"

  $('.login').on 'click', ->
    $('#login-modal').modal().css
      'margin-left': ->
        10 - ($(this).width() / 2)
    return false

# $ ->
#   $(".alert-message").alert()
#   $(".tabs").button()
#   $(".collapse").collapse()
#   $(".modal").modal
#   $(".navbar").scrollspy()
#   $(".tab").tab "show"
#   $(".tooltip").tooltip
#   $(".typeahead").typeahead()
