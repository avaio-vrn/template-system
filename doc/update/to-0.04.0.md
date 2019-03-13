Image.where(imageable_type: 'TemplateContent').each {|a| a.update_attributes(imageable_type: 'TemplateSystem::TemplateContent')}
