class PresenceForceIdStrValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    manual_force = object.manual_force_id_str.is_a?(String) ? object.manual_force_id_str.to_i == 1 : object.manual_force_id_str
    auto_force = object.auto_force_id_str.is_a?(String) ? object.auto_force_id_str.to_i != 1 : object.auto_force_id_str
    if (!object.new_record? || manual_force) && object.force_id_str.blank? && auto_force
      object.errors[attribute] << (options[:message] || :blank)
    end
  end
end
