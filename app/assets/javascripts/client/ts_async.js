//= require variables

var magnificGroupItems = function(element) {
  var $el = $(element),
    group = $el.data('group');
  if (group == undefined) {
    return [{
      src: $el.attr('href')
    }]
  } else {
    var currentElement = $el[0],
      previous = true,
      prevArr = [],
      nextArr = [];
    var allInGroup = document.querySelectorAll(".image-link[data-group='" + group + "']");
    for (var i = 0; i < allInGroup.length; i++) {
      if (allInGroup[i] == currentElement) {
        previous = false
      } else {
        if (previous) {
          prevArr.push(allInGroup[i]);
        } else {
          nextArr.push(allInGroup[i]);
        }
      }
    }

    return $.map([currentElement].concat(nextArr).concat(prevArr),
      function(element) {
        return {
          src: $(element).attr('href')
        }
      })
  }
}

var initFlashMessage = function() {
  if ($('.flash').length > 0) {
    if (window.variables.panelBottom == undefined || window.variables.panelBottom.length == 0) {
      $('.close-flash').click(function() {
        $('.flash').hide();
      });
      $('.flash').delay(5000).fadeOut(1000);
    } else {
      var timeout = setTimeout(function() {
        window.variables.panelBottom.trigger('TS.panel.bottom.hide')
      }, 5000);
      $('.close-flash').click(function() {
        clearTimeout(timeout);
        window.variables.panelBottom.trigger('TS.panel.bottom.hide');
      })
    }
  }
}

var showFlashMessage = function(messageHtml) {
  messageHtml = '<div class="flash">' + messageHtml + '<span class="close-flash"></span></div>';
  var flashContainer = $('.flash');

  if (flashContainer.length == 0) {
    if (window.variables.panelBottom == undefined || window.variables.panelBottom.length == 0) {
      $('footer').after(messageHtml);
    } else {
      window.variables.panelBottom.html(messageHtml)
      window.variables.panelBottom.trigger('TS.panel.bottom.show')
    }
  } else {
    flashContainer.replaceWith(messageHtml)
  }

  initFlashMessage();
}

function formWithTerms() {
  $(".js__form-with-terms").submit(function(e) {
    if (!$('.js__terms-of-service').is(":checked")) {
      $('.js__terms-of-service-error').html('Необходимо принять условия Пользовательского соглашения.');
      e.preventDefault();
      e.stopPropagation();
    }
  });

  $('.js__terms-of-service').click(function(e) {
    if (!$('.js__terms-of-service').is(":checked")) {
      $('.js__terms-of-service-error').html('Необходимо принять условия Пользовательского соглашения.');
    } else {

      $('.js__terms-of-service-error').html('');
    }
  });
}



window.requestAnimFrame = (function() {
  return window.requestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    function(callback) {
      window.setTimeout(callback, 1000 / 60);
    };
})();

function scrollToY(scrollTargetY, speed, easing) {
  var scrollY = window.scrollY || document.documentElement.scrollTop,
    scrollTargetY = scrollTargetY || 0,
    speed = speed || 2000,
    easing = easing || 'easeOutSine',
    currentTime = 0;

  var time = Math.max(.1, Math.min(Math.abs(scrollY - scrollTargetY) / speed, .8));

  var easingEquations = {
    easeOutSine: function(pos) {
      return Math.sin(pos * (Math.PI / 2));
    },
    easeInOutSine: function(pos) {
      return (-0.5 * (Math.cos(Math.PI * pos) - 1));
    },
    easeInOutQuint: function(pos) {
      if ((pos /= 0.5) < 1) {
        return 0.5 * Math.pow(pos, 5);
      }
      return 0.5 * (Math.pow((pos - 2), 5) + 2);
    }
  };

  function tick() {
    currentTime += 1 / 60;

    var p = currentTime / time;
    var t = easingEquations[easing](p);

    if (p < 1) {
      requestAnimFrame(tick);

      window.scrollTo(0, scrollY + ((scrollTargetY - scrollY) * t));
    } else {
      console.log('scroll done');
      window.scrollTo(0, scrollTargetY);
    }
  }
  tick();
}

function yaMetrikaExists() {
  return (typeof TS != 'undefined' && typeof TS.vars != 'undefined' && parseInt(TS.vars.ymetrika) != NaN && window["yaCounter" + TS.vars.ymetrika] != undefined);
}

$(document).ready(function() {
  $('.image-link').on('click', function(e) {
    e.preventDefault();
    $.magnificPopup.open({
      items: magnificGroupItems(e.currentTarget),
      type: 'image',
      gallery: {
        enabled: true
      },
    });
  })

  formWithTerms();
  initFlashMessage();

  // for (var i = 0, len = arr.length; i < len; i++) {}
  $.map(document.querySelectorAll('.js__lazy-content'), function(item, index) {
    $.ajax({
      url: '/lazy_content/' + item.getAttribute('class').
      replace(/(template|js__lazy-content|admin-stroke|delete-block)/g, '').trim() + '?i=' + index,
      dataType: 'script',
      error: function(xhr) {},
      success: function() {
        var load;
        $(item).html($.lazy_content[index]['html']);

        if ($.lazy_content[index]['load_js'].length > 0) {
          $.map($.lazy_content[index]['load_js'].split(','), function(script_name) {
            load = document.createElement("script");
            load.defer = true;
            load.src = '/theme_assets/javascripts/' + script_name.trim() + '.js';
            document.querySelector("body").appendChild(load);
          })
        }

        if ($.lazy_content[index]['stylesheet'].length > 0) {
          $.map($.lazy_content[index]['stylesheet'].split(','), function(name) {
            load = document.createElement("link");
            load.type = "text/css";
            load.rel = 'stylesheet';
            load.media = 'screen, print';
            load.href = '/theme_assets/stylesheets/' + name.trim() + '.css';
            document.querySelector("body").appendChild(load);
          })
        }

        $.map($.lazy_content[index]['js'].split(','), function(func_name) {
          callByStr(item, func_name.trim());
        })

      }
    })
  })

  $('.js__question-form, .js__order').click(function(e) {
    $.ajax({
      url: '/question_form',
      dataType: 'script',
      data: {
        form: e.target.getAttribute('data-form'),
        formCall: e.target.classList.contains('js__question-form') ? 'question' : 'order'
      }
    })

  });

  $('.message-to').click(function() {
    $.ajax({
      url: '/error_message',
      dataType: 'script'
    })
  })

})

document.dispatchEvent(new Event('client.ts_async.loaded'));
