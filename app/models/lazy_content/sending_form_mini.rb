# frozen_string_literal: false

class LazyContent::SendingFormMini < ::LazyContent::Base
  def initialize

  end

  def partial
    '/lazy_content/sending_form_mini'
  end

  def js
   "enableClientSideValidations, formWithTerms, formLabelTrans"
  end

  def stylesheet
    nil
  end
end
