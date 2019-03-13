#encoding: utf-8
require 'rake'
lib_dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
Dir.glob("#{lib_dir}/install_template_types/*.rb").map do |file|
  require file unless file.include? "tasks.rb"
end

namespace :ts_configuration do

  task :require_environment do
    if defined?(Rails)
      Rake::Task['environment'].invoke
    end
  end

  desc "Fill configuration's values"
  task fill: ['ts_configuration:require_environment'] do


    puts "=============== Fill configuration ====================="

    Configuration.create!(critical: true, attr_type: 'string', section: 'main', section_attr: 'base_title', value: 'TemSys, управление контентом')
    Configuration.create!(critical: true, attr_type: 'string', section: 'html', section_attr: 'h1_class', value: 'h1')
    Configuration.create!(critical: false, attr_type: 'boolean', section: 'main', section_attr: 'with_main', value: 'true')
    Configuration.create!(critical: false, attr_type: 'boolean', section: 'main', section_attr: 'edit_layout', value: 'true')
    Configuration.create!(critical: false, attr_type: 'array', section: 'main', section_attr: 'gems', value: 'cocoon')
    Configuration.create!(critical: false, attr_type: 'boolean', section: 'main', section_attr: 'help_client', value: 'false')

    Configuration.create!(critical: false, attr_type: 'array', section: 'sitemap', section_attr: 'all', value: 'page, section')
    Configuration.create!(critical: false, attr_type: 'array', section: 'sitemap', section_attr: 'section_nested', value: 'page_sections')

    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'h1_home', value: 'Заголовок h1 на главной')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'h1_page', value: 'Заголовок h1 на внутренней')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'h1_page_no_img', value: 'Заголовок h1 на внутренней(без изображения)')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'sending_form', value: 'Блок формы связи')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'demo_form', value: 'Блок "Демо"')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'request_site_form', value: 'Блок "Запрос сайта"')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'h2_2img', value: 'Заголовок h2 и 2 картинки')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'h3_img_right', value: 'Заголовок h3 и картинка справа')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'h2_img_right', value: 'Заголовок h2 и картинка справа')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'h2_img_left', value: 'Картинка слева и заголовок h2')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'p_img_left', value: 'Картинка слева и текст')
    Configuration.create!(critical: false, attr_type: 'string', section: 'template_type_render', section_attr: 'pluses_row', value: 'Строка в плюсах')

    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'name', value: 'Template System')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'tagline', value: 'легко управлять сайтом')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'protocol', value: 'https')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'domain', value: 'temsys.ru')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'email', value: 'info@temsys.ru')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'email_for_form', value: 'info@temsys.ru')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'phone', value: '(473)203-03-73')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'phone_second', value: '')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'additional_phones', value: '')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'address', value: '')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'lat', value: '')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'lgt', value: '')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'ym', value: '32322594')
    Configuration.create!(critical: true, attr_type: 'string', section: 'biz_info', section_attr: 'ga', value: '')

    Configuration.create!(critical: true, attr_type: 'string', section: 'theme', section_attr: 'digest', value: '1196678016')
    Configuration.create!(critical: true, attr_type: 'string', section: 'theme', section_attr: 'color', value: '39ADC8')
    Configuration.create!(critical: true, attr_type: 'string', section: 'theme', section_attr: 'headers_font', value: 'roboto_condensed')
    Configuration.create!(critical: true, attr_type: 'string', section: 'theme', section_attr: 'content_font', value: 'open_sans')
    Configuration.create!(critical: true, attr_type: 'string', section: 'theme', section_attr: 'header', value: '96edc5')
    Configuration.create!(critical: true, attr_type: 'string', section: 'theme', section_attr: 'footer', value: '96edc5')
    Configuration.create!(critical: true, attr_type: 'boolean', section: 'theme', section_attr: 'font_awesome', value: 'true')
    Configuration.create!(critical: true, attr_type: 'string', section: 'theme', section_attr: 'layout_home', value: '')
    Configuration.create!(critical: true, attr_type: 'string', section: 'theme', section_attr: 'layout_page', value: '')

    puts "=============== Fill configuration ====================="
  end
end
