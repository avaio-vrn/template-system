class TemplateSystemController < ActionController::Base
  protect_from_forgery

  layout proc{ |c| c.request.xhr? ? false : layout_get }

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }

    rescue_from ExceptionsErrors::AuthenticationError,
      ExceptionsErrors::LackAuthorityError, with: lambda { |exception| render_error exception.status, exception }

    rescue_from ::CanCan::AccessDenied do |exception|
      redirect_to root_url, alert: exception.to_s, status: 401
    end

    rescue_from ::ActionController::RoutingError,
      ::ActionController::UnknownController,
      ::AbstractController::ActionNotFound,
      ::ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  private

  def layout_get
    prefix =  @temsys_theme.layout_type
    prefix ||= 'extension'
    current_user&.admin_less? ? "#{prefix}/admin_#{@temsys_theme.action_sym_name}" : "#{prefix}/#{@temsys_theme.action_sym_name}"
  end

  def admin_view?
    current_user&.admin_less? && !params[:simple]
  end

  def render_error(status, exception)
    logger ||= ActiveSupport::TaggedLogging.new(Logger.new(Rails.root.join('log', 'fail2ban.log'), 10, 30*1024*1024))

    request = ActionDispatch::Request.new(env)

    msg = "%s -- %s : %s : %s %s -- %s" % [
      DateTime.now,
      request.remote_ip,
      exception.class,
      request.request_method,
      env["PATH_INFO"],
      request.filtered_parameters.inspect
    ]
    logger.error(msg)

    TsSystemMailer.error_message({ request: request, exception: exception }).deliver if(status == 500 || status == 502)

    respond_to do |format|
      format.html {
        render template: "errors/error_#{status}", status: status, locals: { exception: exception }
      }
      format.all { render nothing: true, status: status }
    end
  end
end
