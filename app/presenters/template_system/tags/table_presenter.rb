class TemplateSystem::Tags::TablePresenter < TemplateSystem::BasePresenter
  def render_tag
    tbody = ''.html_safe; thead =''.html_safe
    with_th = (@model.template_tag[:settings] || ''.freeze).include? :headers.to_s
    @model.template_table_contents.ordering.group_by{|a| a.row_num}.each do |elem|
      t = (elem[1][0].row_num == 1 && with_th) ? { var: thead, tag: :th }  : { var: tbody, tag: :td }
      t[:var] << h.content_tag(:tr, elem[1].inject("".html_safe){ |td, el|
        td << h.content_tag(t[:tag], el.content_text.html_safe)
      },
      class: t[:tag])
    end
    h.content_tag :table, h.content_tag(:thead, thead) << h.content_tag(:tbody, tbody), class: "#{@model.template_tag.html_class}"
  end

  def render_tag_admin
    tbody = ''.html_safe; thead =''.html_safe
    with_th = (@model.template_tag[:settings] || ''.freeze).include? :headers.to_s
    @model.template_table_contents.ordering.group_by{ |a| a.row_num }.each do |elem|
      t = (elem[1][0].row_num == 1 && with_th) ? { var: thead, tag: :th }  : { var: tbody, tag: :td }
      t[:var] << h.content_tag(
        :tr,
        elem[1].inject("".html_safe){ |td, el|
        #td << h.content_tag(el.row_num == 0 ? :th : :td, el.content_text.html_safe << render("admin/editing_buttons", item:el),
        td << h.content_tag(t[:tag], el.content_text.html_safe,
                          class: "js__content-editing content-editing li-admin-stroke " << (el.del ? "delete-block":""),
                          data: { 'name' => 'ttc', 'ttc-id' => el.id, 'ttc-row' => el.row_num })},
      class: t[:tag], data: {'name' => 'tc', 'tc-id' => @model.id }
      )
    end
    h.content_tag(:table, h.content_tag(:thead, thead) << h.content_tag(:tbody, tbody), class: "#{@model.template_tag.html_class}")<<
    h.link_to(
      'Добавить строку<span class="ts-icons icon-add"></span>'.html_safe,
      template_system_new_row_table_template_path(@model),
      class:"button-mid button-mid--table button-mid--l js__btn-action",
      remote: true
    ) <<
    h.link_to(
      'Добавить колонку<span class="ts-icons icon-add"></span>'.html_safe,
      template_system_new_column_table_template_path(@model),
      class:"button-mid button-mid--table button-mid--l js__btn-action",
      remote: true
    )
  end
end
