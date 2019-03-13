# == Schema Information
#
# Table name: template_parts_tags
#
#  id               :integer          not null, primary key
#  template_part_id :integer
#  template_tag_id  :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class TemplateSystem::TemplatePartsTag < ActiveRecord::Base

  belongs_to :template_tag
  belongs_to  :template_part

  attr_accessible :template_part_id, :template_tag_id
end
