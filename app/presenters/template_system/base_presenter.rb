class TemplateSystem::BasePresenter < SimpleDelegator
  include TemplateSystem::Engine.routes.url_helpers

  def initialize(model, view, admin_panel=nil)
    @model, @view, @admin_panel = model, view, admin_panel
    super(@model)
  end

  def h
    @view
  end
end
