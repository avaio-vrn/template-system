#encoding: utf-8
require 'rake'

namespace :migrate_to_0_7_0 do

  task :require_environment do
    if defined?(Rails)
      Rake::Task['environment'].invoke

      class PageContent < ActiveRecord::Base
        attr_accessible :content_header, :content_name, :contentable_type, :contentable_id,
          :id_str, :del, :row_num
      end

    end
  end

  desc 'copy data from lagacy "page content" model to "page" model and fill data in model "content"'
  task start: ['migrate_to_0_7_0:require_environment'] do
    PageContent.all.each do |old_page|
      @current = old_page

      if @current.contentable_type.blank? || [0, '', nil].include?(@current.contentable_id)
        puts "----------Page-------\n#{old_page.inspect}\n---------------------\n"
        new_page = Page.create!(extract_for_page)
        create_content_and_update_templates('Page', new_page.id, new_page)
      elsif @current.id_str == 'main_index_page'
        puts "----------Page-------\n#{@current.contentable_type}\n---------------------\n"
        create_content_and_update_templates(@current.contentable_type, @current.contentable_id)
      else
        puts "----------PageSection-------\n#{old_page.inspect}\n---------------------\n"
        new_page = PageSection.create!(extract_for_page.merge(section_id: @current.contentable_id))
        create_content_and_update_templates('PageSection', new_page.id, new_page)
      end
    end
  end

  private

  def extract_for_page
    { content_name: check_content_name, content_header: @current.content_header, id_str: fix_home_page_id_str,
      del: @current.del, row_num: @current.row_num }
  end

  def check_content_name
    Page.where(content_name: @current.content_name).blank? ? @current.content_name : "#{@current.content_name}-#{@current.id}"
  end

  def create_content_and_update_templates(type, id, new_page=nil)
    content = if new_page
                new_page.content
              else
                TemplateSystem::Content.create!(contentable_type: type, contentable_id: id)
              end
    TemplateSystem::Template.where(templatable_type: 'PageContent', templatable_id: @current.id)
      .update_all(templatable_type: '', templatable_id: 0, content_id: content.id)
  end

  def fix_home_page_id_str
    @current.id_str == 'welcome' ? 'home_index_page' : @current.id_str
  end
end
