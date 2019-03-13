class TemplateSystem::Record::DelRowNum < TemplateSystem::Record::Del
  self.abstract_class = true

  after_destroy :fix_row_num

  attr_accessible :row_num, :force_save
  attr_accessor :force_save

  #TODO fix this in migration default zero value
  before_validation :fill_row_num, if: Proc.new { |record| (record.row_num.nil? || record.row_num.zero?) && !record.force_save }

  scope :ordering, -> { order(:row_num, 'updated_at DESC') }

  validate :row_num, presence: true, numericality: { greater_than_or_equal_t: 1 }

  private

  def fill_row_num
    mrow = self.class.where(row_num_opts).maximum(:row_num) || 0
    self.row_num = mrow < 1 ? 1 : mrow + 1
  end

  def fix_row_num
    ::Admin::RowNum::Fix.new(self.class.name.underscore.to_sym, nil, row_num_opts, { destroyed: self.row_num }).after_destroy!
  end

  def row_num_opts
    self.class.const_defined?(:ROW_NUM_FIELDS) ? row_num_hash : nil
  end

  def row_num_hash
    self.class::ROW_NUM_FIELDS.inject({}) { |memo, e| memo.merge(e => self.send(e)) }
  end
end
