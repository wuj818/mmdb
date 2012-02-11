$ ->
  $.ajaxSetup cache: true

  show_loader = ->
    $('#ajax-activity').show()
    $('#ajax-table').animate opacity: 0.5, 200

  hide_loader = ->
    $('#ajax-activity').hide()

  $('#ajax-activity')
    .ajaxStart ->
      show_loader()
    .ajaxStop ->
      hide_loader()

  $('form').on 'submit', ->
    show_loader()

  if history and history.pushState
    $('a[data-remote="true"]').live 'click', ->
      history.pushState null, document.title, @.href
      if MMDb.production()
        _gaq.push ['_trackPageview', $(@).attr 'href']

    # pjax popstate on initial page load solution
    popped = 'state' in window.history
    initialUrl = location.href
    $(window).bind 'popstate', ->
      initialPop = not popped and location.href is initialUrl
      popped = true
      return if initialPop

      $.getScript location.href
      if MMDb.production()
        _gaq.push ['_trackPageview', location.pathname + location.search]
