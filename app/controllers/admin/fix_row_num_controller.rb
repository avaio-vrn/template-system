# -*- encoding : utf-8 -*-
class Admin::FixRowNumController < ApplicationController
  authorize_resource class: false
  before_filter :check_user_role

  def edit
    @fix_row_num = Admin::RowNum::Fix.new(params[:model], params[:model_engine], params[:opt] || {})

    @admin_panel = Admin::Panel::Base.new('fix_row_num')
    @admin_panel.from(controller_name, action_name)
    @args_auto_fix = { model: params[:model], model_engine: params[:model_engine], model_namespace: params[:model_namespace],
                       opt: params[:opt], auto_fix_row_num: 1 }
    @args_cancel_fix = { model: params[:model], model_engine: params[:model_engine], model_namespace: params[:model_namespace],
                         opt: params[:opt], cancel_check_row_num: 1 }
  end

  def update
    params_opt_parse

    if params[:cancel_check_row_num]
      redirect_to send(engine_name).polymorphic_url(obj_with_namespace, params: params[:opt].merge(cancel_check_row_num: 1))
    else
      records = Admin::RowNum::Fix.new(params[:model], params[:model_engine], params[:opt] || {})
      if params[:auto_fix_row_num]
        records.auto_fix!
      else
        records.row_num_set(params[:fixes])
      end
      redirect_to send(engine_name).polymorphic_url(obj_with_namespace, params[:opt])
    end
  end

  private

  def check_user_role
    raise ExceptionsErrors::LackAuthorityError.new unless(current_user && current_user.admin_less?)
  end

  def engine_name
    params[:model_engine].blank? ? :main_app : params[:model_engine]
  end

  def obj_with_namespace
    obj = params[:model].pluralize
    params[:model_namespace].blank? ? obj : [params[:model_namespace], obj].join('_')
  end

  def params_opt_parse
    params[:opt] = if params[:opt].blank?
                     {}
                   elsif params[:opt].is_a?(String)
                     JSON.parse(params[:opt].gsub('=>', ':').gsub('nil', 'null'))
                   else
                     params[:opt].each { |_k, v| v.uniq! if v.is_a?(Array) }
                   end
  end
end
