class TemplateSystem::Record::Base < TemplateSystem::Record::DelRowNum
  self.abstract_class = true

  include TemplateSystem::Record::Content

  before_create :create_content_association
  after_initialize :default_values
  before_save :translit_id

  has_one :content, as: :contentable, class_name: TemplateSystem::Content, dependent: :destroy
  has_many :templates,  through: :content
  has_one :image, class_name: Files::Image, as: :root
  has_one :restrict, class_name: ::Restrict, as: :root

  attr_accessible :id_str, :force_id_str, :auto_force_id_str, :manual_force_id_str, :image_attributes
  attr_accessor :force_id_str, :auto_force_id_str, :manual_force_id_str
  accepts_nested_attributes_for :image, allow_destroy: true

  validates_presence_of :content_name

  validates :force_id_str, format_id_str: true
  validates :force_id_str, presence_force_id_str: true

  def self.find(input)
    (input.is_a?(Integer) || input =~ /\A\d+\z/) ? super : where(id_str: input).first
  end
end
