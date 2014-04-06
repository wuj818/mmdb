#= require jquery
#= require jquery.ui.all
#= require jquery_ujs
#= require bootstrap
#= require plugins
#= require bs3-group

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
