# frozen_string_literal: false

class LazyContent::SendingForm < ::LazyContent::Base
  def initialize

  end

  def partial
    '/lazy_content/sending_form'
  end

  def js
   "enableClientSideValidations, formWithTerms, formLabelTrans"
  end

  def stylesheet
    nil
  end
end
