class BizInfoController < ApplicationController
  before_filter :set_actions, if: proc { current_user&.admin_less? }

  def show
    authorize! :show, BizInfo
  end

  def edit
    authorize! :edit, BizInfo
    case params[:id]
    when 'logo'
      @logo = BizInfo::Logo.new
    else
      @biz_info = BizInfo.new
    end

    render "new_edit", locals: { form_partial: "form_#{params[:id]}" }
  end

  def update
    authorize! :update, BizInfo
    respond_to do |format|
      if @biz_info.update_attributes(params[:biz_info])
        format.html { redirect_to template_system.biz_info_url, notice: t('activerecord.successful.messages.updated', model: controller_name.classify.constantize.model_name.human) }
      else
        format.html { render action: "edit", template: "application/new_edit" }
      end
    end
  end

  def upload_logo
    authorize! :update, BizInfo
    @logo = BizInfo::Logo.new
    respond_to do |format|
      if params[:image].blank? || @logo.update_attributes(params[:image])
        format.html { redirect_to template_system.biz_info_url, notice: t('activerecord.successful.messages.updated', model: controller_name.classify.constantize.model_name.human) }
      else
        format.html { render action: "edit_logo", template: "application/new_edit", locals: { form_partial: 'form_logo' }}
      end
    end
  end

  private

  def set_actions
    @biz_info = BizInfo.new
    @admin_panel = Admin::Panel::Base.new(BizInfo, { namespace: '' })
    @admin_panel.from(controller_name, action_name)
    @admin_panel.model_engine = 'template_system'
  end
end
