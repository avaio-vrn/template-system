function hideBottomPanel() {
  var height = $('.ts-admin-panel--bottom > div').height();
  if (height > 0) {
    $('footer').css('padding-bottom', '0')
    window.variables.panelBottom.animate({
        bottom: height * -1
      }, 300,
      function() {
        window.variables.panelBottom.find('>div').remove();
      }
    );
  }
};


function showBottomPanel() {
  var height = $('.ts-admin-panel--bottom > div').height(),
    footerHeight = $('footer').height();
  if (height > footerHeight) {
    $('footer').css('padding-bottom', height + 'px')
  }
  window.variables.panelBottom.css('bottom', height * -1);
  window.variables.panelBottom.animate({
    bottom: 0
  }, 300);
};

window.variables.panelBottom.off('TS.panel.bottom.hide').on('TS.panel.bottom.hide', function() {
  hideBottomPanel()
});
window.variables.panelBottom.off('TS.panel.bottom.show').on('TS.panel.bottom.show', function() {
  showBottomPanel()
});
