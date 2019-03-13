class Admin::TemplateSystem::PersistentData < ActiveRecord::Base
  set_table_name 'admin_template_system_persistent_data'

  attr_accessible :data_type, :content_text

  scope :ordering, -> { order('created_at DESC') }

  def to_s
    "#{I18n.l(created_at, format: '%d/%m/%Y')} #{data_type} #{content_text.truncate(100)}"
  end
end
