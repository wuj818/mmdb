$(function() {
  $('a:not([rel=external])').live('click', function() {
    _gaq.push(['_trackPageview', $(this).attr('href')]);
  });

  $('#search_form').submit(function() {
    path = $(this).attr('action').replace('search', 'query/') + $('#q').serialize().replace('q=', '');
    _gaq.push(['_trackPageview', path]);
  });

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

  $('#ajax_button').live('click', function() {
    $('#ajax_button_indicator').fadeIn();
  });

  $('#ajax_activity')
    .ajaxStart(function() {
      $(this).show();
      $('.content').animate({ opacity: 0.5 }, 200);
    })
    .ajaxStop(function() {
      $(this).hide();
      $('.content').animate({ opacity: 1.0 }, 200);
    });
});
