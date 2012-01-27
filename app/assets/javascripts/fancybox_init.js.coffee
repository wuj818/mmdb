$ ->
  $('.tiny_poster_link').fancybox
      padding: 4
      cyclic: true
      overlayOpacity: 0.9
      overlayColor: '#000'
      titlePosition: 'over'
      speedIn: 0
      speedOut: 0
      changeSpeed: 0
      showCloseButton: false
      titleFormat: (title, currentArray, currentIndex, currentOpts) ->
        url = $("a[title='#{title}']").attr 'data-movie-url'
        "<div id='fancybox-title-over'><a href='#{url}'>#{title}</a></div>"
      onComplete: (links, index) ->
        if $('#env').hasClass 'production'
          title = $("a[href='#{links[index]}']").attr 'title'
          _gaq.push ['_trackEvent', 'Posters', 'Fancybox', title]
