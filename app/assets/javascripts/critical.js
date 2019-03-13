//= require constants/admin_panel

var calculateMarginContent = function() {
  var closeLinkWidth = PANEL_CONST.closeLinkWidth,
    leftPanelOpen = document.body.classList.contains('open-left'),
    leftPanelWidth = PANEL_CONST.leftPanel.width + closeLinkWidth,
    rightPanelOpen = document.body.classList.contains('open-right'),
    rightPanelWidth = PANEL_CONST.rightPanel.width + closeLinkWidth,
    container = document.getElementsByClassName("ts-admin-container")[0],
    clientWidth = document.body.clientWidth,
    blankPart = clientWidth - CONTENT.width,
    blankPartOne = blankPart / 2,
    wrapMarginLeft = 0,
    calculate;

  if (CONTENT.mainWrapElem != undefined) {
    wrapMarginLeft = CONTENT.mainWrapElem.offsetLeft;
  }

  if (wrapMarginLeft < blankPartOne) {
    blankPartOne = wrapMarginLeft
  }

  if (leftPanelOpen && rightPanelOpen) {
    if (blankPartOne + CONTENT.width < clientWidth - rightPanelWidth) {
      container.style.marginLeft = (blankPart - leftPanelWidth - rightPanelWidth) / 2 - blankPartOne + leftPanelWidth + 'px';
    } else {
      container.style.marginLeft = leftPanelWidth - blankPartOne + 'px';
    }
  } else
  if (rightPanelOpen) {
    if (blankPartOne - leftPanelWidth + closeLinkWidth + CONTENT.width < clientWidth - rightPanelWidth) {
      calculate = (blankPart - closeLinkWidth - rightPanelWidth) / 2 - blankPartOne + closeLinkWidth;
      if (calculate > wrapMarginLeft) {
        calculate = wrapMarginLeft
      };
      container.style.marginLeft = calculate + 'px';
    } else {
      container.style.marginLeft = closeLinkWidth - blankPartOne + 'px';
    }
  } else
  if (leftPanelOpen) {
    if (blankPartOne + CONTENT.width < clientWidth - leftPanelWidth - closeLinkWidth) {
      calculate = -(blankPart - closeLinkWidth - leftPanelWidth) / 2 + blankPartOne - closeLinkWidth;
      if (calculate < wrapMarginLeft && wrapMarginLeft < leftPanelWidth) {
        calculate = leftPanelWidth
      }
      container.style.marginLeft = calculate + 'px';
    } else {
      container.style.marginLeft = leftPanelWidth - blankPartOne + 'px';
    }
  } else
    container.style.marginLeft = 0;
}

calculateMarginContent();
