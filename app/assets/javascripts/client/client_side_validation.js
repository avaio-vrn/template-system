window.ClientSideValidations.callbacks.element.fail = function(element, message, callback) {
  callback();
  if (element.data('valid') !== false) {
  }
}

window.ClientSideValidations.callbacks.element.pass = function(element, callback) {
}
