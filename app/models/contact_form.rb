# -*- encoding : utf-8 -*-
class ContactForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::MassAssignmentSecurity

  attr_accessor :referer, :name, :contacts, :phone, :email, :message,
    :field1, :field2, :field3, :terms_of_service

  validates_presence_of :name, :contacts
  validates :contacts, format: { with: /(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))|(^[+]?[78][\s|(]?\d{3}[\s|)]?\d{3}[-|\s]?\d{2}[-|\s]?\d{2}$)/,
                                 message: 'видимо вы ошиблись в написании телефона или элек.почты' }, allow_blank: true
  validates :phone, format: { with: /\A[+]?[78]?\s?[\s|(]?\d{3}[\s|)]?\s?\d{3}[-|\s]?\d{2}[-|\s]?\d{2}\z/,
                              message: 'видимо вы ошиблись в написании телефона' }, allow_blank: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/,
                              message: "видимо вы ошиблись в написании элек.почты" }, allow_blank: true

  #in next rails version
  # validate_with PresenceAnyContactsValidator

  validates_length_of :message, maximum: 500

  def initialize(props = {})
    props.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def assign_attributes(values, options = {})
    sanitize_for_mass_assignment(values, options[:as]).each do |k, v|
      send("#{k}=", v)
    end
  end

  def self.contacts_is_phone?(contacts)
    contacts.match(/\A[+]?[78]?\s?[\s|(]?\d{3}[\s|)]?\s?\d{3}[-|\s]?\d{2}[-|\s]?\d{2}\z/)
  end
end
