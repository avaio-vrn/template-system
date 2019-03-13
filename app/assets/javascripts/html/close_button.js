var closeButton = '<a href="#" class="js__element-close element-close element-close--inside"></a>'

;(function(){
  function closeButtonJS(obj){
    $(obj).off('click').on('click', function(){
      $('.dialog-container').remove();
    })
  }

  window.closeButtonInit = function(obj){
    new closeButtonJS(obj);
  }
})();
