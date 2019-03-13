jQuery.fn.extend({
  editing_content: function() {
    var name = $(this).data('name');
    var target_id = $(this).data(name + '-id')

    if (target_id && AjaxPaths[name]) {
      var model;
      $.ajax({
        type: 'GET',
        url: AjaxPaths[name] + target_id + '/edit',
        dataType: 'script',
        data: {
          data_name: name,
          target_id: target_id,
          sending_data: BackendData['sending_data']
        }
      });
    } else {
      alert('Ошибка поиска элемента для редактирования.');
    }
  }
});

jQuery.fn.extend({
  li_admin_stroke_enter: function() {
    $(this).mouseenter(function() {
      if ($(document).find('.a-s-editing').length == 0) {
        var edit = $(this).find('>.edit-block');
        if (edit.length == 0) {
          edit = $(this).parent().find('>.edit-block');;
        }
        $(document).find('.edit-block-show').removeClass('edit-block-show');
        $(edit).addClass('edit-block-show');
        $('.li-admin-stroke').mouseleave(function() {
          var edit = $(this).find('>.edit-block');
          if (edit.length == 0) {
            edit = $(this).parent().find('>.edit-block');;
          }
          $(edit).removeClass('edit-block-show');
          $(edit).mouseenter(function() {
            $(this).addClass('edit-block-show');
          });
          $(edit).mouseleave(function() {
            $(this).removeClass('edit-block-show');
          });
        });
      }
    });
  }
});

jQuery.fn.extend({
  admin_stroke_enter: function() {
    $(this).mouseenter(function() {
      if ($(document).find('.a-s-editing').length == 0) {
        var edit = $(this).find('>.edit-block');
        $(edit).addClass('edit-block-show');
        $('.admin-stroke').mouseleave(function() {
          var edit = $(this).find('>.edit-block');
          $(edit).removeClass('edit-block-show');
          $(edit).mouseenter(function() {
            $(this).addClass('edit-block-show');
          });
          $(edit).mouseleave(function() {
            $(this).removeClass('edit-block-show');
          });
        });
      }
    });
  }
});

$('.ts-admin-container').off('dblclick').on('dblclick', function(event) {
  if ($(event.target).closest('.js__content-editing').length > 0) {
    var editing = $(document).find('.editing');
    if (editing.length == 0) {
      event.preventDefault();
      event.stopPropagation();
      $(event.target).closest('.js__content-editing').editing_content();
    } else {
      alert('Редактирование другого элемента не закончено.');
    }
  }
});

$('.ts-admin-container').on('click', function(e) {
  if ($(e.target).is('a.js__content-editing')) {
    if (!e.ctrlKey) {
      e.preventDefault();
      e.stopPropagation();
    }
  }
});


$(document).find('.li-admin-stroke').li_admin_stroke_enter();
$('.admin-stroke').admin_stroke_enter();



//=================================javascript=================================//

function showButton(show) {
  var button = document.getElementsByClassName('js__btn-action'),
    i;

  for (var i = 0; i < button.length; i++) {
    button[i].style.display = show == true ? 'inline-block' : 'none';
    button[i].style.visibility = show == true ? 'visible' : 'hidden';
  }
}
