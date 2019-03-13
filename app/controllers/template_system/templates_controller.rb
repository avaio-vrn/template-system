# -*- encoding : utf-8 -*-
class TemplateSystem::TemplatesController < ApplicationController
  authorize_resource

  before_filter :set_actions, if: proc { current_user&.admin_less? }

  def edit
  end

  def create
    @content = TemplateSystem::Content.find(params['content_id'])
    create_collection = params[:template_system_template][:create_collection] == true.to_s
    created = TemplateSystem::TemplateBuilder.new(params[:content_id], params)
    created.build(create_collection)

    respond_to do |format|
      if created.save
        if create_collection
          format.js { render "/template_system/templates/ajax/create_collection",
                      locals: { data_name_parent: 't', data_name: 'tc', template_collection: created.collection },
                      layout: nil }
        else
          format.js { render "/template_system/templates/ajax/create",
                      locals: { data_name_parent: 't', data_name: 'tc', item: created.item },
                      layout: nil }
        end
      else
        format.js {render js: "alert('error create template')"}
      end
    end
  end

  def destroy
    @template = TemplateSystem::Template.find(params[:r_id] || params[:id])
    @template.destroy

    respond_to do |format|
      format.json { render json: @template }
      format.html { redirect_to request.referer }
    end
  end


  private

  def set_actions
    @admin_panel = ::Admin::Panel::Base.new(@template)
    @admin_panel.routes = [ :destroy ]
  end
end
