# == Schema Information
#
# Table name: template_contents
#
#  id               :integer          not null, primary key
#  template_id      :integer
#  template_type_id :integer
#  template_tag_id  :integer
#  content_text     :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class TemplateSystem::Tags::A < TemplateSystem::TemplateContent
  def initialize(type_id: , tag_id: )
    super(
      template_type_id: type_id.to_s,
      template_tag_id: tag_id.to_s,
      content_text: YAML.dump({ href: '#', text: I18n.t(:lorem, scope: :template_system_content_text) })
    )
  end
end
