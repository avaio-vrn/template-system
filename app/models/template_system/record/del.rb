class TemplateSystem::Record::Del < ActiveRecord::Base
  self.abstract_class = true

  after_initialize :check_null_del
  attr_accessible :del

  scope :not_deleted, conditions: { del: false }
  #FIX in Rails 5?
  # scope :not_deleted, -> { where(del: false) }

  private

  def check_null_del
    #TODO do not after initialize for perfomance
    self.del ||= false
  end
end
