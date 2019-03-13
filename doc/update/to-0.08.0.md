1. rm include Concerns::Del -> add class TemplateSystem::Record::Del
rm include Concerns::RowNum -> add class TemplateSystem::Record::DelRowNum
rm include Concerns::Content -> add class TemplateSystem::Record::Base

2. add migration table image -> file

3. replace image.image.url -> image.url in codebase ( %s/image\.image\.url/image\.url/g )
image.main_image -> image.url;
fix form partial;

4. check && add if need file
<%= render 'image_fields', f:i %>

5. rm from config/application.rb && files in config/temsys
config.temsys
config.biz_info
config.temsys_theme

6. add config/panel_actions.yml for configuration actions !! if needs !!

7. mv controller admin_panel actions to yml files;

8. !!! change implementation !!!

Admin::Panel.new(model=nil, action=nil, opt={}) -> Admin::Panel.new(model=nil, opt={})

model_module -> model_engine in admin actions

!!!!

9. in Admin::Panel default_namespace = 'admin' -> rm code in controllers;

10. mv code ApplicationController -> TemplateSystemController
rm code from ApplicationController;

11. rename mount engines in routes.rb;

12. production: RAILS_ENV=production RBENV_VERSION=2.3.0 rbenv exec bundle exec rake temsys:conf:call
