var PANEL_CONST = Object.freeze({
  closeLinkWidth: 20,
  leftPanel: {
    width: 160
  },
  rightPanel: {
    width: 310
  }
})

if (CONTENT == undefined) {
  var CONTENT = {
    mainWrapClass: 'wrap'
  }
}

CONTENT.mainWrapElem = document.getElementsByClassName(CONTENT.mainWrapClass)[0];
CONTENT.width = CONTENT.mainWrapElem.clientWidth;
