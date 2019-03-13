class Configuration < ActiveRecord::Base
  scope :ordering, -> { order(:section, :section_attr) }

  attr_accessible :attr_type, :critical, :section, :section_attr, :value

  validates_uniqueness_of :section_attr, scope: :section

  def to_s
    "#{section} : #{section_attr} - #{value}"
  end

  def invert_obj
    ['admin', self]
  end


  class << self
    def reload
      @ts_configuration = load_critical
    end

    def loaded_get(section, section_attr=nil, opts={})
      @ts_configuration = load_critical if @ts_configuration.nil? || opts[:force]

      section = section.to_s
      relations = @ts_configuration.select { |r| r['section'] == section }

      if relations.blank?
        relations = rel_update_values json_relations_get({ critical: false, section: section })
      end

      section_attr = section_attr.to_s
      unless section_attr.blank?
        relations = relations.select { |r| r['section_attr'] == section_attr }

        if relations.blank?
          relations = rel_update_values(json_relations_get({ critical: false, section: section, section_attr: section_attr }))
        end
      end
      if relations.size == 1 && !opts[:relation]
        relations.first['value']
      elsif relations.size.zero?
        nil
      else
        relations
      end
    end

    def get_type_of(v)
      case v.class.to_s.downcase
      when 'hash'; 'hash'
      when 'array'; 'array'
      when 'trueclass', 'falseclass'; 'boolean'
      else; 'string'
      end
    end

    private

    def load_critical
      rel_update_values json_relations_get({ critical: true })
    end

    def json_relations_get(args)
      JSON.parse Configuration.where(args).select(['attr_type', 'section', 'section_attr', 'value']).to_json(root: false)
    end

    def rel_update_values(relations)
      relations.each do |r|
        r['value'] = case r['attr_type']
                     when 'boolean'; value_to_bool(r['value'])
                     when 'array'; value_to_a(r['value'])
                     when 'hash'; value_to_h(r['value'])
                     else
                       r['value']
                     end
      end
      relations
    end

    def value_to_bool(v)
      ['true', '1'].include? v
    end

    def value_to_a(v)
      v.split(',').map(&:strip)
    end

    def value_to_h(v)
      YAML.safe_load v
    end
  end
end
