class TemplateSystem::Tags::OthersPresenter < TemplateSystem::BasePresenter
  def render_tag
    tag = @model.template_tag
    if tag.simple_tag?
      h.tag(tag.name, { class: tag.html_class })
    else
      h.content_tag tag.name, tag.no_content? ? nil : @model.content_text, class: tag.html_class
    end
  end

  def render_tag_admin
    tag = @model.template_tag
    if @model.template_tag.simple_tag?
      h.tag(tag.name, { class: tag.html_class })
    else
      all_others
    end
  end

  private

  def all_others
    tag = @model.template_tag
    h.content_tag(
      tag.name,
      tag.no_content? ? nil : @model.content_text,
      class: editing(tag),
      data: { 'name' => 'tc', 'tc-id' => @model.id }
    )
  end

  def editing(tag)
    if tag.no_content?
      tag.html_class
    else
      "js__content-editing content-editing #{tag.html_class}"
    end
  end
end
