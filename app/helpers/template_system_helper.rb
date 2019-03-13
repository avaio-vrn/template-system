module TemplateSystemHelper
  def present_tag(model, presenter_class=nil)
    klass = presenter_class || presenter_class_get(model)
    presenter = klass.new(model, self, @admin_panel)
    block_given? ? yield(presenter) : presenter
  end

  def panel_state
    if current_user && current_user.admin_less?
      state = [:adminmode]
      state << :'open-left' unless session.dig(:left_panel.to_s, :hide.to_s)
      state << :'open-right' unless session.dig(:right_panel.to_s, :hide.to_s)
      state << :'openpanel' if state.size > 1
      state.join(' ')
    else
      nil
    end
  end

  def empty_templates?(model=nil)
    @render_templates ||= TemplateSystem::TemplatePresenter.new(self, model || template_variable_get, controller_name, action_name)
    @render_templates.blank?
  end

  def render_templates(model=nil)
    @render_templates ||= TemplateSystem::TemplatePresenter.new(self, model || template_variable_get, controller_name, action_name)
    @render_templates.render
  end

  def h_flash_msg(action=nil, controller=nil)
    I18n.t("activerecord.successful.messages.#{action || params[:action]}d",
           model: (controller || params[:controller]).classify.constantize.model_name.human)
  end

  def render_flashes
    response = ''.html_safe
    flash.each do |key, value|
      response << flash_html_get(key, value)
    end
    response
  end

  def config_get(*argv)
    Configuration.loaded_get(argv[0], argv[1])
  end

  def send_email_recipients
    email_line = Configuration.loaded_get('biz_info', 'email_order')
    if email_line.nil?
      []
    else
      email_line.split(/[,\s]/).reject{ |e| e.blank? }
    end
  end

  def json_for_icon_global_data(list, method=nil)
    icon_global_data = {}
    list ||= []
    list.each_with_index do |e, i|
      icon_global_data.merge!(index_for_json(e, i, method) => { record: {
        action_path: send(@admin_panel.model_engine).polymorphic_path(poly_path_model(e)),
        model: e.class.to_s,
        model_engine: @admin_panel.model_engine,
        can_destroy: can?(:destroy, e), id: e.id }})

      if e.respond_to?(:have_list_or_table?) && e.have_list_or_table?
        e.template_contents.each do |t_content|
          t_content.template_table_contents.each_with_index do |t, ii|
            icon_global_data[i.to_s].merge!([index_for_json(e, i, method), ii].join('-') => { record: {
              action_path: send(@admin_panel.model_engine).polymorphic_path(t),
              model: t.class.to_s,
              model_engine: @admin_panel.model_engine,
              can_destroy: can?(:destroy, t), id: t.id }})
          end
        end
      end
    end
    icon_global_data.to_json
  end

  def set_variables(hs)
    hs.inject({}) do |new_hs, (k, v)|
      if v.is_a? Hash
        new_hs.merge(k.to_sym => set_variables(v))
      elsif v.is_a?(String) && v[0] == '@'
        new_hs.merge(k.to_sym => variable_get(v))
      elsif v.is_a? Array
        new_hs.merge(k.to_sym => variable_array_get(v))
      else
        new_hs.merge(k.to_sym => v)
      end
    end
  end

  private

  def template_variable_get
    instance_variable_get(action_name == 'index'.freeze ? "@#{controller_name}" : "@#{controller_name.singularize}")
  end

  def index_for_json(elem, index, method)
    if method == :id
      elem.id.to_s
    else
      index.to_s
    end
  end

  def poly_path_model(obj)
    obj.respond_to?(:invert_obj) ? obj.invert_obj : obj
  end

  def flash_html_get(key, value)
    content_tag:div, class: :flash do
      content_tag(:span, nil, class: flash_css_class(key).freeze) <<
      content_tag(:div, value, class: key) <<
      content_tag(:span, nil, class: 'close-flash'.freeze)
    end
  end

  def flash_css_class(key)
    case key
    when :notice; 'flash-icon flash--apply'.freeze
    when :error, :alert; 'flash-icon flash--alert'.freeze
    when :flash; 'flash-icon flash--info'.freeze
    end
  end

  def presenter_class_get(model)
    if model.raw?
      TemplateSystem::Tags::RawPresenter
    else
      begin
        (['TemplateSystem'.freeze, 'Tags'.freeze, model.template_tag.name.capitalize].join('::'.freeze) + 'Presenter').constantize
      rescue NameError
        TemplateSystem::Tags::OthersPresenter
      end
    end
  end

  def variable_get(str)
    v = str.split('.')
    inst = instance_variable_get(v.shift)
    v.blank? ? inst : v.inject(inst) {|m, e| m = m.send(e) }
  end

  def variable_array_get(str)
    str.map do|el|
      if el.is_a? String
        if el[1] == ':'; el.constantize
        elsif el[0] == '@'; instance_variable_get(el)
        else; el
        end
      else
        el
      end
    end
  end
end
