//= require 'help_client/popper'

var thePopper;

popper = {
  popper_overlay: '<div class="js__popper-overlay popper-overlay"></div>',
  top_with_close: '<div class="row-top clfl">\
          <div class="element-close">\
        </div>\
        </div>',
  bottom_with_prev: '<div class="row-bottom clfl">\
        <span class="hc__prev btn btn--prev"></span>\
        </div>',
  bottom_with_next: '<div class="row-bottom clfl">\
        <span class="hc__next btn btn--next"></span>\
        </div>',
  bottom_with_prev_next: '<div class="row-bottom clfl">\
        <span class="hc__next btn btn--next"></span>\
        <span class="hc__prev btn btn--prev"></span>\
        </div>',
  popper_overlay_show: function() {
    $(thePopper.rel_element).after(this.popper_overlay);
    $(thePopper.rel_element).css('z-index', '990');
  },
  before_show: function() {
    if (thePopper) this.destroy();
  },
  show: function(data) {
    var reference = document.querySelector(data['render_on_dom_elem']);
    var content = this.top_with_close + '<div class="popper-content">' + data['text'] + '</div>';

    if (data['next_step']) {
      if (data['step'] > 1) {
        content = content + this.bottom_with_prev_next
      } else {
        content = content + this.bottom_with_next
      }
    } else {
      if (data['step'] > 1) content = content + this.bottom_with_prev
    }

    this.before_show();

    thePopper = new Popper(
      reference, {
        content: content,
        contentType: 'html'
      }, {
        placement: data['render_position'],
        removeOnDestroy: true
      }
    );
    thePopper.rel_element = reference;

    if (data['script']) {
      $.ajax({
        url: '/help_client/new/' + data['script'],
        dataType: 'script'
      })
    }

    if (data['render_overlay']) {
      this.popper_overlay_show();
    }

    if (data['next_step']) {
      helpClient.next();
    }
    if (data['step'] > 1) {
      helpClient.prev();
    }

    $(thePopper._popper).find('.element-close').on('click', $.proxy(function() {
      this.destroy();
    }, this))
  },
  destroy: function() {
    $('.js__popper-overlay').remove();
    $(thePopper.rel_element).css('z-index', '');
    thePopper.destroy();
  }
}

helpClient = {
  step: 0,
  request: function(c_elem, direction, callback, error_callback) {
    helpClient.step = helpClient.step + direction;

    if (thePopper) {
      $.spinner.create(thePopper._popper)
      $.spinner.show(true)
    }

    $.ajax({
        url: '/help_client/show',
        method: 'GET',
        data: {
          data: {
            elem: c_elem,
            step: helpClient.step
          }
        },
        dataType: 'json'
      })
      .success(callback)
      .error(error_callback)
  },
  init: function() {
    $('document').ready(function() {
      helpClient.request('', 1, function(data) {
        popper.show(data);
      });
    })
  },
  current: function() {
    $('.hc__prev').off('click').on('click', function() {
      helpClient.request('', 0, function(data) {
        popper.show(data);
      });
    })
  },
  prev: function() {
    $('.hc__prev').off('click').on('click', function() {
      helpClient.request('', -1, function(data) {
        popper.show(data);
      });
    })
  },
  next: function() {
    $('.hc__next').off('click').on('click', function() {
      helpClient.request('', 1, function(data) {
        popper.show(data);
      });
    })
  }
}

helpClient.init()
