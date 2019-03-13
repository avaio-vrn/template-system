# -*- encoding : utf-8 -*-
class TemplateSystem::ContentController < ApplicationController
  load_and_authorize_resource

  before_filter :set_actions, if: proc { request.format.symbol == :html && current_user&.admin_less? }

  def new
    create_block = params[:block] == '1'
    partial = "/template_system/content/new"
    if create_block
      @template = TemplateSystem::Template.new(content_id: params[:content_id])
      partial << '_block'
    else
      @template_type_categories = TemplateSystem::TemplateTypeCategory.includes(:template_types).all
      @template_types = TemplateSystem::TemplateType.order('use_count DESC').limit(9)
      @current_type = @template_types.first
    end
    respond_to do |format|
      format.html { render nothing: true, layout: nil, status: 404 }
      format.js { render partial, locals: { data_name: 't', item: @template }, layout: nil }
    end
  end

  def show
    redirect_to(root_path) unless request.format.symbol == :html

    if params[:fix_row_num]
      params_hash = { content_id: @content.id }
      row_num_record = ::Admin::RowNum::Fix.new(:template, :template_system, params_hash)
      row_num_record.auto_fix! if row_num_record.need_check?
    end
    @admin_panel.routes_set unless @admin_panel.nil?
  end

  private

  def set_actions
    @admin_panel = ::Admin::Panel::Base.new(TemplateSystem::Template)
    @admin_panel.default_namespace = 'template_system'
    @admin_panel.from(controller_name, action_name)
    @admin_panel.contentable = if @content.contentable.respond_to?(:invert_obj)
                                 @content.contentable.invert_obj
                               else
                                 @content.contentable
                               end
  end
end
