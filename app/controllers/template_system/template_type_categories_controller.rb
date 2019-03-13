# -*- encoding : utf-8 -*-
class TemplateSystem::TemplateTypeCategoriesController < ApplicationController
  authorize_resource class: false
  layout nil

  def show
    if params[:id].to_i.zero?
      @template_type_category = TemplateSystem::TemplateTypeCategory.new
      @template_types = TemplateSystem::TemplateType.order('use_count DESC').limit(9)
    else
      @template_type_category = TemplateSystem::TemplateTypeCategory.includes(:template_types).find(params[:id])
      @template_types = @template_type_category.template_types.order(:content_name)
    end
    respond_to do |format|
      format.js
      format.html { render text: '', status: 405 }
    end
  end
end
