class TemplateSystem::Admin::PanelPresenter < TemplateSystem::BasePresenter

  def render
    content = render_button
    content << h.content_tag(:div, nil, class: 'clearfloat') if self[:br]
    content << h.tag(:hr, class: 'line') if self[:hr]
    content
  end

  def render_seo(page_hash)
    page_hash.reject! { |_k, v| v.nil? }
    h.link_to(content_link('Search engine optimization', 'icon-seo'),  h.seo.seo_meta_tags_path(page_hash), class: :"admin-link") <<
    h.content_tag(:div, nil, class: 'clearfloat')
  end

  private

  def render_button
    if link_name.blank?
      if self.has_key? :href_save
        h.render(inline: "<a rel='nofollow' class='admin-link js__panel-link-save' href='#'>#{content_link('Сохранить', 'icon-save')}</a>".html_safe) <<
        h.link_to(content_link('Вернуться без сохранения', 'icon-abort'), poly_path_get, class: 'admin-link') <<
        h.content_tag(:div, nil, class: 'clearfloat')
      else
        h.content_tag(:div, nil, class:"clearfloat")
      end
    else
      if self[:full_del]
        h.link_to(content_link(link_name, css_class(:destroy)),
                  poly_path_get, method: :delete, data: { confirm: self[:confirm] }, class: :"admin-link")
      else
        if self[:del].nil?
          h.link_to(content_link(link_name, css_class(self)),
                    poly_path_get, method: self[:method], class: :"admin-link", remote: self[:remote])
        else
          h.link_to(content_link(link_name, self[:href_class]),
                    h.template_system.admin_del_path(@admin_panel.obj.class, @admin_panel.obj.id, self[:arg]||{}), method: :post, data: { confirm: self[:confirm] }, class: :"admin-link")
        end
      end
    end
  end

  private

  def poly_path_get
    h.send(self[:model_engine] || @admin_panel.model_engine).polymorphic_path(obj_get, self[:arg] || {})
  end

  def obj_get
    return (self[:obj] || @admin_panel.full_obj) if (self[:namespace].nil? && @admin_panel.default_namespace.nil?) || self[:namespace] == ''

    if (self[:namespace] == @admin_panel.model_module) || (self[:namespace].blank? && @admin_panel.default_namespace == @admin_panel.model_module)
      self[:obj] || @admin_panel.full_obj
    else
      [self[:namespace] || @admin_panel.default_namespace, self[:obj] || @admin_panel.full_obj].flatten
    end
  end

  def link_name
    #implement && move to admin_render
    # I18n.t(@admin_panel.curr_action, scope: @admin_panel.obj_sym, default: self[:href_name)
    self[:href_name]
  end

  def content_link(txt, span_class)
    h.content_tag(:span, nil, class: "ts-icons #{span_class}") << h.content_tag(:span, txt, class: "cell")
  end

  def css_class(opt)
    if opt.is_a? Symbol
      I18n.t opt, scope: [:panel, :css]
    elsif opt[:href_class]
      opt[:href_class].is_a?(Symbol) ? I18n.t(opt[:href_class], scope:[:panel, :css]) : opt[:href_class]
    else
      if opt[:arg] && opt[:arg][:action]
        I18n.t opt[:arg][:action], scope: [:panel, :css]
      else
        I18n.t :index, scope: [:panel, :css]
      end
    end
  end
end
