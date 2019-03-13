# == Schema Information
#
# Table name: template_table_contents
#
#  id                  :integer          not null, primary key
#  template_content_id :integer
#  row_num             :integer
#  col_num             :integer
#  content_text        :text
#  del                 :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class TemplateSystem::TemplateTableContent < TemplateSystem::Record::DelRowNum
  ROW_NUM_FIELDS = [:template_content_id].freeze

  belongs_to :template_content, touch: true
  has_one :template, through: :template_content
  has_one :template_type, through: :template_content

  attr_accessible :row_num, :col_num, :content_text, :template_content_id

  scope :ordering, -> {order(:row_num, :col_num)}

  def get_content_header
    t = self.template_content
    if t
      t = self.template
      if t
        t = t.templatable
        if t
          t = t.content_header
        end
      end
    end
    t || ""
  end

  private

  def fix_row_num
    ::Admin::RowNum::Fix.new(:template_table_content, :template_system, { template_content_id: self.template_content.id }, { destroyed: self.row_num }).after_destroy!
  end
end
