# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: template_type_categories
#
#  id           :integer          not null, primary key
#  content_name :string(70)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class TemplateSystem::TemplateTypeCategory < ActiveRecord::Base
  has_many :template_types, class_name: TemplateSystem::TemplateType

  attr_accessible :content_name, :sys_name, :template_types_attributes

  accepts_nested_attributes_for  :template_types, allow_destroy: true

  def to_s
    content_name
  end
end
