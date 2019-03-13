class Admin::RowNum::Change
  attr_accessor :obj

  def initialize(args)
    @klass = Object.const_get(args[:md].classify)
    @obj = @klass.find(args[:md_id].to_i)
    @step = args[:direction] == "up" ? -1 : 1
  end

  def change_row_num!(opt=nil)
    opt ||= fields_params
    chain_rec = @klass.where(opt.merge(row_num: @obj.row_num + @step)).first
    if chain_rec.blank?
      if @step == -1
        @obj.row_num == 1 ? nil : false
      else
        @obj.row_num == @klass.where(opt).size ? nil : false
      end
    else
      old_row_num = @obj.row_num
      chain_rec.row_num = old_row_num
      @obj.row_num += @step
      chain_rec.save
      @obj.save
      true
    end
  end

  private

  def fields_params
    if @klass.const_defined? :ROW_NUM_FIELDS
      @klass::ROW_NUM_FIELDS.inject({}) {|memo, elem| memo.merge(elem => @obj.send(elem))}
    else
      {}
    end
  end

end
