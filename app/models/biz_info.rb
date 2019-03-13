class BizInfo
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  WHITELIST = [:name, :name_in_logo, :tagline, :protocol, :domain, :subdomain, :phone, :phone_second, :additional_phones, :address,
               :lat, :lgt, :email, :email_for_form, :ym, :ym2, :ga, :sms_phone, :sms_type, :sms_timezone, :sms_start_send, :sms_stop_send]

  def initialize
    @info = Configuration.loaded_get('biz_info'.freeze).inject({}) { |m, r| m.merge(r['section_attr'] => r['value']) }
    self
  end

  def protocol; @info['protocol'] || 'http'; end


  def domain; @info['domain'] end

  def subdomain; @info['subdomain']; end

  def host
    subdomain.blank? ? domain : "#{subdomain}.#{domain}"
  end

  def host_with_protocol
    "#{protocol}://#{host}"
  end

  def domain_ascii
    domain_ascii_set
  end

  def name
    @info['name']
  end
  alias_method :org_name, :name

  def name_in_logo
    @info['name_in_logo']
  end

  def tagline; @info['tagline']; end

  def phone; @info['phone']; end

  def phone_second; @info['phone_second']; end

  def additional_phones
    @info['additional_phones'] || ''
  end

  def address; @info['address']; end

  def lat; @info['lat']; end

  def lgt; @info['lgt']; end

  def email; @info['email']; end

  def email_for_form
    @info['email_for_form'].blank? ? 'bugs@temsys.ru' : @info['email_for_form']
  end

  def ym; @info['ym']; end
  def ym2; @info['ym2']; end
  def ga; @info['ga']; end

  def sms_phone; @info['sms_phone']; end
  def sms_type; @info['sms_type']; end
  def sms_time; @info['sms_timezone']; end
  def sms_start_send; @info['sms_start_send']; end
  def sms_stop_send; @info['sms_stop_send']; end

  def logo
    Logo.new
  end

  def id
    domain
  end

  def persisted?
    !(self.id.nil?)
  end

  def update_attributes(attributes)
    return false if attributes.blank?

    attributes.each do |k, v|
        args = { section: 'biz_info', section_attr: k }
        record = Configuration.where(args).first
        if record.blank?
          Configuration.create(args.merge(value: v, critical: false, attr_type: Configuration.get_type_of(v)))
        else
          record.update_attributes(args.merge(value: v))
        end
    end
    @info = Configuration.loaded_get('biz_info'.freeze, nil, { force: true }).inject({}) { |m, r| m.merge(r['section_attr'] => r['value']) }
    true
  end

  private

  def domain_ascii_set
    require 'simpleidn'

    @domain_ascii = if subdomain.blank?
                      SimpleIDN.to_ascii(domain)
                    else
                      "#{subdomain}.#{SimpleIDN.to_ascii(domain)}"
                    end
  end

  def check_attributes(attributes)
    attributes.symbolize_keys.keep_if { |key, _value| WHITELIST.include? key }
  end

  class Logo
    def initialize
      @image = Files::Image.where(root_type: 'BizInfoLogo', root_id: 0).first
      @image = Files::Image.new(root_type: 'BizInfoLogo', root_id: 0) if @image.blank?
    end

    def image
      @image
    end

    def image_blank?
      @image.id.nil?
    end

    def update_attributes(attributes)
      unless attributes.nil?
        self.image.file = attributes
        self.image.save!
      end
    end
  end
end
