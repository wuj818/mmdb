$(function() {
  $('.close').live('click', function() {
    $(this).parent().fadeOut(500);
  });

  $('#genre_checkboxes label').live('click', function() {
    $(this).prev().attr('checked', !$(this).prev().is(':checked'));
  });

  $('#ajax_button').live('click', function() {
    $('#ajax_button_indicator').fadeIn();
  });

  $('#keyword_cloud a, #frequent_collaborators a, #tags a:not(.more)').tooltip({
    delay: 0,
    predelay: 100,
    offset: [-10, 0]
  });

  $('.icons a, .graph_link').hover(
    function() { $(this).animate({opacity: 0.5}, 200); },
    function() { $(this).animate({opacity: 1.0}, 200); }
  );

  $('.tiny_poster_link').fancybox({
    padding: 4,
    cyclic: true,
    overlayOpacity: 0.9,
    overlayColor: '#000',
    titlePosition: 'over',
    speedIn: 0,
    speedOut: 0,
    changeSpeed: 0,
    showCloseButton: false,
    titleFormat: function(title, currentArray, currentIndex, currentOpts) {
      var url = $('a[title="' + title + '"]').attr('data-movie-url');
      return '<div id="fancybox-title-over">' +
             '<a href="' + url + '">' + title + '</a>' +
             '</div>';
    },
    onComplete: function(links, index) {
      if ($('#env').hasClass('production')) {
        var title = $('a[href="' + links[index] + '"]').attr('title');
        _gaq.push(['_trackEvent', 'Posters', 'Fancybox', title]);
      }
    }
  });
});
