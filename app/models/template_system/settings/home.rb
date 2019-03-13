class TemplateSystem::Settings::Home
  include TemplateSystem::Engine.routes.url_helpers

  def initialize
    @actions = list_get
    @advanced = advanced_list_get
    @critical = critical_list_get
  end

  def actions
    @actions
  end

  def advanced_actions
    @advanced
  end

  def critical_actions
    @critical
  end

  private

  def list_get
    File.exist?(config_file) ? from_file : base
  end

  def advanced_list_get
    [] << edit_template_type
  end

  def critical_list_get
    [
      { id: :configuration,
        url: TemplateSystem::Engine.routes.url_helpers.admin_configurations_path,
        name: 'Редактирование конфигурации сайта',
        description: '' },
      { id: :persistent_data,
        url: TemplateSystem::Engine.routes.url_helpers.admin_template_system_persistent_data_index_path,
        name: 'Сохраненные данные',
        description: 'Данные из форм обратной связи.' }
    ]
  end

  def base
    list = [
      {
        id: :biz_info,
        url: biz_info_path,
        name: 'Основная информация',
        description: 'Изменение названия организации, адреса, телефона, email и другой информации'
      }
    ]
    list << edit_layout if Configuration.loaded_get('main'.freeze, 'edit_layout'.freeze)
    list
  end

  def config_file
    Rails.application.root.join 'config/temsys/settings_home_actions.yml'
  end

  def from_file
    file_actions = YAML.load(File.read(config_file)).deep_symbolize_keys
    file_actions.each { |_k, v| v[:url] = Rails.application.routes.url_helpers.send(v[:url]) if v[:url].is_a?(String) }

    base_actions = replace_base(file_actions.map{ |_k, v| v[:replace] })

    base_actions + file_actions.values
  end

  def replace_base(replace)
    base_for_replace = base
    base_for_replace.reject! { |v| replace.include?(v[:id]) }
    base_for_replace.flatten
  end

  def edit_layout
    { id: :theme,
      url: TemplateSystemLayout::Engine.routes.url_helpers.template_system_layout_themes_path,
      name: 'Настройка макета сайта',
      description: 'Изменение основных цветов, шрифтов, вида шапки, подвала сайта и прочее',
      experiment: true
    }
  end

  def edit_template_type
    { id: :template_types,
      url: TemplateSystem::Engine.routes.url_helpers.template_system_template_types_path,
      name: 'Настройка элементов контента',
      description: 'Добавление/изменение индивидуальных элементов',
      experiment: true
    }
  end
end
