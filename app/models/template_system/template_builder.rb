class TemplateSystem::TemplateBuilder

  def initialize(root_id, argv)
    @root_id = root_id
    @params = argv[:template_system_template]
  end

  def item
    @item
  end

  def collection
    @collection
  end

  def build(create_collection=false)
    create_collection ? build_many : build_one
  end

  def save
    if @collection.nil?
      @item.save
    else
      @collection.map(&:save)
    end
  end

  private

  def build_one
    template = TemplateSystem::Template.new(@params)
    template.row_num = TemplateSystem::Template.get_next_row_num(content_id: @root_id)
    tp = TemplateSystem::TemplateType.find(@params[:template_type_id])
    (tp.template_parts.blank? ? [tp] : tp.template_parts).each do |part|
      part.template_tags.each do |t_tag|
        tag_class = begin
                      ('TemplateSystem::Tags::' + t_tag.name.capitalize).constantize
                    rescue NameError
                      TemplateSystem::Tags::Others
                    end
        template.template_contents << tag_class.new(tag_id: t_tag.id, type_id: part.is_a?(TemplateSystem::TemplatePart) ? part.template_type_id.to_s : part.id.to_s)
      end
    end
    template.del = true

    @item = template
  end

  def build_many
    tt1 = nil
    tt2 = nil
    tt3 = nil
    all = TemplateSystem::TemplateType.all
    index = 0
    while((!tt1 || !tt2 || !tt3) && (index < all.size))
      case all[index].template_tags.size
      when 1
        tt1 = all[index] if all[index].template_tags[0].name == 'p'
      when 2
        tt2 = all[index] if(all[index].template_tags[0].name == 'p' && all[index].template_tags[1].name == 'p')
      when 3
        tt3 = all[index] if(all[index].template_tags[0].name == 'p' && all[index].template_tags[1].name == 'p' && all[index].template_tags[2].name == 'p')
      end
      index += 1
    end
    lines = @params[:text].lines.delete_if {|a| a.strip.blank?}
    if lines.size > 5
      index = 10
      ln = [[]]
      ln = lines.in_groups(index-=1) while ln[0].count < 3;
    elsif lines.size == 5
      ln = lines.in_groups(3)
    elsif lines.size == 4
      ln = lines.in_groups(2)
    else
      ln = lines.split
    end
    template_collection = []
    row_num = TemplateSystem::Template.get_next_row_num(content_id: @root_id)
    ln.each_with_index do |elem, index|
      case elem.size
      when 2; tt = tt2
      when 3; tt = tt3
      end
      tca = {}
      elem.each_with_index do |e, index|
        tca.merge!(index.to_s => {template_type_id: tt2.id, template_tag_id: tt2.template_tags[0].id, content_text: e}) unless e.nil?
      end
      template_collection << TemplateSystem::Template.new({ content_id: @root_id, template_type_id: tt2.id,
                                                           del: true, row_num: row_num + index, template_contents_attributes: tca })
    end

    @collection = template_collection
  end
end
