window.variables = {
  domain_with_protocol_port: location.protocol+'//'+location.hostname+(location.port ? (':' + location.port) : ''),
  ajaxForm: {
    process: false
  }
}

window.variables.TsForm = $('form');
if(window.variables.TsForm.length > 1) {
  window.variables.TsForm = $('form.js__template-system');
}

window.variables.panelBottom = $('.ts-admin-panel--bottom');
