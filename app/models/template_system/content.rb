# == Schema Information
#
# Table name: contents
#
#  id               :integer          not null, primary key
#  contentable_type :string(255)
#  contentable_id   :integer
#  restrict_edit    :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class TemplateSystem::Content < ActiveRecord::Base
  ENGINE_NAME = :template_system
  ROW_NUM_FIELDS = [:contentable_type, :contentable_id].freeze

  belongs_to :contentable, polymorphic: true, touch: true
  #TODO testing destroy
  has_many :templates, class_name: TemplateSystem::Template#, dependent: :destroy

  attr_accessible :contentable_type, :contentable_id, :restrict_edit

end
