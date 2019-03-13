module TemplateSystem
  class Settings::HomeController < ApplicationController
    def show
      authorize! :show, TemplateSystem::Settings::Home

      @admin_panel = ::Admin::Panel::Base.new
      @admin_panel.from(controller_name, action_name)

      @settings = ::TemplateSystem::Settings::Home.new
    end
  end
end
