class TsSystemMailer < ActionMailer::Base
  def self.from(biz_info)
    %("#{biz_info.name}" <#{biz_info.domain_ascii}@#{ActionMailer::Base.smtp_settings[:address] || 'mail.am-gr.ru'}>)
  end

  def error_message(params)
    biz_info = BizInfo.new
    @send_data = params || {}
    mail(from: TsSystemMailer.from(biz_info), to: 'bugs@temsys.ru', subject: "[#{biz_info.domain}] Ошибка приложения")
  end
end
