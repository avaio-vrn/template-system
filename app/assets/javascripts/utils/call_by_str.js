function callByStr(item, func_str) {
  switch (func_str) {
    case 'enableClientSideValidations':
      $(item).find('form').enableClientSideValidations();
      break;
    case 'formWithTerms':
      formWithTerms();
      break;
    case 'formLabelTrans':
      formLabelTrans();
      break;
  }
}
