var hcClient = function() {
  $('.js__panel-state ').on('click', function() {
    setTimeout(function() {
      thePopper.update();
    }, 500)
  });
}

hcClient();
