class ObjAndEngine
  def initialize(obj, module_name = nil)
    @module_name = module_name
    @obj = obj_set(obj)
    @engine_name = name_set
  end

  def get
    @engine_name
  end

  private

  # TODO: add implementation
  def obj_set(obj)
    if obj.is_a? Symbol

    else

    end
  end

  def name_set
    if defined? @obj::ENGINE_NAME
      @obj::ENGINE_NAME
    else
      split_model = @obj.class_name.split('::'.freeze)
      if split_model.size == 1
        :main_app
      else
        split_model.first
      end
    end
  end
end
