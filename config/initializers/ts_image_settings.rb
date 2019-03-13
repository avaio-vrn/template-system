if ActiveRecord::Base.connection.table_exists? 'configuration'
  Files::Image.settings_set('convert_styles',  ::Configuration.loaded_get('image_settings'.freeze, 'convert_styles'))
  Files::Image.settings_set('convert_options',  ::Configuration.loaded_get('image_settings'.freeze, 'convert_options'))
  Files::Image.settings_set('thumb_image',  ::Configuration.loaded_get('image_settings'.freeze, 'thumb_image'))
  Files::Image.settings_set('medium_image',  ::Configuration.loaded_get('image_settings'.freeze, 'medium_image'))
  Files::Image.settings_set('big_image',  ::Configuration.loaded_get('image_settings'.freeze, 'big_image'))
end
