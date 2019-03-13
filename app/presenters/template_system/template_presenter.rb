class TemplateSystem::TemplatePresenter < TemplateSystem::BasePresenter
  def initialize(view, model, controller_name, action_name)
    @controller_name = controller_name
    @action_name = action_name
    @obj = model
    @templates = @obj.templates.not_deleted.ordering if @obj.respond_to?('templates')
    @blank = true if @templates.blank?
    super(model, view)
  end

  def blank?
    @blank
  end

  def render
    @blank ? nil : h.render(partial: '/template_system/templates/template', collection: @templates)
  end

  private

end
