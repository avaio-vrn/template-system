;(function(){
  function IconDestroy(obj){
    $(obj).off('click').on('click', function(event){
      if (confirm("Это полное удаление! Вы уверены на 100%? УДАЛИТЬ?") == true){
        var el = $(event.target);
        var rowContainer = $(obj).closest('.admin-stroke');
        var rowChildContainer = $(obj).closest('.li-admin-stroke');
        if (rowChildContainer.length == 0){
          this.objData = iconsData.data[rowContainer.data('index')];
          this.deletedContainer = rowContainer;
        }
        else {
          this.objData = iconsData.data[rowContainer.data('index')][rowContainer.data('index') + '-' + rowChildContainer.data('index')];
          this.deletedContainer = rowChildContainer;
        }
        var request = $.ajax({
          url: this.objData.record['action_path'] + '?r_id=' + this.objData.record['id'],
          type: 'DELETE',
          dataType: 'json',
          success: function(xhr){ removeContainer(); },
          error: function(xhr){ alert('Произошла ошибка! Сообщите разработчику! Спасибо.') }
        });

        var removeContainer = function(){
          $(this.deletedContainer).remove();
          if (rowChildContainer.length == 0){
            delete iconsData.data[rowContainer.data('index')];
          }
          else{
            delete iconsData.data[rowContainer.data('index')][rowContainer.data('index') + '-' + rowChildContainer.data('index')];
          }
        }.bind(this);
      }
    })
  }

  window.initIconDestroy = function(obj){
    new IconDestroy(obj);
  }
})();
