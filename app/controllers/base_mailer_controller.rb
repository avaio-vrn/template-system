class BaseMailerController < ActionController::Base
  layout nil

  def error_message
    respond_to do |format|
      format.html { render text: '', status: 405 }
      format.js { render "application/error_message/error_message" }
    end
  end

  def send_error_message
    BaseMailer.error_message(params).deliver
    respond_to do |format|
      format.html { render text: '', status: 405 }
      format.js { render "application/error_message/send_error_message" }
    end
  end

  def question_form
    @form_partial = params[:form].blank? ? 'application/question_message/form' : 'extension/question_form/' + params[:form]
    respond_to do |format|
      format.html { render text: '', status: 405 }
      format.js { render 'application/question_message/question_message' }
    end
  end

  def send_question_form
    @error = 1 unless request.format == :js
    unless @error
      begin
        send_email_recipients.each do |to|
          BaseMailer.send_question(params, { to: to }).deliver
        end
      rescue
        @error = 1
      end
    end
    @which_form = if params[:js__form]
                    "$('.magnific-form')".html_safe
                  else
                    "$('.template-form').closest('.template')".html_safe
                  end
    unless @error
      Admin::TemplateSystem::PersistentData.create!(data_type: 'BaseMailer', content_text: params[:contact_form])

      if Rails.env.production? && !config_get('biz_info', 'sms_phone').blank?
        Senders::Sms.new("С сайта #{config_get('biz_info', 'domain')} отправили сообщение.").send
      end

      begin
        recipient_email = BaseMailer.send_question(params, recepient: true)
        recipient_email.deliver unless recipient_email.nil?
      rescue
      end
    end

    respond_to do |format|
      format.html { render text: '', status: 405 }
      format.js { render 'application/question_message/send_question_message' }
    end
  end

  private

  def send_email_recipients
    email_line = BizInfo.new.email_for_form
    if email_line.nil?
      []
    else
      email_line.split(/[,\s]/).reject{ |e| e.blank? }
    end
  end

  def config_get(*argv)
    ::Configuration.loaded_get(argv[0], argv[1])
  end
end
