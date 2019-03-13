# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: template_types
#
#  id                        :integer          not null, primary key
#  content_name              :string(70)       not null
#  render                    :string(70)
#  html_class                :string(255)
#  raw                       :boolean          default(FALSE)
#  del                       :boolean          not null
#  erb                       :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  template_type_category_id :integer
#  content_header            :string(70)
#  svg_content               :text
#  content_text              :text
#  use_count                 :integer
#

class TemplateSystem::TemplateType < TemplateSystem::Record::Del
  belongs_to :template_type_category, class_name: TemplateSystem::TemplateTypeCategory

  has_many :template_parts, dependent: :destroy, class_name: TemplateSystem::TemplatePart
  has_many :template_tags, dependent: :destroy, class_name: TemplateSystem::TemplateTag

  has_many :templates, class_name: TemplateSystem::Template
  has_many :template_contents, class_name: TemplateSystem::TemplateContent

  attr_accessible :html_class, :content_name, :content_header, :content_text, :template_type_category_id,
    :svg_content, :raw, :render, :use_count, :template_parts_attributes, :template_tags_attributes

  accepts_nested_attributes_for  :template_parts, allow_destroy: true
  accepts_nested_attributes_for  :template_tags, allow_destroy: true

  scope :ordering, -> {order(:template_type_category_id, :content_name)}
  validates :content_name, presence: true, uniqueness: true

  def to_s
    content_name
  end

  def self.uniq_partials_get
    Configuration.loaded_get('template_type_render', nil, relation: true)&.map{ |r| [r['section_attr'], r['value']] } || []
  end

  def more!
    self.update_attributes(use_count: (self.use_count || 0).next)
  end

  def least!
    self.update_attributes(use_count: (self.use_count || 0) - 1)
  end

end
