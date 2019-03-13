rm initialzers/page.rb

add to application.rb
config.with_main = true


rsync -av public/images/add/ public/images/library/
rake migrate_to_0622:start

TemplateSystem::TemplateContent.where('content_text LIKE "%images/add%"').each do |content|
  new_c_text = content.content_text.sub(/images\/add/, 'images/library').sub(/\/(big|original|medium|thumb)\//, '/\1_')
  content.update_attributes(content_text: new_c_text)
end


in robots.txt
Disallow: /images/add*
