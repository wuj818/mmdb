$ ->
  $('.carousel').carousel() if $('#person-carousel .item').length > 1

  $('.dropdown-toggle').dropdown()

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

# $ ->
#   $(".alert-message").alert()
#   $(".tabs").button()
#   $(".collapse").collapse()
#   $(".modal").modal
#   $(".navbar").scrollspy()
#   $(".tab").tab "show"
#   $(".tooltip").tooltip
#   $(".typeahead").typeahead()
