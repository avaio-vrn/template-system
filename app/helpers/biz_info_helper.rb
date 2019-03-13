module BizInfoHelper
  def logotype_link_content
    if @biz_info.logo.image_blank?
      name_with_tagline
    else
      image_tag(@biz_info.logo.image.file(:original)).concat(name_with_tagline)
    end
  end

  def logotype_link
    logo = image_tag(@biz_info.logo.image.file(:original), alt: 'логотип организации')
    action_name == 'home' ? content_tag(:div, logo, class: 'logo') : link_to(logo, '/', class: 'logo')
  end

  def phone_link_content
    @biz_info.phone.gsub(/^(\+?\d+{0,1}\(\d{3,4}\))/, '<span class="phone-prefix">\1</span> ').html_safe
  end

  def phone_link
    link_to "tel:#{@biz_info.phone.gsub(/(\(|\)|\s|-)/, '')}", class: "#{block_given? ? yield : 'head-phone'}" do
      content_tag(:span, phone_link_content)
    end
  end

  def email_link
    link_to content_tag(:span, @biz_info.email), "mailto:#{@biz_info.email}", class: 'head-mail'
  end

  def address
    content_tag :span, @biz_info.address, class: 'biz-address'
  end

  private

  def name_with_tagline
    content = @biz_info.name_in_logo ? content_tag(:p, @biz_info.name) : ''.html_safe
    content += content_tag(:p, @biz_info.tagline, class: 'tagline'.freeze) unless @biz_info.tagline.blank?
    content.blank? ? content : content_tag(:div, content, class: 'org_name')
  end
end
