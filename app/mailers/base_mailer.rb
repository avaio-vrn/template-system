class BaseMailer < ActionMailer::Base
  def send_question(params, opt={})
    @data = params[:contact_form]
    biz_info_and_send_data_set

    if !opt[:recepient].nil?
      if !@to.nil? && @to.match(/\A([^@\s[\/\\]]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
        mail(charset: "utf-8", from: from, to: @to, subject: "[#{@biz_info.domain}] Задали вопрос")
      else
        nil
      end
    end
    if opt[:recepient].nil?
      mail(charset: "utf-8", from: from, to: @biz_info.email_for_form, subject: "[#{@biz_info.domain}] Задали вопрос")
    end
  end

  private

  def biz_info_and_send_data_set
    @biz_info = BizInfo.new
    @send_data = @data || {}
    @to = @send_data[:contacts]
  end

  def from
    TsSystemMailer.from(@biz_info)
  end
end
