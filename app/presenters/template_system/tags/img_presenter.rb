class TemplateSystem::Tags::ImgPresenter < TemplateSystem::BasePresenter
  def render_tag
    if @model.part_content_text[:zoom].blank?
      h.content_tag(:figure, image << caption)
    else
      h.link_to(
        h.content_tag(:figure, image << caption),
        @model.part_content_text[:zoom], class:'image-link',
        data: { group: @model.part_content_text[:group] }.reject{ |_k, v| v.blank? }
      )
    end
  end

  def render_tag_admin
    h.content_tag(
      :figure,
      h.image_tag(
        @model.image.url(@model.part_content_text[:size]),
        class: "js__content-editing content-editing #{@model.template_tag.html_class} #{@model.part_content_text[:border]}".strip,
        data: { 'name' => 'tc', 'tc-id' => @model.id }
      )
    )
  end

  private

  def image
    h.image_tag(
      @model.image.url(@model.part_content_text[:size]),
      class: "#{@model.template_tag.html_class} #{@model.part_content_text[:border]}".strip,
      alt: alt
    )
  end

  def alt
    @model.part_content_text[:alt]
  end

  def caption
    str = @model.part_content_text[:caption]
    str.blank? ? nil : h.content_tag(:figcaption, str)
  end
end
