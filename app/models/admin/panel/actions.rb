class Admin::Panel::Actions
  def initialize(admin_panel)
    @admin_panel = admin_panel
    @controller, @action = @admin_panel.from_controller, @admin_panel.from_action
    @obj = @admin_panel.obj

    @collection, @collection_additionally = [], []
    load_actions
  end

  def collection(primary: true)
    primary ? @collection : @collection_additionally
  end

  def size(primary: true)
    if primary
      @collection.size
    else
      include_seo? ? @collection_additionally.size + 1 : @collection_additionally.size
    end
  end

  def include_seo?
    @include_seo
  end

  def can_content_edit?
    @can_content_edit
  end

  def add_index_actions(hs={})
    arg, opt = hs['arg'] || {}, hs['opt'] || {}

    hmn = I18n.t obj_i18n_key, scope: [:activerecord, :models, :accusative]
    @collection <<  { href_name: opt['index_action']['name'], arg: arg, obj: opt['obj'] } if opt['index_action']
    @collection <<  { href_name: "Добавить #{hmn}", href_class: :new, obj: opt['obj'], arg: arg.merge(action: :new), br: true } unless opt['without_new']

    edit_content_action
  end

  def add_show_actions(hs={})
    new_obj = hs['obj']
    arg, opt = hs['arg'] || {}, hs['opt'] || {}
    @obj = new_obj unless new_obj.nil?

    hmn = I18n.t obj_i18n_key, scope: [:activerecord, :models, :accusative]
    @collection <<  { href_name: opt['index_action']['name'], arg: arg, obj: obj_sym } if (opt['index_action'] || opt['with_index'])

    return if @obj.is_a? Class

    @collection <<  { href_name: "Добавить #{hmn}", arg: arg.merge(action: :new), br: true } unless opt['without_new']
    @collection <<  { href_name: "Копирoвать #{hmn}", arg: arg.merge(action: :new, copy_id: @obj.id), br: true } if opt['copy_id']
    @collection << { href_name: "Редактировать #{hmn}", arg: arg.merge(action: :edit) }
    if @obj.respond_to? :del
      if @obj.del
        @collection << { href_name: "Снять пометку на удаление", confirm: 'Снять пометку на удаление?', href_class: 'icon-delete icon-cancel-delete',
                         arg: arg.merge(cancel: 1, model_engine: model_engine), del: false, br: true}
        full_del = true
      else
        @collection << { href_name: "Пометить на удаление", confirm: 'Данные будут удалены! Уверены?', href_class: 'icon-delete',
                         arg: arg.merge(model_engine: model_engine), del: true, br: true}
      end
    else
      full_del = true
    end
    @collection << { href_name: 'Удалить безвозвратно!', confirm: 'Данные будут ПОЛНОСТЬЮ удалены! Уверены?', arg: arg, full_del: true, br: true } if full_del

    edit_content_action
  end

  #TODO deprecation?
  # def add_addition_actions
  #   @collection_additionally << {href_name: 'Пометить все на удаление', href: template_system.admin_set_del_templates_path(model), href_class: 'icon-delete'} <<
  #   {href_name: 'Снять все на удаление', href: template_system.admin_set_del_templates_path(model, cancel: 1), href_class: 'icon-delete icon-cancel-delete', br: true} <<
  #   {href_name: 'Сортировать по алфавиту', href: template_system.admin_alphabetical_row_num_path(model)}
  # end

  def raw_action(h={})
    @collection << h
  end

  def raw_add_action(h={})
    @collection_additionally << h
  end

  def add_save_action
    @collection << { href_save: true }
  end

  def add_edit_content_action
    edit_content_action
  end

  private

  def obj_sym
    @obj.class.name.split('::').last.underscore.to_sym
  end

  def obj_i18n_key
    klass = @obj.is_a?(Module) ? @obj : @obj.class
    klass.model_name.i18n_key
  end

  def model_engine
    @admin_panel.model_engine
  end

  def edit_content_action
    if !@obj.is_a?(::Module) && @obj.class.reflect_on_association(:content)
      @can_content_edit = true
    end
  end

  def load_actions
    conf = configuration
    conf = convention if conf.blank?
    @collection << { href_save: true } if ([:new, :edit, :create, :update].include?(@action.to_sym) || conf&.has_key?('href_save'))

    return nil if conf.blank?

    @include_seo = conf['seo_actions'].nil? || conf['seo_actions'] ? true : false

    parse conf
    parse(conf, 'additional')

    edit_content_action if conf['edit_content']
    add_index_actions(conf['add_index_actions']) if conf['add_index_actions']
    add_show_actions(conf['add_show_actions']) if conf['add_show_actions']
  end

  def convention
    YAML.load_file(Rails.configuration.ts_panel_action_filename).dig(*yml_tree_point)
  end

  def configuration
    file = Rails.root.join('config/temsys/panel_actions.yml')
    YAML.load_file(file).dig(*yml_tree_point) if File.exist?(file)
  end

  def yml_tree_point
    [@admin_panel.namespace.split('/'), @controller, @action].flatten
  end

  def parse(conf, primary='primary')
    return nil if conf['actions'].blank? || conf&.dig('actions', primary).blank?
    collection = primary == 'primary' ? @collection : @collection_additionally
    conf['actions'][primary].each do |action|
      collection << conf_to_hash(action)
    end
  end

  def conf_to_hash(hs)
    hs.inject({}) do |new_hs, (k, v)|
      if v.is_a? Hash
        new_hs.merge(k.to_sym => conf_to_hash(v))
      else
        new_hs.merge(k.to_sym => real_value(v))
      end
    end
  end

  def real_value(value)
    return from_array(value) if value.is_a? Array
    return value unless value.is_a? String

    if value[1] == ':'
      value.constantize
    elsif value[0] == ':'
      value[1..-1].to_sym
    else
      value
    end
  end

  def from_array(value)
    value.map { |el| real_value(el) }
  end
end
