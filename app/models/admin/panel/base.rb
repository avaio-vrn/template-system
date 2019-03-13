class Admin::Panel::Base
  attr_accessor :from_controller, :from_action

  attr_accessor :model, :obj, :full_obj, :model_engine, :pages,
    :default_namespace, :routes, :contentable, :obj_for_t

  def initialize(model=nil, opt={})
    @opt = opt
    set_obj(model)
    model_module_set

    @model_engine = model_engine_get(opt[:model_engine])
    @default_namespace ||= @opt[:namespace] || 'admin'

    @pages = opt[:pages]
    @routes = opt[:routes]
  end

  def namespace
    @default_namespace
  end

  def model_module
    return nil unless @split_model.is_a? Array
    @split_model[0..-2].map(&:underscore).join('/')
  end

  def actions(primary: true)
    @actions ||= Admin::Panel::Actions.new(self)
    @actions.collection(primary: primary)
  end

  def actions_size(primary: true)
    @actions ||= Admin::Panel::Actions.new(self)
    @actions.size(primary: primary)
  end

  def include_seo?
    @actions.include_seo?
  end

  def can_content_edit?
    @actions.can_content_edit?
  end

  def from(controller, action)
    @from_controller = controller
    @from_action = action
  end

  def set_obj(obj)
    @full_obj = obj
    @obj = nested_objs(obj)
  end

  def invert_obj(obj)
    obj.respond_to?(:invert_obj) ? obj.invert_obj : obj
  end

  def routes_set
    @routes ||= get_routes
  end

  private

  def model_module_set
    if @opt[:model_module]
      @split_model = @opt[:model_module]
    end
    @split_model = unless @obj.nil? || @obj.is_a?(Symbol)
                     if @obj.kind_of? Module
                       @obj.model_name.split('::')
                     else
                       @obj.class.name.split('::')
                     end
                   end
  end

  def nested_objs(obj)
    obj.is_a?(Array) ? obj.last : obj
  end

  def model_engine_get(opt_module)
    opt_module ? opt_module : (@split_model && @split_model.size > 1 ? @split_model.first.underscore.to_sym : :main_app)
  end

  def get_routes
    return [] if @split_model.blank?
    controller = @split_model.last.underscore.pluralize
    controller = if @model_engine == 'template_system'.to_sym
                   [@model_engine, controller].join('/')
                 elsif !@default_namespace.blank?
                   [@default_namespace, controller].join('/')
                 else
                   controller
                 end
    routes = []
    routes += Rails.application.routes.routes
      .map{|route| route.defaults[:action].to_sym if route.defaults[:controller] == controller}.compact.to_a
    Rails::Application::Railties.engines.each do |engine|
      routes += engine.routes.routes
        .map{|route| route.defaults[:action].to_sym if route.defaults[:controller] == controller}.compact.to_a
    end
    routes
  end
end
