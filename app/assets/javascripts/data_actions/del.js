;(function(){
  function IconDelSet(obj){
    var rowContainer = $(obj).closest('.admin-stroke');
    var rowChildContainer = $(obj).closest('.li-admin-stroke');
    $(obj).off('click').on('click', function(event){
      if (rowChildContainer.length == 0){
        this.objData = iconsData.data[rowContainer.data('index')];
        this.deletedContainer = rowContainer;
      }
      else {
        this.objData = iconsData.data[rowContainer.data('index')][rowContainer.data('index') + '-' + rowChildContainer.data('index')];
        this.deletedContainer = rowChildContainer;
      }

      //REFACT
      // iconsData.getData(this);

      this.del = $(this).hasClass('icon-cancel-delete');
      this.message = this.del ? 'Снять пометку на удаление. ' : 'Пометить на удаление. ';
      this.path = '/admin/del/' + this.objData.record['model'] + '/' + this.objData.record['id'] +'/' + this.objData.record['model_engine'];

      if (this.del == true) { this.path = this.path + '/cancel'}
      else { this.path = this.path.replace(/\/cancel$/,'') }

      if (confirm(this.message + 'Вы уверены?') == true){
        var el = $(event.target);
        var request = $.ajax({
          url: this.path,
          type: 'POST',
          dataType: 'json'
        });

        var changeState = function(){
          this.del = !this.del;
          $(this).toggleClass('icon-cancel-delete');
          $(this.deletedContainer).toggleClass("delete-block");
          if (this.objData.record['can_destroy']) {
            if(this.del) {
              var destroyIcon = document.createElement("span");
              $(destroyIcon).addClass("ts-icons icon-destroy");
              $(this).after(destroyIcon);
              initIconDestroy(destroyIcon);
            }
            else{
              $(this.deletedContainer).find('.icon-destroy').unbind('click').remove();
            }
          }
        }.bind(this);

        request.success(changeState());
        request.error(function(xhr){alert('Произошла ошибка! Сообщите разработчику! Спасибо.')})
      }
    })
  }

  window.initIconDelSet = function(obj){
    new IconDelSet(obj);
  }
})();
