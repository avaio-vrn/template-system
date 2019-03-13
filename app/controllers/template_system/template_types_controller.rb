# -*- encoding : utf-8 -*-
class TemplateSystem::TemplateTypesController < ApplicationController
  load_and_authorize_resource
  before_filter :set_actions, if: proc { request.format.symbol == :html && current_user&.admin_less?}

  def index
    @template_type_categories = TemplateSystem::TemplateTypeCategory.order(:id)
    @list_pages = Admin::ListPages.new do |l|
      l.controller_name = controller_name
      l.action_name = action_name
      l.list = @template_types.ordering
    end
  end

  def new
    @template_type = TemplateSystem::TemplateType.new
    render "new_edit"
  end

  def edit
    render "new_edit"
  end

  def create
    @template_type = TemplateSystem::TemplateType.new(params[:template_system_template_type])

    respond_to do |format|
      if @template_type.save
        format.html { redirect_to template_system.template_system_template_types_url, notice: 'template_type was successfully created.' }
      else
        format.html { render action: "new", template: "new_edit" }
      end
    end
  end

  def update
    respond_to do |format|
      if @template_type.update_attributes(params[:template_system_template_type])
        format.html { redirect_to template_system.template_system_template_types_url, notice: 'template_type was successfully updated.' }
      else
        format.html { render action: "edit", template: "new_edit" }
      end
    end
  end

  def destroy
    @template_type.destroy

    @templates = []
    respond_to do |format|
      #TODO !depr
      # format.js { render "/template_system/templates/ajax/destroy", locals: {data_name: 'tt', id: @template_type.id}, layout: nil}
      format.html { redirect_to template_system.template_system_template_types_url }
      format.json { render json: @template_type }
    end
  end

  private

  def set_actions
    @admin_panel = ::Admin::Panel::Base.new(TemplateSystem::TemplateType, { namespace: 'template_system' })
    @admin_panel.from(controller_name, action_name)
    @admin_panel.routes_set
  end
end
