module TemplateSystem::Record::Content
  def default_values
    self.force_id_str ||= id_str
    self.manual_force_id_str ||= 0
  end

  def to_param
    id_str.blank? ? id : id_str
  end

  private

  def create_content_association
    build_content
    true
  end

  def translit_id
    manual_force = manual_force_id_str.is_a?(String) ? manual_force_id_str.to_i == 1 : manual_force_id_str
    auto_force = auto_force_id_str.is_a?(String) ? auto_force_id_str.to_i == 1 : auto_force_id_str

    if auto_force || (id_str.blank? && new_record?)
      require 'russian'

      first_step = true
      id_str_from = self.class.const_defined?(:IDSTR) ? self.send(self.class::IDSTR) : content_name

      strok = Russian::transliterate(id_str_from[0..47].gsub(/\s/, '-')).downcase.gsub(/[^\p{ASCII}]/, '-').gsub(/[^\p{Alnum}]/, '-')
        .gsub(/^\d/, mv_first_digit_hash).squeeze('-').gsub(/^-|-$/, '')
      strok = "find-id" if strok.blank?

      rec = self.class.where(id_str: strok).first
      while !rec.nil? && rec.id != self.id
        if first_step
          strok = strok + "-0"
          first_step = false
        else
          strok.succ!
        end
        rec = self.class.where(id_str: strok).first
      end

      self.id_str = strok

    elsif manual_force && !force_id_str.blank?
      self.id_str = force_id_str
    end
  end

  def mv_first_digit_hash
    { '0'.freeze => 'nol-'.freeze, '1'.freeze => 'odin-'.freeze, '2'.freeze => 'dva-'.freeze, '3'.freeze => 'tri-'.freeze,
      '4'.freeze => 'chetyre-'.freeze, '5'.freeze => 'pyat-'.freeze, '6'.freeze => 'shest-'.freeze, '7'.freeze => 'sem-'.freeze,
      '8'.freeze => 'vosem-'.freeze, '9'.freeze => 'devyat'.freeze }
  end

  #       def fix_translit
  #         self.class::MAIN_HEADER_FIELDS.map  do |elem|
  #           self.send "#{elem}=", self.send(elem).to_s.strip.gsub(/[acxepoykABCXHKMOPT]/,
  #                                                                 'a' => 'а', 'c' => 'с', 'x' => 'х', 'e' => 'е', 'p' => 'р', 'o' => 'о', 'y' => 'у', 'k' => 'к',
  #                                                                 'A' => 'А', 'B' => 'В', 'C' => 'С', 'X' => 'Х', 'H' => 'Н', 'K' => 'К', 'M' => 'М', 'O' => 'О', 'P' => 'Р', 'T' => 'Т')
  #         end
  #       end
end
