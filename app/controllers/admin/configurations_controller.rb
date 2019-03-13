# -*- encoding : utf-8 -*-
class Admin::ConfigurationsController < ApplicationController
  load_and_authorize_resource class: ::Configuration
  before_filter :set_actions, if: proc { request.format.symbol == :html && current_user&.admin_less?}

  def index
    authorize! :index, :admin
    list = ::Configuration.ordering
    @list_pages = Admin::ListPages.new do |l|
      l.controller_name = 'admin_configurations'
      l.action_name = action_name
      l.list = defined?(TsEshop) ? list.page(params[:page]) : list
    end

    render 'admin_index'
  end

  def new
    @configuration = ::Configuration.new
    render "new_edit"
  end

  def edit
    render "new_edit"
  end

  def create
    @configuration = ::Configuration.new(params[:configuration])

    respond_to do |format|
      if @configuration.save
        ::Configuration.reload
        format.html { redirect_to template_system.admin_configurations_url, notice: 'configuration was successfully created.' }
      else
        format.html { render action: "new", template: "new_edit" }
      end
    end
  end

  def update
    respond_to do |format|
      if @configuration.update_attributes(params[:configuration])
        ::Configuration.reload
        format.html { redirect_to template_system.admin_configurations_url, notice: 'configuration was successfully updated.' }
      else
        format.html { render action: "edit", template: "new_edit" }
      end
    end
  end

  def destroy
    @configuration.destroy
    ::Configuration.reload

    respond_to do |format|
      format.html { redirect_to template_system.admin_configurations_url }
      format.json { render json: @configuration }
    end
  end

  private

  def set_actions
    @admin_panel = ::Admin::Panel::Base.new(::Configuration, { namespace: 'admin' })
    @admin_panel.from(controller_name, action_name)
    @admin_panel.model_engine = 'template_system'
  end
end
