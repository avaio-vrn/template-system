# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: templates
#
#  id               :integer          not null, primary key
#  template_type_id :integer
#  content_id       :integer
#  row_num          :integer          default(0)
#  del              :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class TemplateSystem::Template < TemplateSystem::Record::DelRowNum
  ROW_NUM_FIELDS = [:content_id].freeze

  after_create :more_template_type
  after_destroy :least_template_type, :fix_row_num

  belongs_to :content, touch: true
  belongs_to :template_type

  has_many :template_tags, through: :template_type
  has_many :template_parts, through: :template_type

  #TODO test destroy
  has_many :template_contents, dependent: :destroy
  # has_many :template_table_contents, through: :template_contents, dependent: :destroy

  default_scope includes(:template_type, [template_parts: :template_tags], [template_contents: [:template_tag, :template_type]])#, :template_table_contents)

  attr_accessible :content_id, :template_type_id, :template_contents_attributes

  accepts_nested_attributes_for :template_contents, allow_destroy: true
  # accepts_nested_attributes_for :template_table_contents, allow_destroy: true

  def self.get_next_row_num(argv)
    self.where(content_id: argv[:content_id]).group_by{|e| e.row_num}.size + 1
  end

  def have_list_or_table?
    template_contents.any? { |t_content| t_content.respond_to? :template_table_contents }
  end

  def json_for_icons_js(ability_destroy, index=nil)
    index ||= :_no_index
    json = { index =>
             { record:
               {action_path: "/template_system/templates/" + self.id.to_s,
                model: "TemplateSystem::Template",
                model_engine: "template_system",
                can_destroy: ability_destroy,
                id: id }}
    }
    json[index].merge!(json_from_template_table_contents(ability_destroy, index))
    json
  end

  def json_from_template_table_contents(ability_destroy, index)
    return {} unless have_list_or_table?
    json = { }
    template_contents.each do |t_content|
      t_content.template_table_contents.each_with_index do |v, i|
        json.merge!( "#{index}-#{i}" =>
                    { record: {
                      action_path: "/template_system/template_table_contents/" + v.id.to_s,
                      model: "TemplateSystem::TemplateTableContent",
                      model_engine: "template_system",
                      can_destroy: ability_destroy,
                      id: v.id }}
                   )
      end
    end
    json
  end

  def css_class
    css = template_type.html_class
    css.blank? ? :template : "template #{css}"
  end

  private

  def more_template_type
    self.template_type.more!
  end

  def least_template_type
    self.template_type.least!
  end

  def fix_row_num
    ::Admin::RowNum::Fix.new(:template, :template_system, { content_id: self.content_id }, { destroyed: self.row_num }).after_destroy!
  end

end
