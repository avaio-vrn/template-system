# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: template_tags
#
#  id               :integer          not null, primary key
#  html_class       :string(70)
#  row_num          :integer
#  template_type_id :integer
#  name             :string(255)
#  del              :boolean          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  settings         :string(255)
#

class TemplateSystem::TemplateTag < TemplateSystem::Record::DelRowNum
  ROW_NUM_FIELDS = [:template_type_id].freeze

  belongs_to :template_type

  has_many :template_contents
  has_many :templates, through: :template_contents, dependent: :destroy

  has_many :template_parts_tags
  has_many :template_parts, through: :template_parts_tags

  attr_accessible :name, :template_type_id, :html_class, :settings

  validates_length_of :html_class, maximum: 70, allow_blank: true

  def self.available_tags
    [:p, :h2, :h3, :h4, :h5, :h6, :ul, :ol, :table, :img, :a, :div, :span, :i, :hr]
  end

  def get_partial
    case name.to_sym
    when :h1, :h2, :h3, :h4, :h5, :h6, :ul, :ol, :table, :i, :hr
      :simple
    when :img
      :image
    when :a
      :href
    when :p, :div, :span
      raw? ? :raw : :simple
    else
      :alert
    end
  end

  def simple_tag?
    [:hr].include? name.to_sym
  end

  def no_content?
    (settings || '').split.include? 'nocontent'.freeze
  end

  def raw?
    (settings || '').split.include? 'raw'.freeze
  end

  def raw_light?
    (settings || '').split.include? 'raw-light'.freeze
  end
end
