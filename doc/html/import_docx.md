```
<%= form_tag template_system.template_system_import_from_docx_path(@params_hash), remote: true, method: :post,
    multipart: true, class: 'js__import-file fl-r' do %>
  <span class='button-big button-big--l add-template new-template js__btn-action'>
    Загрузить docx<span class='ts-icons icon-add'></span>
  </span>
  <%= file_field_tag :file, class:'f-a-file js__import-file', onchange: "this.form.submit();" %>
<% end %>
```
