class Files::Upload
  attr_reader :filename

  def initialize(args)
    @file = args[:file]
    @filename = filename_get(args[:filename])
    @dir = directory_get(args[:directory])
  end

  def save
    begin
      File.open(file_fullpath, "wb") { |f| f.write(@file.read) }
    rescue
      nil
    end
  end

  private

  def file_fullpath
    File.join(@dir, @filename)
  end

  def directory_get(dir)
    dir = dir[1..-1] if(dir && dir[0] == '/')
    dir_set = dir.blank? ? Rails.application.root.join('public/library/files') : Rails.application.root.join(dir)
    FileUtils.mkdir_p(dir_set) unless Dir.exist?(dir_set)
    dir_set
  end

  def filename_get(f_set)
    if f_set
      require 'russian'
      f_set = ::Russian::transliterate(f_set).downcase.gsub(/[^0-9A-Za-z\.]/, '_').gsub(/^_|__|_$/, '')
      if f_set =~ /.(jpe?g|png|gif)\z/
        f_set
      else
        f_set + File.extname(@file.original_filename)
      end
    else
      @file
    end
  end
end
