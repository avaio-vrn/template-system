CKEDITOR.editorConfig = function(config) {
  config.enterMode = CKEDITOR.ENTER_BR;
  config.toolbar = [{
    name: 'links',
    items: ['Link', 'Unlink']
  }, {
    name: 'basicstyles',
    items: ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat']
  }];
};
