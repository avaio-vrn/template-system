class Senders::Sms
  def initialize(text, datetime=nil, phone_number=nil, type=nil)
    @uri = URI("http://api.myatompark.com/sms/3.0/sendSMS")
    @public_key = 'bb59e8f116521cb14d81d692725e0295'
    private_key = '1e01afbe72868d0cb2b40f580e03c086'
    @send_params = {
      action: 'sendSMS',
      asender: 'temsys',
      datetime: datetime || send_datetime_get,
      key: @public_key,
      phone: phone_number || phone_number_get,
      sender: 'temsys',
      sms_lifetime: '1',
      text: text,
      type: type || '2',
      version: '3.0'
    }
    @sum = Digest::MD5.hexdigest(@send_params.inject(''){ |m, (_k, v)| m << v } << private_key)
    @send_params.except!(:key, :action, :version)
  end

  def send
    @uri.query = URI.encode_www_form({key: @public_key, sum: @sum}.merge(@send_params))

    http = Net::HTTP.new(@uri.host, @uri.port)
    http.read_timeout = 700

    status = 200
    json = begin
             response = Timeout.timeout 1.5 do
               req = Net::HTTP::Get.new(@uri)
               req['Content-Type'] = 'application/json'
               req['Accept'] = 'application/json'

               http.request(req)
             end
             if response.is_a? Net::HTTPServerError
               status = 501
               nil
             elsif response.is_a? Net::HTTPNotFound
               status = 404
               nil
             else
               JSON.parse(response.body)
             end
           rescue Timeout::Error
             status = 504
             nil
           rescue
             status = 503
             nil
           end
  end

  private

  def phone_number_get
    Configuration.loaded_get('biz_info', 'sms_phone').to_s
  end

  def send_datetime_get
    if (8..19).include? DateTime.now.in_time_zone('Moscow').hour
      ''
    else
      now = DateTime.now.in_time_zone('Moscow')
      now = now.tomorrow unless now.hour < 8
      now.change(hour: 9, minute: 0, seconds: 0).strftime('%Y-%m-%d %H:%M:%S')
    end
  end
end
