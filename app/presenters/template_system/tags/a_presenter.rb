class TemplateSystem::Tags::APresenter < TemplateSystem::BasePresenter
  def render_tag
    h.link_to(
      @model.part_content_text[:text],
      @model.part_content_text[:href],
      class: "#{@model.template_tag.html_class}"
    )
  end

  def render_tag_admin
    h.link_to(
      @model.part_content_text[:text],
      @model.part_content_text[:href],
      class: "js__content-editing content-editing #{@model.template_tag.html_class}",
      data: { 'name' => 'tc', 'tc-id' => @model.id }
    )
  end
end
