class TemplateSystem::Tags::UlPresenter < TemplateSystem::BasePresenter
  def render_tag
    h.content_tag(
      @model.template_tag.name,
      @model.template_table_contents.not_deleted.ordering.inject("".html_safe){ |li, el| li << h.content_tag(:li, el.content_text) },
      class: "#{@model.template_tag.html_class}"
    )
  end

  def render_tag_admin
    h.content_tag(
      @model.template_tag.name,
      render_li(@model),
      class: "#{@model.template_tag.html_class}", data: {'name' => 'tc', 'tc-id' => @model.id }
    ) <<
    h.content_tag(:div, buttons, class: 'path-12')
  end

  private

  def render_li(content)
    content.template_table_contents.ordering.each_with_index.inject("".html_safe) do |li, (el, i)|
      li <<
      h.content_tag(
        :li, el.content_text.html_safe << h.render("admin/editing_buttons", item: el),
        class: "js__content-editing content-editing li-admin-stroke " << (el.del ? "delete-block":""),
        data:{ 'name' => 'ttc', 'ttc-id' => el.id, 'ttc-row' => el.row_num, 'index' => i }
      )
    end
  end

  def buttons
    h.link_to(
      'Добавить строку<span class="ts-icons icon-add"></span>'.html_safe,
      template_system_new_row_table_template_path(@model),
      class:"button-mid button-mid--li button-mid--l js__btn-action",
      remote: true
    ) <<
    h.link_to(
      'Добавить блок<span class="ts-icons icon-add"></span>'.html_safe,
      template_system_new_table_block_template_path(@model),
      class:"new-block button-mid button-mid--li button-mid--l js__btn-action experiment",
      remote: true
    )
  end
end
