# -*- encoding : utf-8 -*-
class TemplateSystem::TemplateTableContentsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_admin_panel, if: proc { current_user&.admin_less? }

  def new
    template_content = TemplateSystem::TemplateContent.find(params[:tc_id])
    template = template_content.template

    if template_content.template_tag.name != :table.to_s
      row_num_record = ::Admin::RowNum::Fix.new(:template_table_content, :template_system, template_content_id: params[:tc_id])
      row_num_record.auto_fix! if row_num_record.need_check?
    end

    count_row = template_content.get_count_row
    count_col = template_content.get_count_column
    template_table_content = (1..count_col).inject(template_content.template_table_contents) do |table_contents, col|
      table_contents  << TemplateSystem::TemplateTableContent.create(
        { row_num: (count_row + 1), col_num: col, content_text: I18n.t(:edit, scope: :template_system_content_text), del: !template.del }
      )
    end
    respond_to do |format|
      format.js { render "/template_system/templates/ajax/finish_edit_table_content",
                  locals: { template: template, item: template_table_content }, layout: nil
      }
    end
  end

  def new_column
    template_content = TemplateSystem::TemplateContent.find(params[:tc_id])
    @template = template_content.template
    count_row = template_content.get_count_row
    count_col = template_content.get_count_column
    template_table_content = (1..count_row).inject(template_content.template_table_contents){ |table_contents, row|
      table_contents  << TemplateSystem::TemplateTableContent.create({ 'row_num' => row, 'col_num' => count_col + 1, 'content_text' => I18n.t(:edit, scope: :template_system_content_text) })
    }
    respond_to do |format|
      format.js {render "/template_system/templates/ajax/finish_edit_table_content", locals: {template: @template, item: template_table_content}, layout: nil }
    end
  end

  def new_block
    template = TemplateSystem::TemplateContent.find(params[:tc_id]).template
    respond_to do |format|
      format.js { render "/template_system/templates/ajax/new_block_table", locals: { data_name: 't', item: template }, layout: nil }
    end
  end

  def create_block
    template_content = TemplateSystem::TemplateContent.find(params[:tc_id])
    count_row = template_content.get_count_row
    lines = params[:text].lines.delete_if {|a| a.strip.blank?}
    template_collection = []
    del_parent = template_content.template.del
    lines.each_with_index do |elem, index|
      template_collection << TemplateSystem::TemplateTableContent.create({row_num: count_row + index + 1, col_num: 1, content_text: elem, del: !del_parent })
    end
    template_content.template_table_contents << template_collection

    respond_to do |format|
      format.js { render "/template_system/templates/ajax/create_collection_block", locals: {data_name_parent: 'tc', data_name: 'ttc', template_collection: template_collection}}
    end
  end

  def destroy
    @template_table_row = TemplateSystem::TemplateTableContent.find(params[:id])
    @template_table_row.destroy

    @templates = [ @template_table_row.template_content]
    respond_to do |format|
      format.json { render json: @template_table_row }
      #TODO !depr
      format.js { render "/template_system/templates/ajax/destroy_table_row", locals: {data_name: 'tc', id: @template_table_row.template_content.id}, layout: nil}
    end
  end

  def edit
    @template_table = TemplateSystem::TemplateTableContent.find(params[:target_id])
    respond_to do |format|
      format.js { render "/template_system/templates/ajax/edit_content", locals: {data_name: params[:data_name]||'ttc',
                                                                                  item: @template_table, content: @template_table.template_content}, layout: nil}
    end
  end

  def update
    upload_image = params.delete(:image)
    params[:values] = params[:raw].delete(:values) if params[:raw]
    params[:values] = [params[:values], params[:href_big_image]] if params[:href_big_image]
    @template_table = TemplateSystem::TemplateTableContent.find(params[:target_id])
    respond_to do |format|
      if @template_table.update_attributes(content_text: Array(params[:values]).join('<!#>'));
        if upload_image.nil?
          format.js { render "/template_system/templates/ajax/finish_edit_table_content", locals: {data_name: 't',
                                                                                                   template: @template_table.template_content.template, item: @template_table.template_content.template_table_contents}, layout: nil}
        elsif @template_table.update_attributes(image_attributes: upload_image)
          format.js { render "/template_system/templates/ajax/finish_edit_table_content", locals: {data_name: 't',
                                                                                                   template: @template_table.template_content.template, item: @template_table.template_content.template_table_contents}, layout: nil}
        else
          format.js { render text: "alert(Ошибка при сохранении! Что-то пошло не так.);"}
        end
      else
        format.js { render text: "alert(Ошибка при сохранении! Что-то пошло не так.);"}
      end
    end
  end

  def show
    @template_table = TemplateSystem::TemplateTableContent.find(params[:target_id])
    respond_to do |format|
      format.js { render "/template_system/templates/ajax/finish_edit_table_content", locals: {data_name: 't', template: @template_table.template_content.template,
                                                                                               item: @template_table.template_content.template_table_contents}, layout: nil}
    end
  end

  private

  def set_admin_panel
    @admin_panel = ::Admin::Panel::Base.new(TemplateSystem::Template)
    @admin_panel.routes_set
  end

end
