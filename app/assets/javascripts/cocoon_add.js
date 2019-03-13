//= require cocoon

$(function() {
  function check_to_hide_or_show_add_link(fields) {
    if ($(fields).children('.js__nested-fields').length == 1) {
      $(fields).find('.js__one-record').hide();
    } else {
      $(fields).find('.js__one-record').show();
    }
  }
  $(document).bind('cocoon:after-insert', function(e, insertedItem) {
    check_to_hide_or_show_add_link($(insertedItem).parent());
    var top = $('html').scrollTop();
    var field = insertedItem;
    $('html').scrollTop(top+field.outerHeight());
    $(field).find('.f-a-file').change(function(){
      showPreviewImage(this);
    })
  });
  $(document).bind('cocoon:after-remove', function(e, insertedItem) {
    check_to_hide_or_show_add_link($(this));
  });

  check_to_hide_or_show_add_link($('tbody'));
});
