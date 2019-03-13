//= require data_actions/destroy
//= require data_actions/del
//= require data_actions/change_row_num
//= require data_actions/move

;(function(){
  var initIconAction = function(obj, list_object){
    if($(obj).find('.ts-icons').length == 0) { return false; }
    var dataAttr = $(obj).data();

    $(obj).find('.js__ts-icons').map(function(i, icon){
      if(!list_object) { if ($(icon).closest('.li-admin-stroke').length != 0) { return false; } }

      if ($(icon).hasClass('icon-destroy')){ initIconDestroy(icon); }
      if ($(icon).hasClass('icon-delete')){ initIconDelSet(icon); }
      if ($(icon).hasClass('icon-up')){ initIconRowNum($(icon).closest('.up-down-container')); }
      if ($(icon).hasClass('icon-move')){ initIconMove($(icon).closest('.icon-move-container')); }
    })
  };


  var init = function(container){
    var stroke = (container == undefined || container.length == 0) ? $('.admin-stroke') : $(container);

    $(stroke).map(function(i, obj){
      initIconAction(obj, false);
    });

    var li = (container == undefined || container.length == 0) ? $('.li-admin-stroke') : $(container).find('.li-admin-stroke');
    $(li).map(function(i, obj){
      initIconAction(obj, true);
    })
  }

  window.initIcons = function(obj){
    init(obj);
  }
})();
