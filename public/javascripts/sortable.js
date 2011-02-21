$(function() {
  $('ul#movies').sortable({
    axis: 'y',
    update: function() {
      $(this).sortable('disable');
      $(this).find('li').each(function() {
        $(this).find('.rank').html('#' + ($(this).index()+1));
      });
      $(this).effect('highlight', {}, 800, function() {
        $(this).sortable('enable');
      });
    }
  });

  $('#reorder_link').click(function() {
    $.ajax({
      type: 'put',
      data: $('ul#movies').sortable('serialize'),
      url: $(this).attr('href')
    });
    return false;
  });
});
