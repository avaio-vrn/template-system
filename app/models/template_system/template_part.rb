# == Schema Information
#
# Table name: template_parts
#
#  id               :integer          not null, primary key
#  del              :boolean
#  row_num          :integer
#  content_name     :string(255)
#  html_class       :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  template_type_id :integer
#

class TemplateSystem::TemplatePart < TemplateSystem::Record::DelRowNum
  ROW_NUM_FIELDS = [:template_type_id].freeze

  belongs_to :template_type
  has_many :template_parts_tags
  has_many :template_tags, through: :template_parts_tags

  # has_many :template_parts_contents
  has_many :template_contents, through: :template_type

  attr_accessible :html_class, :content_name, :template_type_id,
    :template_tags_attributes

  accepts_nested_attributes_for :template_tags, allow_destroy: true

  default_scope -> { order(:row_num, :id) }

  # def template_content
  #
  # end
  #
  def template_contents_get(template_id)
    template_contents.where(template_tag_id: self.template_tags, template_id: template_id).order(:template_tag_id)
  end
end
