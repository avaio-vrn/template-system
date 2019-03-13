class LazyContent::Base
  def initialize(id)
    @id = id
    internal_or_extension
    @find_instance = @find_klass.new
  end

  def partial
    @find_instance.partial
  end

  def partial_locals
    @find_instance.respond_to?(:partial_locals) ? @find_instance.partial_locals : {}
  end

  def load_js
    @find_instance.respond_to?(:load_js) ? @find_instance.load_js : ''
  end

  def js
    @find_instance.js
  end

  def stylesheet
    @find_instance.stylesheet
  end

  private

  def internal_or_extension
    @find_klass = "lazy_content/#{@id}"
    @find_klass = begin
                    @find_klass.classify.constantize
                  rescue
                    @find_klass  = "extension/lazy_content/#{@id}".classify.constantize
                  end
  end
end
