$(function() {
  $('.close').live('click', function() { $(this).parent().fadeOut(500); });

  $('#genre_checkboxes label').live('click', function() {
    $(this).prev().attr('checked', !$(this).prev().is(':checked'));
  });

  $('#ajax_button').live('click', function() {
    $('#ajax_button_indicator').fadeIn();
  });

  $('#ajax_activity')
    .ajaxStart(function() { $(this).show(); })
    .ajaxStop(function() { $(this).hide(); });
});
