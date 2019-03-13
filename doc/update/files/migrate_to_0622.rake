#encoding: utf-8
require 'rake'

namespace :migrate_to_0622 do
  task :require_environment do
    if defined?(Rails)
      Rake::Task['environment'].invoke
    end
  end

  desc "mv image files in new format library directory"
  task start: ['migrate_to_0622:require_environment'] do
    Dir.glob(File.join('public/images/library/*')).each do |dir|
      new_dir = dir.clone
      puts dir
      begin
        obj = Image.find(dir.scan(/\d*\z/).first)
      rescue
        puts "error"
      end
      unless obj.blank?
        subdir = if obj.imageable_type == 'Tovar'.freeze
                   "/sc_#{obj.imageable.section_id}".freeze if obj.imageable
                 elsif obj.imageable_type == 'TovarModel'.freeze
                   if obj.imageable && obj.imageable.tovar
                     "/sc_#{obj.imageable.tovar.section_id}".freeze
                   end
                 end
        new_dir.sub!(/library/, "library" + subdir) if subdir
      end
      ['original', 'big', 'medium', 'thumb'].each do |format|
        Dir.glob(File.join(dir + "/#{format}/*")).map do |file|
          next if file.nil?
          filename = File.basename file
          FileUtils.mkdir_p new_dir unless Dir.exist?(new_dir)
          File.rename dir + "/#{format}/" + filename, new_dir + "/#{format}_#{filename}"
        end
        Dir.delete dir + '/' + format if Dir.exist?([dir, format].join('/'))
      end
      Dir.rmdir(dir) if Dir.glob(dir + '/*').blank?
    end

    TemplateSystem::TemplateContent.where('content_text LIKE "%images/add%"').each do |content|
      new_c_text = content.content_text.sub(/images\/add/, 'images/library').sub(/\/(big|original|medium|thumb)\//, '/\1_')
      content.update_attributes(content_text: new_c_text)
    end
  end
end
