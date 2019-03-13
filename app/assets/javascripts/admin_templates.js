//= require variables

jQuery.fn.extend({
  list_template_types: function(elem) {
    var url;
    var wrap = $(elem).closest(".temp-wrap");
    if ($(elem).hasClass('js__type-category')) {
      $.spinner.create($(elem).parent(), 'before', true);
      $.map((wrap).find('.temp-part'), function(e, i) {
        $.spinner.create(e);
      });
      var ttc_id = $(elem).data('ttc');
      if (ttc_id == undefined) ttc_id = 0
      url = '/template_system/template_type_categories/' + ttc_id;
    } else {
      $.spinner.create($(elem).parent(), 'before', true);
      $.spinner.create($(elem).parent().parent().next('.temp-part'));
      url = '/template_system/template_types/' + $(elem).data('tt');
    }
    $.ajax({
        url: url,
        method: 'GET',
        dataType: 'script'
      })
      .done(function() {});
  },
  create_template_type: function(elem) {
    var wrap = $(elem).closest(".temp-wrap");
    var content_id = wrap.find('#content_id').val();
    var url = '/template_system/templates';
    var tt_type;
    tt_type = $(elem).data('tt');
    if (tt_type == undefined) tt_type = $(elem).closest('.js__type').data('tt');
    $.spinner.create(wrap, 'before', true);
    $.ajax({
      url: url,
      method: 'POST',
      dataType: 'JSONP',
      data: {
        content_id: content_id,
        template_system_template: {
          content_id: content_id,
          template_type_id: tt_type
        }
      }
    })
  }
});
var newTemplateButtonsClick = function(category_change) {
  if (category_change) {
    $('.temp-go').off('click').on('click', function(e) {
      if (!$(e.target).hasClass('js__template-submit')) {
        $(this).list_template_types(e.target.closest('.temp-go'));
      }
    })
  }
  $('.js__template-submit').off('click').on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    $(this).create_template_type(e.target);
  })
}

window.variables.panelBottom.off('TS.panel.bottom.update').on('TS.panel.bottom.update', function() {
  $.spinner.remove();

  $('.js__type-category-container').find('li:first').addClass('temp-go--active');
  $('.js__type-container').find('li:first').addClass('temp-go--active');

  $('.remove-block').on('click', function() {
    window.variables.panelBottom.trigger('TS.panel.bottom.hide');
  })

  newTemplateButtonsClick(true);

  window.variables.panelBottom.trigger('TS.panel.bottom.show');
})


window.variables.panelBottom.off('TS.template.create').on('TS.template.create', function() {
  var lastTemplate = $("section .template:last-child");

  lastTemplate.find('.li-admin-stroke').li_admin_stroke_enter();
  lastTemplate.admin_stroke_enter();

  hasImg = lastTemplate.find('img');
  if (hasImg.length > 0) {
    hasImg.load(function() {
      $('html, body').animate({
        scrollTop: lastTemplate.offset().top - window.innerHeight + lastTemplate.height() + $('.ts-admin-panel--bottom').height() + 45
      }, 400);
    })
  } else {
    $('html, body').animate({
      scrollTop: lastTemplate.offset().top - window.innerHeight + lastTemplate.height() + $('.ts-admin-panel--bottom').height() + 45
    }, 400);
  }
})
