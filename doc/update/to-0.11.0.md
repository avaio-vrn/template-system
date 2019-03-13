1. change init critical.js
  javascript_tag('var CONTENT= Object.freeze({ width: document.getElementsByClassName("inner")[0].offsetWidth})')
  ->
  javascript_tag('var CONTENT = { mainWrapClass: "inner" }')

2. panel_actions.yml with namespaces
