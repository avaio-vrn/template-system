1. add migration for models page, content
!!!WARN migration drop exists pages table WARN!!!

2. add model, controller, views for page like page_content

3. add resources :page to main_app routes

4. rm mailgun_smtp
add smtp_mailserver on production server;

5. fix before_filter: check_row_num
add if: proc

6. flash_message -> view_context.h_flash_msg
flash_text -> view_context.h_flash_msg
view_context.h_flash_msg(:create) || view_context.h_flash_msg(:successe) --- action without last symbol `d`

7. admin_panel.raw_action(:edit_content) -> @admin_panel.add_edit_content_action

8. rm before_filter get_page

9. add for show admin_index code like
```
@list_pages = Admin::ListPages.new do |l|
l.controller_name = controller_name
l.action_name = action_name
l.list = @pages.ordering
end
```
10. add locales for page;

11. rm variable @template

12. rm without_main impementation

13. production: RAILS_ENV=production RBENV_VERSION=2.3.0 rbenv exec bundle exec rake migrate_to_0_7_0:start
