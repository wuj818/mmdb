#= require rails-ujs
#= require jquery3
#= require jquery-ui
#= require popper
#= require bootstrap
#= require plugins
#= require_tree .

$ ->
  $('body').tooltip
    selector: '.tip'

  $('.login').on 'click', ->
    $('#login-modal').modal()
    false

  $('#login-modal').on 'shown.bs.modal', ->
    $('#Password').focus()

  $('.percentage-popover').popover
    animation: false
    html: true
    placement: 'top'
    trigger: 'hover'
    content: ->
      fraction = $(@).data 'fraction'
      fraction = "#{fraction} Movies"
      percentage = $(@).data 'percentage'
      percentage = "<span class='text-primary'>(#{percentage})</span>"
      "<strong>#{fraction} #{percentage}</strong>"

  $('.carousel').carousel()
