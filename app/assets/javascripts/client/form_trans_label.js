function formLabelTrans() {
  $.map($(".form-label-trans").find('input:text, input:password, textarea'), function(e) {
    var label = $("label[for='" + e.id + "']");
    if (!label.hasClass('label-no-trans')) {
      if ($(e).val() != '') label.addClass("label-focus");
      label.addClass('label-show');
      $(e).focus(function() {
        label.addClass("label-focus");
        $(e).focusout(function() {
          if ($(e).val() == '' || $(e).val() == undefined) label.removeClass("label-focus");
        })
      });
    }
  });
}

$(document).ready(function() {
  formLabelTrans();
});
