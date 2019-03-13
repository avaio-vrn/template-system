//= require variables
//= require spinner
//= require ajax
//= require panel
//= require admin_forms
//
function showPreviewImage(input) {
  if (input.files && input.files[0] && (/\.(gif|jpe?g|png|svg)$/i).test(input.files[0].name)) {
    var reader = new FileReader();

    reader.onload = function (e) {
      var stroke = $(input).closest('.admin-stroke');
      if (stroke.length == 0) { stroke =  $(input).closest('.admin-stroke--no') }
      stroke.find('.js__image-preview').attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]);
  }
}

