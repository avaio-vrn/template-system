var keyDown = function(e, input) {
  var key = e.which;
  if (e.ctrlKey === true && key === 13 && !window.variables.ajaxForm.process) {
    window.variables.TsForm.submit();
    e.preventDefault();
    e.stopPropagation();
  } else if (input) {
    var inputs = $(e.target).closest('form').find(':input:visible:not([readonly])');
    if (key == 13) {
      e.preventDefault();

      inputs.eq(inputs.index(e.target) + 1).focus();
    }
  }
};

var submitForm = function() {
  window.variables.ajaxForm.process = false;
  window.variables.TsForm.submit(function(event) {
    if (window.variables.ajaxForm.process) {
      event.preventDefault();
      return false;
    }
  });
  window.variables.TsForm.off('ajax:beforeSend').on('ajax:beforeSend', function() {
    window.variables.ajaxForm.process = true;
    $(this).parent().hide();
    window.variables.TsForm.off('ajax:complete').on('ajax:complete', function() {
      window.variables.ajaxForm.process = false;
    });
  });
}

$(".f-a-file").change(function() {
  showPreviewImage(this);
});

var enterInsteadTab = function() {
  var contentHeader = $("input[name$='[content_header]']");
  if (contentHeader.length != 0 && contentHeader.val().length == 0) {
    var contentName = $("input[name$='[content_name]']");
    contentName.on('change textInput input', function(event) {
      contentHeader.val($(this).val());
    });
  }

  $(document).ready(function() {
    if ($('.js__template-system').length > 0) {
      $('textarea').off('keydown').on('keydown', function(e) {
        keyDown(e)
      });
      $('input[type="number"]').off('focus').on('focus', function(e) {
        $(e.target).select();
      })

      $('input').off('keyup').on('keyup', function(e) {
        keyDown(e, true)
      });
      $(document).off('keyup').on('keyup', function(e) {
        keyDown(e)
      });
    }
  })

};

enterInsteadTab();

$(".danger-button").click(function(e) {
  $(this).toggleClass("d-b-long");
  $(".danger").toggleClass("invisible");
});
