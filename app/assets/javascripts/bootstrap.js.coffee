$ ->
  $('.btn.loading').click ->
    $(@).button 'loading'

  if $('#person-carousel .item').length > 1
    $('.carousel').carousel()

  $('.percentage-popover').popover
    animation: false
    html: true
    placement: 'top'
    title: 'Details'
    trigger: 'hover'
    content: ->
      fraction = $(@).data 'fraction'
      fraction = "#{fraction} Movies"
      percentage = $(@).data 'percentage'
      percentage = "<span class='percentage'>(#{percentage})</span>"
      "<strong>#{fraction} #{percentage}</strong>"

  $('.login').on 'click', ->
    $('#login-modal').modal().css
      'margin-left': ->
        10 - ($(this).width() / 2)
    return false
