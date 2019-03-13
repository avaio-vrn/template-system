$('.js__address').change(function(e) {

  var value = this.value.replace(new RegExp(' ', 'g'), '+');
  if (value.length > 10) {
    if ($('.js__spinner').children('.upload-spinner').length == 0) {
      $.spinner.create();
    }
    $.spinner.show();
    $.ajax({
      dataType: 'jsonp',
      url: 'https://geocode-maps.yandex.ru/1.x/?format=json&geocode=' + value,
      success: function(result) {
        var count = result["response"]["GeoObjectCollection"]["metaDataProperty"]["GeocoderResponseMetaData"]["found"] * 1,
          member = result["response"]["GeoObjectCollection"]["featureMember"];
        if (count > 0) {
          pos = member["0"]["GeoObject"]["Point"]["pos"].split(' ')
          document.getElementsByClassName('js__lgt')[0].value = pos[0]
          document.getElementsByClassName('js__lat')[0].value = pos[1]
        }
        $.spinner.hide()
      }
    })
  }
})
