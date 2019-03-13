1. move setting in config/temsys/settings.yml;
mv config/templates.yml -> config/temsys/templates.yml;
UPDATE: mv data from templates.yml -> task temsys:conf:call;

2. rm settings data in application.rb;
add  in application.rb
config.temsys = YAML::load_file(Rails.root.join('config', 'temsys', 'settings.yml'));
UPDATE: dot'n need;

3. routes.rb
rm error_message;
rm send_error_message;

4. replace footer link message-to in span;
check ts_async.js loaded;

5. add .wrap css class to header, section, footer;

6. add migration
`ruby
  add_column :template_tags, :settings, :string
``

7. rm render 'admin/no_ie' from system.html.erb

8. rm gem 'magnific-popup-rails'
