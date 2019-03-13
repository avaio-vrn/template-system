class Admin::RowNum::Fix
  def initialize(model_class, model_engine=nil, query_opt = {}, args = {})
    query_opt ||= {}
    model_engine = model_engine.underscore.to_sym if model_engine.is_a? String
    @klass = if defined?(model_class.to_s.camelize)
               model_engine.to_s.classify.constantize.const_get(model_class.to_s.camelize)
             else
               model_engine.to_s.classify.constantize.const_get(model_class.to_s.classify)
             end
    #TODO implementation model_class -> class_or_obj
    # query_opt = fields_params if query_opt.size.zero?
    add_nil_in_opt(query_opt)
    @records = @klass.where(query_opt.each {|key, value| "#{key}=#{value}"}).ordering
    @destroyed  = args[:destroyed]
    self
  end

  def records
    @records
  end

  def next_get
    @records.size + 1
  end

  def need_check?
    @records.each.with_index(1).any? { |e, i| e.row_num != i }
  end

  def auto_fix!
    @records.each.with_index(1) do |elem, index|
      if elem.row_num != index
        elem.row_num = index;
        elem.save!
      end
    end
    true
  end

  def after_destroy!
    @records.where('row_num > ?', @destroyed).find_each do |e|
      e.update_attributes!(row_num: e.row_num - 1)
    end
  end

  def row_num_set(args)
    args.each do |_k, data|
      @records.find(data[:id]).update_attributes!(row_num: data[:row_num])
    end
  end

  private

  def add_nil_in_opt(hash)
    hash.each do |_k, v|
      if v.is_a?(Array)
        (v << nil) if v.compact.any? { |v| v.size.zero? }
      end
    end
  end

  # def fields_params
  #   if @klass.const_defined? :ROW_NUM_FIELDS
  #     @klass::ROW_NUM_FIELDS.inject({}) {|memo, elem| memo.merge(elem => @obj.send(elem))}
  #   else
  #     {}
  #   end
  # end
end
