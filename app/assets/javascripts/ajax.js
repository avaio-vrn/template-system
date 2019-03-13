var AjaxPaths = {
  tc: variables.domain_with_protocol_port + '/template_system/template_contents/',
  ttc: variables.domain_with_protocol_port + '/template_system/template_table_contents/',
  smt: variables.domain_with_protocol_port + '/seo/meta_tags/'
}

$.ajaxRequest = {
  settings: false,
  progress: false
}

if(!$.ajaxRequest.settings){
  $( document ).ajaxStart(function() {
    $.ajaxRequest.progress = true;
    $.spinner.show();
    $( document ).ajaxComplete(function(event, xhr, settings) {
      $.spinner.hide();
      $.ajaxRequest.progress = false;
    });
    $( document ).ajaxError(function(event, xhr, options, exc) {
      // alert('Не удалось получить данные!' + ' ' + exc);
    });
  });
  $.ajaxRequest.settings = true
}
