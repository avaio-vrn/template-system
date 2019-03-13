# -*- encoding : utf-8 -*-
class TemplateSystem::TemplateContentsController < ApplicationController
  authorize_resource
  before_filter :find_one_record, only: [:edit, :update, :show]
  before_filter :find_records, only: [:index]

  def edit
    respond_to do |format|
      format.html {redirect_to :back}
      format.js { render "/template_system/templates/ajax/edit_content",
                  locals: { data_name: params[:data_name] || 'tc', item: @content, content: @content }, layout: nil}
    end
  end

  def update
    #TODO remove this line, after refact editing icons
    @admin_panel = ::Admin::Panel::Base.new(TemplateSystem::Template)
    @admin_panel.routes_set

    if params.dig('files_image', 'file')
      @content.update_attributes(image_attributes: params['files_image'])
    end
    if params['values'].is_a?(Hash) && params.dig(:values, :zoom).to_i == 1
      params[:values][:zoom] = @content.image.url(:big)
    end

    if params['raw']
      params['values'] = params['raw']['values'].strip
    else
      strip_values
    end

    respond_to do |format|
      if @content.update_attributes(content_text: params[:values]);
        format.js { render "/template_system/templates/ajax/finish_edit_content",
                    locals: {data_name: 't', item: @content.template}, layout: nil}
      else
        format.js { render text: "alert(Ошибка при сохранении! Что-то пошло не так.);"}
      end
    end
  end

  def show
    @admin_panel = ::Admin::Panel::Base.new(TemplateSystem::Template)
    @admin_panel.routes_set

    respond_to do |format|
      format.js { render "/template_system/templates/ajax/finish_edit_content", locals: {data_name: 't', item: @content.template}, layout: nil}
    end
  end

  private

  def find_one_record
    @content = TemplateSystem::TemplateContent.find(params[:target_id] || params[:id])
  end

  def strip_values
    params[:values] = params[:values][0] unless params[:values][0].nil?

    if params[:values].is_a? String
      params[:values].strip!
    elsif params[:values].is_a? Hash
      params[:values].map{ |_k, v| v.strip! }
    end
  end
end
