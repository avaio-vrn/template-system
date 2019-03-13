# -*- encoding : utf-8 -*-
class Admin::TemplateSystem::PersistentDataController < ApplicationController
  authorize_resource class: Admin::TemplateSystem::PersistentData
  before_filter :set_actions, if: proc { request.format.symbol == :html && current_user&.admin_less?}

  def index
    authorize! :index, :admin
    list = ::Admin::TemplateSystem::PersistentData.ordering
    @list_pages = Admin::ListPages.new do |l|
      l.controller_name = 'admin_template_system_persistent_data'
      l.action_name = action_name
      l.list = defined?(TsEshop) ? list.page(params[:page]) : list
    end
  end

  private

  def set_actions
    @admin_panel = ::Admin::Panel::Base.new(Admin::TemplateSystem::PersistentData)
    @admin_panel.from(controller_name, action_name)
    @admin_panel.model_engine = 'template_system'
  end
end
