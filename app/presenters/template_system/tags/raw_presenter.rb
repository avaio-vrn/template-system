class TemplateSystem::Tags::RawPresenter < TemplateSystem::BasePresenter
  def render_tag
    h.raw h.content_tag(@model.template_tag.name, @model.content_text.html_safe, class: "#{@model.template_tag.html_class}")
  end

  def render_tag_admin
    h.raw h.content_tag(
      @model.template_tag.name,
      @model.content_text.html_safe,
      class: "js__content-editing content-editing #{@model.template_tag.html_class}",
      data: {'name' => 'tc', 'tc-id' => @model.id}
    )
  end
end
