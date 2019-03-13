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
class TemplateSystem::Tags::Ul < TemplateSystem::TemplateContent
  def initialize(type_id: , tag_id: )
    super(
      template_type_id: type_id.to_s,
      template_tag_id:  tag_id.to_s,
      template_table_contents_attributes: {
        "1" => {'row_num' => 1, 'col_num' => 1, 'content_text' => I18n.t(:edit, scope: :template_system_content_text) },
        "2" => {'row_num' => 2, 'col_num' => 1, 'content_text' => I18n.t(:edit, scope: :template_system_content_text) }
      }
    )
  end
end
