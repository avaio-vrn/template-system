# -*- encoding : utf-8 -*-
class Admin::AdminController < ApplicationController
  authorize_resource class: false
  before_filter :check_user_role
  before_filter :init, if: proc { params[:md] }

  attr_accessor :obj, :split_model, :model_engine

  respond_to :js if mimes_for_respond_to.empty?

  def panel_state
    if params[:leftSide] == true.to_s
      params[:state] == 1.to_s ? session.delete(:left_panel) : session[:left_panel] = { 'hide' => 1 }
    else
      params[:state] == 1.to_s ? session.delete(:right_panel) : session[:right_panel] = { 'hide' => 1 }
    end
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { render json: { message: "Success" }}
    end
  end

  def change_row_num
    if params[:md].blank?
      respond_to do |format|
        format.html { redirect_to request.referer, status: 500 }
        format.json { render json: { error: 'Ошибка на сервере'}, status: 500 }
      end
    else
      md =  Admin::RowNum::Change.new(params)
      not_error = md.change_row_num!

      respond_to do |format|
        if not_error
          format.html { redirect_to request.referer }
          format.json { render json: md.obj }
        elsif not_error.nil?
          format.html { redirect_to request.referer }
          format.json { render json: nil }
        else
          format.html { redirect_to request.referer, status: 422 }
          format.json { render json: { error: 'Ошибка на сервере'}, status: 422 }
        end
      end
    end
  end

  def alphabetical_row_num
    obj = obj.where(params[:md_id_name] => params[:md_id]) if(!params[:md_id].blank? && !params[:md_id_name].blank?)
    if obj.attribute_names.include?('content_name') && obj.attribute_names.include?('row_num')
      obj.order(:content_name).each_with_index{|e,i| e.update_attributes(row_num: i)}
    end
    if params[:md_id].nil?
      redirect_to polymorphic_url(params[:md].pluralize)
    else
      redirect_to send(model_engine).polymorphic_url(params[:assoc],
                                                     params[:n_assoc]+('_type') => params[:md], params[:n_assoc]+('_id') => params[:md_id])
    end
  end

  def del
    return if params[:md].blank?
    data_name = split_model.last.underscore.split('_').inject(""){|memo,e| memo << e[0]}
    md = obj.find(params[:md_id].to_i)
    respond_to do |format|
      if md.update_attribute(:del, params.has_key?("cancel") ? false : true)
        format.html { redirect_to send(model_engine).polymorphic_url(return_after_del_url(md)), alert: t('activerecord.successful.messages.deleted', model: md.class.model_name.human)}
        format.json { render json: md }
      else
        format.html {redirect_to root_path, alert: t('activerecord.errorsful.messages.errored', model: md.class.model_name.human)}
        format.json { render json: { errors: 'Error'}, status: 422 }
      end
    end
  end

  #TODO more friendly name, example del_collection_set
  def set_del
    get_records(params[:assoc], { id: params[:md_id] }).each { |r| r.update_attributes(del: params[:cancel]=='1' ? false : true) }
    if params[:md_id].nil?
      redirect_to polymorphic_url(params[:md].pluralize)
    elsif params[:n_assoc]
      redirect_to send(model_engine).polymorphic_url(params[:assoc_path],
                                                     params[:n_assoc]+('_type') => params[:md], params[:n_assoc]+('_id') => params[:md_id])
    else
      redirect_to send(model_engine).polymorphic_url(params[:assoc_path], id: params[:md_id])
    end
  end

  private

  def init
    self.obj = Object.const_get([params[:namespace]&.classify, params[:md].classify].join('::'))
    self.split_model = obj.model_name.split('::')
    self.model_engine = if params[:model_engine]
                          params[:model_engine].to_sym
                        else
                          split_model.size == 1 ? :main_app : split_model.first.underscore.to_sym
                        end
  end

  def get_records(assoc, opt={})
    records = if opt[:id].nil?
                obj.all
              else
                obj.where(opt.each {|key, value| "#{key}=#{value}"}).inject([]){|rc, el| rc << el.send(assoc)}.flatten
              end
  end

  def return_after_del_url(obj)
    obj.respond_to?(:invert_obj) ? obj.invert_obj : obj
  end

  def check_user_role
    raise ExceptionsErrors::LackAuthorityError.new unless current_user&.admin_less?
  end
end
