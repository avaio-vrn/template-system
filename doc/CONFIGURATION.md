# Configuration sections
## section main
| critical | attr_type | section_attr | value |
| --- | --- | --- | --- |
| true | string | base_title | TemSys, управление контентом |
| true | boolean | with_main | true |
| true | boolean | edit_layout | true |
| true | array | gems (dpr! mv to rails_env) | cocoon |
| true | boolean | help_client | false |

## section html
| critical | attr_type | section_attr | value |
| --- | --- | --- | --- |
| true | string | h1_class | h1 |

## section sitemap
| critical | attr_type | section_attr | value |
| --- | --- | --- | --- |
| false | array | all | page, section |
| false | array | section_nested | page_sections |

## section template_type_render
    critical: false, attr_type: 'string',  'h1_home', value: 'Заголовок h1 на главной'
    critical: false, attr_type: 'string',  'h1_page', value: 'Заголовок h1 на внутренней'
    critical: false, attr_type: 'string',  'h1_page_no_img', value: 'Заголовок h1 на внутренней(без изображения'
    critical: false, attr_type: 'string',  'sending_form', value: 'Блок формы связи'
    critical: false, attr_type: 'string',  'demo_form', value: 'Блок "Демо"'
    critical: false, attr_type: 'string',  'request_site_form', value: 'Блок "Запрос сайта"'
    critical: false, attr_type: 'string',  'h2_2img', value: 'Заголовок h2 и 2 картинки'
    critical: false, attr_type: 'string',  'h3_img_right', value: 'Заголовок h3 и картинка справа'
    critical: false, attr_type: 'string',  'h2_img_right', value: 'Заголовок h2 и картинка справа'
    critical: false, attr_type: 'string',  'h2_img_left', value: 'Картинка слева и заголовок h2'
    critical: false, attr_type: 'string',  'p_img_left', value: 'Картинка слева и текст'
    critical: false, attr_type: 'string',  'pluses_row', value: 'Строка в плюсах'

## section biz_info
    critical: true, attr_type: 'string',  'name', value: 'Template System'
    critical: true, attr_type: 'string',  'tagline', value: 'легко управлять сайтом'
    critical: true, attr_type: 'string',  'protocol', value: 'https'
    critical: true, attr_type: 'string',  'domain', value: 'temsys.ru'
    critical: true, attr_type: 'string',  'email', value: 'info@temsys.ru'
    critical: true, attr_type: 'string',  'email_for_form', value: 'info@temsys.ru'
    critical: true, attr_type: 'string',  'phone', value: '(473203-03-73'
    critical: true, attr_type: 'string',  'phone_second', value: ''
    critical: true, attr_type: 'string',  'additional_phones', value: ''
    critical: true, attr_type: 'string',  'address', value: ''
    critical: true, attr_type: 'string',  'lat', value: ''
    critical: true, attr_type: 'string',  'lgt', value: ''
    critical: true, attr_type: 'string',  'ym', value: '32322594'
    critical: true, attr_type: 'string',  'ga', value: ''

## section theme
    critical: true, attr_type: 'string',  'digest', value: '1196678016'
    critical: true, attr_type: 'string',  'color', value: '39ADC8'
    critical: true, attr_type: 'string',  'headers_font', value: 'roboto_condensed'
    critical: true, attr_type: 'string',  'content_font', value: 'open_sans'
    critical: true, attr_type: 'string',  'header', value: '96edc5'
    critical: true, attr_type: 'string',  'footer', value: '96edc5'
    critical: true, attr_type: 'boolean',  'font_awesome', value: 'true'
    critical: true, attr_type: 'string',  'layout_home', value: ''
    critical: true, attr_type: 'string',  'layout_page', value: ''
