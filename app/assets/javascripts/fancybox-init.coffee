$(document).on 'turbolinks:load', ->
  $('.tiny-poster-link').fancybox
    helpers:
      overlay:
        css:
          background: 'rgba(0, 0, 0, 0.9)'
      title: null
    loop: true
    padding: 0
    parent: '#content'
