//--------------------  resize text-area  ------------------------//
var observe;
if (window.attachEvent) {
  observe = function(element, event, handler) {
    element.attachEvent('on' + event, handler);
  };
} else {
  observe = function(element, event, handler) {
    element.addEventListener(event, handler, false);
  };
}

function init_textarea() {
  var text = document.getElementsByClassName('js__edit-textarea')[0];

  function resize() {
    text.style.height = 'auto';
    text.style.height = text.scrollHeight + 'px';
  }
  /* 0-timeout to get the already changed text */
  function delayedResize() {
    window.setTimeout(resize, 0);
  }
  observe(text, 'change', resize);
  observe(text, 'cut', delayedResize);
  observe(text, 'paste', delayedResize);
  observe(text, 'drop', delayedResize);
  observe(text, 'keydown', delayedResize);

  text.focus();
  text.select();
  resize();
}
//--------------------  resize text-area  ------------------------//

var SavedFunc = {
  save: function(without_confirm) {
    if ((without_confirm == true) || confirm('Сохранить изменения?')) {
      if ($("div.template").find('.js__post-form').length == 0) SavedFunc.save_content();
      else SavedFunc.form_save_content();
    }
  },
  save_content: function() {
    $.ajax({
      type: "PUT",
      url: AjaxPaths[BackendData.data_name] + BackendData.id,
      data: {
        data_name: BackendData.data_name,
        target_id: BackendData.id,
        id: BackendData.template_id,
        sending_data: BackendData.sending_data,
        values: $('.js__edit-textarea').map(function() {
          return $(this).val();
        }).get()
      }
    });
    EditingFunc.buttons.unbind_events();
    return false;
  },
  form_save_content: function save_content() {
    if ($("div.template").find("#raw_values").length != 0) {
      for (instance in CKEDITOR.instances)
        CKEDITOR.instances[instance].updateElement();
    }
    var formData = new FormData($("div.template").find('.js__post-form')[0]);

    $.ajax({
      type: 'PUT',
      url: AjaxPaths[BackendData.data_name] + BackendData.id,
      data: formData,
      cache: false,
      contentType: false,
      processData: false,
    });
    EditingFunc.buttons.unbind_events();
    return false;
  },
  cancel_save_content: function() {
    if (confirm('Отменить изменения?')) {
      $.ajax({
        type: "GET",
        url: AjaxPaths[BackendData.data_name] + BackendData.id,
        data: {
          data_name: BackendData.data_name,
          target_id: BackendData.id,
          id: BackendData.template_id,
          sending_data: BackendData.sending_data
        }
      });
      EditingFunc.buttons.unbind_events();
      return false;
    }
  }
};

var EditingFunc = {
  cancel_state: true,
  buttons: {
    add: function() {
      $("div.editing").append('<div class="a-s-editing edit-block edit-block-show clfl">\
                              <span class="hint hint-bottom"></span>\
                              <span class="ts-icons icon-save"></span>\
                              <span class="ts-icons icon-abort"></span>\
                              </div>');

      $(".icon-save").click(function(event) {
        EditingFunc.click_event(event)
      });
      $(".icon-abort").click(function(event) {
        SavedFunc.cancel_save_content()
      });
    },
    unbind_events: function() {
      $('body').unbind('click');
      $('body').unbind('keydown');
    }
  },
  click_event: function(event) {
    if ($(event.target).hasClass('icon-abort')) return;
    if ($(document).find(".editing").length == 0) return;
    if ($(event.target).closest('.editing').length != 0 && !$(event.target).hasClass('ts-icons')) return;
    event.preventDefault();
    event.stopPropagation();
    EditingFunc.cancel_state = false;
    SavedFunc.save();
  },
  keydown_event: function(e) {
    var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
    if (e.keyCode == 27) {
      if (EditingFunc.cancel_state) {
        if ($(document).find(".editing").length == 0) return;
        SavedFunc.cancel_save_content();
      }
      EditingFunc.cancel_state = !EditingFunc.cancel_state;
    } else if (e.ctrlKey === true && key === 13 && !$.ajaxRequest.process) {
      EditingFunc.cancel_state = false;
      SavedFunc.save(true);
    }
  },
  load: function() {
    init_textarea();
    $('.admin-stroke > .edit-block-show').removeClass('edit-block-show');
    $('body').unbind('click').bind('click', this.click_event);
    $('body').unbind('keydown').bind('keydown', this.keydown_event);
  }
}
