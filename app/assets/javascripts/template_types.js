$('.js__button-tag').click(function(){
  $('.js__button-part').hide();
});

$('.js__button-part').click(function(){
  $('.js__button-tag').hide();
});

if($('form > .js__nested-tag-fields').length != 0) { $('.js__button-part').hide(); }
if($('form > .js__nested-part-fields').length != 0) { $('.js__button-tag').hide(); }


$(document).bind('cocoon:after-remove', function(e, insertedItem) {
  if(!$('form > .js__nested-tag-fields').is(":visible") && !$('form > .js__nested-part-fields').is(":visible")){
    $('.js__button-tag').show();
    $('.js__button-part').show();
  }
});
