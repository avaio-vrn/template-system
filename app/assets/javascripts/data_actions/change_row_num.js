;(function(){
  function IconContainerRowNum(obj){
    $(obj).off('click').on('click', function(event){
      var rowContainer = $(event.target).closest('.admin-stroke');
      var rowChildContainer = $(event.target).closest('.li-admin-stroke');
      this.thisList = rowChildContainer.length == 0 ? false : true;
      if (this.thisList){
        this.objData = iconsData.data[rowContainer.data('index')][rowContainer.data('index') + '-' + rowChildContainer.data('index')];
      }
      else {
        this.objData = iconsData.data[rowContainer.data('index')];
      }
      this.button = $(event.target);
      this.updown = this.button.hasClass('icon-up') ? 'up' : 'down';
      this.path = '/admin/change_row_num/' + this.objData.record['model'] + '/' + this.objData.record['id'] +'/' + this.updown;

      var request = $.ajax({
        url: this.path,
        type: 'POST',
        dataType: 'json',
        success: function(data){ changeState(data); },
        error: function(){ alert('Произошла ошибка! Сообщите разработчику! Спасибо.') }
      });

      var changeState = function(data){
        if(data == undefined) return;
        var firstRow = this.thisList ? $(rowChildContainer) : $(rowContainer);
        var secondRow = this.updown == 'up' ? firstRow.prev() : firstRow.next();
        var firstData = this.objData;
        var secondData;
        if (this.thisList){
          secondData = iconsData.data[rowContainer.data('index')][rowContainer.data('index') + '-' + secondRow.closest('.li-admin-stroke').data('index')];
        }
        else {
          secondData = iconsData.data[secondRow.data('index')];
        }
        var chain_row_data = $(secondRow).clone().prop("attributes");
        var chain_row_childrens = $(secondRow).children().detach();
        var chain_row_text = secondRow.text();
        var row_childrens = $(firstRow).children().detach();
        var row_text = firstRow.text();
        $(secondRow).text(row_text);
        $(secondRow).append(row_childrens).hide().fadeIn(500);
        $.each($(firstRow).prop("attributes"), function(){
          if(!/(-row|-index)$/.test(this.name)){ $(secondRow).attr(this.name, this.value); }
        });
        $(firstRow).text(chain_row_text);
        $(firstRow).append(chain_row_childrens).hide().fadeIn(500);
        $.each(chain_row_data, function(){
          if(!/(-row|-index)$/.test(this.name)){ $(firstRow).attr(this.name, this.value); }
        })

        if (this.thisList){
          iconsData.data[rowContainer.data('index')][rowContainer.data('index') + '-' + firstRow.closest('.li-admin-stroke').data('index')] = secondData;
          iconsData.data[rowContainer.data('index')][rowContainer.data('index') + '-' + secondRow.closest('.li-admin-stroke').data('index')] = firstData;
        }
        else {
          iconsData.data[firstRow.data('index')] = secondData;
          iconsData.data[secondRow.data('index')] = firstData;
        }

        initIcons(firstRow);
        initIcons(secondRow);

        var multiple = (this.updown == 'down') ? -1 : 1;
        $(window).scrollTop($(window).scrollTop()-$(firstRow).outerHeight(true) * multiple);
      }.bind(this);
    })
  }

  window.initIconRowNum = function(obj){
    new IconContainerRowNum(obj);
  }
})();
