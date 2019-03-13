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

class TemplateSystem::Tags::Img < TemplateSystem::TemplateContent
  #TODO rails4
  #store :content_text, accessors: [ :alt, :size, :zoom], coder: JSON

  def initialize(type_id: , tag_id: )
    image_file = if File.exist?("#{Rails.root}/app/assets/images/no_img.png")
                   open("#{Rails.root}/app/assets/images/no_img.png")
                 else
                   open("#{TemplateSystem::Engine.root}/app/assets/images/no_img.svg")
                 end
    super(
      template_type_id: type_id.to_s,
      template_tag_id:  tag_id.to_s,
      content_text: YAML.dump({ alt: I18n.t(:alt, scope: :template_system_content_text), size: 'medium', zoom: false, group: nil, caption: nil }),
      image_attributes: { file: image_file }
    )
  end

end
