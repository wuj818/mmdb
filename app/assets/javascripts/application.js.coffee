#= require jquery
#= require jquery.ui.all
#= require jquery_ujs
#= require bootstrap
#= require plugins
#= require_tree .

$ ->
  $('body').tooltip
    selector: '.tip'

  $sidebar = $('#sidebar-navigation')

  $sidebar.affix
    offset:
      top: ->
        @top = $sidebar.offset().top - $('.navbar-fixed-top').height()

      bottom: ->
        @bottom = $('footer').outerHeight()

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
