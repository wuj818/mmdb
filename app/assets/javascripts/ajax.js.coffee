$ ->
  $.ajaxSetup cache: true

  if history and history.pushState
    $('body').on 'click', 'a[data-remote="true"]', ->
      history.pushState null, document.title, @.href
      if ENV is 'production'
        _gaq.push ['_trackPageview', $(@).attr 'href']

    # pjax popstate on initial page load solution
    popped = 'state' in window.history
    initialUrl = location.href
    $(window).bind 'popstate', ->
      initialPop = not popped and location.href is initialUrl
      popped = true
      return if initialPop

      $.getScript location.href
      if ENV is 'production'
        _gaq.push ['_trackPageview', location.pathname + location.search]
