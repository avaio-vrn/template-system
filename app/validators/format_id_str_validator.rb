class FormatIdStrValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    auto_force = object.auto_force_id_str.is_a?(String) ? object.auto_force_id_str.to_i == 1 : object.auto_force_id_str
    manual_force = object.manual_force_id_str.is_a?(String) ? object.manual_force_id_str.to_i == 1 : object.manual_force_id_str
    force_id_str = object.force_id_str.to_s

    if !auto_force && !force_id_str.blank? && manual_force && (force_id_str =~ /\A[a-z0-9\-\_]+\z/i).nil?
      object.errors[attribute] << (options[:message] || :format)
    end
  end
end
