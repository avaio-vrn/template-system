1. rm model main_info.rb with all files;
2. rm main_info.rb in config/initializers

3. add biz_info.yml in config/temsys/
  replace @main_info -> @biz_info = BizInfo.new

4. add settings_home_actions.yml in config/temsys, if needed
addional/replaced actions for settings home page;

5. ApplicationContoller < TemplateSystemController

6. if not include gem ts_layout add scss OpenSans font for use in admin panel;
stylesheet_link_tag 'https://fonts.googleapis.com/css?family=Open+Sans:400,300,600&subset=latin,cyrillic'

6.1. if include ts_layout -> add initializer temsys_health_check.rb;
add to application controller
@temsys_theme = TemplateSystemLayout::Theme.new

7. add in application.rb
config.temsys_theme = YAML::load_file(Rails.root.join('config', 'temsys', 'theme.yml'));
config.temsys_biz_info = YAML::load_file(File.open(Rails.root.join('config/temsys/biz_info.yml')))
UPDATE: don't need this 2 rows;

config.exceptions_app = self.routes

8. setting.yml
:edit_layout: true if not individual layout of site;
:gems: [:cocoon] add if use this gem && script

9. engine's routes mount move back in app routes.db
 mount AuthenticationUser::Engine => '/', as: :authentication_user_engine
 mount Seo::Engine => '/', as: :meta_tag_engine
 mount TemplateSystem::Engine => '/', as: :template_system
UPDATE: don't need;
