class HelpClient::HelpController < ActionController::Base
  class HelpCenterServerError < ::StandardError; end
  class HelpCenterNotFound < HelpCenterServerError; end

  def show
    uri = URI("#{Rails.application.config.help_center}/remote_request/tutorial")
    controller_action = begin
                          referrer_hash
                        rescue
                          referrer_hash_in_engine
                        end
    uri.query = URI.encode_www_form(params[:data].merge(base_hash).merge(controller_action))

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 700

    status = 200
    json = begin
             response = Timeout.timeout 1.5 do
               req = Net::HTTP::Get.new(uri)
               req['Content-Type'] = 'application/json'
               req['Accept'] = 'application/json'

               http.request(req)
             end
             if response.is_a? Net::HTTPServerError
               raise HelpCenterServerError
             elsif response.is_a? Net::HTTPNotFound
               raise HelpCenterNotFound
             else
               JSON.parse(response.body)
             end
           rescue HelpCenterNotFound
             status = 404
             nil
           rescue HelpCenterServerError
             status = 501
             nil
           rescue Timeout::Error
             status = 504
             nil
           rescue
             status = 503
             nil
           end

    respond_to do |format|
      format.json { render json: json, status: status }
    end
  end

  def new
    respond_to do |format|
      format.js { render js: Rails.application.assets.find_asset(params[:script_name])&.body }
    end
  end

  def destroy

  end

  private

  def base_hash
    { project_id: Rails.application.config.help_center_project,
      version_id: Rails.application.config.help_center_version }
  end

  def referrer_hash
    ref = check_routes(Rails.application)
    { controller_id: ref[:controller], action_id: ref[:action] }
  end

  def referrer_hash_in_engine
    ref = nil
    Rails::Application::Railties.engines.each do|engine|
      begin
        ref ||= check_routes(engine)
      rescue
      end
    end
    { controller_id: ref[:controller], action_id: ref[:action] }
  end

  def check_routes(engine)
    engine.routes.recognize_path(request.referrer)
  end
end
