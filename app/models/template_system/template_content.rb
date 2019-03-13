# -*- encoding : utf-8 -*-
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

class TemplateSystem::TemplateContent < ActiveRecord::Base
  belongs_to :template, touch: true
  belongs_to :template_type
  belongs_to :template_tag
  has_many   :template_table_contents, dependent: :destroy

  has_one :image, class_name: Files::Image, as: :root

  attr_accessible :template_id, :template_type_id, :content_text, :template_tag_id,
    :image_attributes, :template_table_contents_attributes

  accepts_nested_attributes_for :image, allow_destroy: true
  accepts_nested_attributes_for :template_table_contents, allow_destroy: true

  def part_content_text
    YAML.load(content_text)
  end

  def get_content_header
    t = self.template
    if t
      t = t.templatable
      if t
        t = t.content_header
      end
    end
    t || ""
  end

  def raw?
    template_tag.raw?
  end

  def raw_light?
    template_tag.raw_light?
  end

  def ckeditor_config
    raw_light? ? 'raw-light' : 'raw'
  end

  def get_count_row
    template_table_contents.group_by{|e| e.row_num}.size
  end

  def get_count_column
    sz = template_table_contents.group_by{|e| e.col_num}.size
    sz == 0 ? 1 : sz
  end
end
