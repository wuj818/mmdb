$(function() {
  $('.close').live('click', function() { $(this).parent().fadeOut(500); });

  $('#genre_checkboxes label').live('click', function() {
    $(this).prev().attr('checked', !$(this).prev().is(':checked'));
  });

  $('#new_from_imdb').live('click', function() {
    $('#new_from_imdb_ajax').fadeIn();
  });
});