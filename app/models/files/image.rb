class Files::Image < Files::File
  ACCEPTED = ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/svg+xml"]
  MIME_TYPES = ".jpg, .jpeg, .png, .gif, .svg"

  @@settings = {}

  has_attached_file :file,
    styles: lambda { |instance| c_styles(instance.instance.file_content_type) },
    convert_options: lambda { |instance| c_options[instance] },
    processors: lambda { |instance| instance.svg? ? [] : ['thumbnail'.to_sym] },
    url: "/images/library/:id/:style_:filename",
    path: ":rails_root/public/images/library/:id/:style_:filename",
    default_url: "/assets/no_img.svg"
  validates_attachment_content_type :file, content_type: ACCEPTED
  validates_attachment_file_name :file, matches: [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg/i]
  validates_attachment_size :file, less_than: 10.megabytes


  def self.settings_set(key, value)
    @@settings.merge!(key => value)
  end

  def url(option='thumb'.to_sym)
    if self.nil?
      "/assets/no_img.svg".freeze
    else
      svg? ? file.url('original') : file.url(option)
    end
  end

  def svg?
    self.file_content_type === 'image/svg+xml'
  end

  private

  def self.c_styles(c_type)
    case c_type
    when "image/jpg", "image/jpeg", "image/png", "image/gif"
      exists_configuration('convert_styles') || default_c_styles
    when 'image/svg+xml'
      {}
    end
  end

  def self.c_options
    exists_configuration('convert_options') || default_c_options
  end

  def self.thumb_size
    exists_configuration('thumb_image'.freeze) || '180x180'
  end

  def self.medium_size
    exists_configuration('medium_image'.freeze) || '500x500>'
  end

  def self.big_size
    exists_configuration('big_image'.freeze) || '800x600>'
  end

  def self.exists_configuration(needs_config)
    @@settings.dig(needs_config)
  end

  def self.default_c_styles
    {
      thumb: [ thumb_size, :jpg],
      medium: [medium_size, :jpg],
      big: [ big_size, :jpg]
    }
  end

  def self.default_c_options
    {
      thumb: "-sampling-factor 4:2:0 -strip -background white -gravity center -extent #{thumb_size}",
      medium: "-sampling-factor 4:2:0 -strip -quality 85 -strip -background white -flatten +matte -interlace Plane",
      big: "-sampling-factor 4:2:0 -strip -quality 90 -background white -flatten +matte -interlace Plane"
    }
  end
end
