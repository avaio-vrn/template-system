class Sitemap
  def initialize(root_type=nil, root_id=nil)
    @config_list_all = list_all
    @config_list_nested = list_nested
    @root_type = root_type
    @root_id = root_id
    @items = []
    @items_opts = {}
  end

  def self.class_updated_at(item_class)
    item_class.order('updated_at DESC').first&.updated_at || '1970-01-01T00:00:00'
  end

  def items
    @items
  end

  def items_opts
    @items_opts
  end

  def only_instances
    @items.reject{ |r| r.is_a? Module }
  end

  def all
    @config_list_all.each do |item|
      @items << items_get(item)
    end
    @items.flatten!
    self
  end


  private

  def list_all
    Configuration.loaded_get('sitemap'.freeze, 'all'.freeze)
  end

  def list_nested
    Configuration.loaded_get('sitemap'.freeze)
      .inject({}){|h, e| h.merge!(e["section_attr"] => e["value"])}.reject { |k, _v| k == 'all'.freeze }
  end

  def items_get(root_type, root_id=nil)
    list_with_nested = []
    @level = 1
    if root_id.nil?
      if is_list? root_type
        obj = root_type.camelcase.constantize
        list_with_nested << [obj]
        items_opts_set(obj, { nested: true })
        @level += 1
      end
      root_type.to_s.camelcase.constantize.ordering.each do |obj|
        next if @items_opts.keys.include?(obj.object_id)
        nested = nested_items_get(obj)
        list_with_nested << [obj, nested]
        items_opts_set(obj, { nested: nested })
      end
      @level -= 1 if is_list? root_type
    else
      #TODO implementation
      # root_type.to_s.camelcase.constantize.find(root_id)
    end
    list_with_nested
  end

  def items_opts_set(obj, opt={})
    @items_opts.merge!(obj.object_id => { nested: !opt[:nested].blank?, level: opt[:level] || @level })
  end

  def is_list?(root_type)
    @config_list_nested.has_key?("#{root_type}_list")
  end

  def nested_items_get(obj)
    nested_objs = []
    @level += 1
    obj_class = obj.class.to_s.underscore
    nested_list = @config_list_nested.dig("#{obj_class}_nested") || []
    nested_list.each do |e|
      nested = obj.send(e.to_sym).ordering
      nested_objs << nested
      nested.each {|n_nested| @items_opts.merge!(n_nested.object_id => { level: @level }) }
    end
    @level -= 1
    nested_objs
  end
end
