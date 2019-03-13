//= require ../html/modal
//= require ../html/close_button

;
(function() {
  function iconMove(obj) {
    $(obj).off('click').on('click', function(event) {
      $('body').append(modal);
    })
  }

  window.initIconMove = function(obj) {
    new iconMove(obj);
  }
})();
