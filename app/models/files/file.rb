class Files::File < TemplateSystem::Record::DelRowNum
  before_validation :normalize_file_name

  belongs_to :root, polymorphic: true

  attr_accessible :root_id, :root_type, :file

  private

  def normalize_file_name
    return nil if file.instance_read(:file_name).blank?
    require 'russian'
    self.file.instance_write(:file_name, ::Russian::transliterate(file.instance_read(:file_name)).downcase.gsub(/[^0-9A-Za-z\.]/, '_').gsub(/^_|__|_$/, ''))
  end
end
