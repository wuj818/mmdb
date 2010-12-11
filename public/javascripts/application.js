fancybox_settings = {
  padding: 4,
  cyclic: true,
  centerOnScroll: true,
  overlayOpacity: 0.9,
  overlayColor: '#000',
  titlePosition: 'over',
  speedIn: 0,
  speedOut: 0,
  changeSpeed: 0,
  showCloseButton: false
}

$(function() {
  if ($('#env').hasClass('production')) {
    $('a[data-remote=true]').live('click', function() {
      _gaq.push(['_trackPageview', $(this).attr('href')]);
    });

    $('#search_form').submit(function() {
      path = $(this).attr('action').replace('search', 'query/') + $('#q').serialize().replace('q=', '');
      _gaq.push(['_trackPageview', path]);
    });
  }

  $('.close').live('click', function() { $(this).parent().fadeOut(500); });

  $('#genre_checkboxes label').live('click', function() {
    $(this).prev().attr('checked', !$(this).prev().is(':checked'));
  });

  var timer;
  $('#search_form input').keyup(function(e) {
    clearTimeout(timer);
    if (e.keyCode >= 46 || e.keyCode == 8) {
      timer = setTimeout(function() {
        $('#search_form').submit();
      }, 400);
    }
  });

  $('.tiny_poster_link').fancybox(fancybox_settings);

  $('#ajax_button').live('click', function() {
    $('#ajax_button_indicator').fadeIn();
  });

  $('#keyword_cloud a').tooltip({
    delay: 0,
    predelay: 100,
    offset: [-10, 0]
  });

  $('#ajax_activity')
    .ajaxStart(function() {
      $(this).show();
      $('.content').animate({ opacity: 0.5 }, 200);
    })
    .ajaxStop(function() {
      $(this).hide();
      $('.content').animate({ opacity: 1.0 }, 200);

      $('.tiny_poster_link').fancybox(fancybox_settings);
    });
});
