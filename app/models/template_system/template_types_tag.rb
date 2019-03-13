# == Schema Information
#
# Table name: template_types_tags
#
#  id               :integer          not null, primary key
#  template_type_id :integer
#  template_tag_id  :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class TemplateSystem::TemplateTypesTag < ActiveRecord::Base

  belongs_to :template_type
  belongs_to :template_tag

  attr_accessible :template_tag_id, :template_type_id
end
