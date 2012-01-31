$ ->
  $('#ajax_activity')
    .ajaxStart ->
      $(@).show()
      $('.content').animate opacity: 0.5, 200
    .ajaxStop ->
      $(@).hide()
      $('.content').animate opacity: 1.0, 200

  if history and history.pushState
    $('a[data-remote="true"]').live 'click', ->
      history.pushState null, document.title, @.href
      if $('#env').hasClass 'production'
        _gaq.push ['_trackPageview', $(@).attr 'href']

    # pjax popstate on initial page load solution
    popped = 'state' in window.history
    initialUrl = location.href
    $(window).bind 'popstate', ->
      initialPop = not popped and location.href is initialUrl
      popped = true
      return if initialPop

      $.getScript location.href
      if $('#env').hasClass 'production'
        _gaq.push ['_trackPageview', location.pathname + location.search]
