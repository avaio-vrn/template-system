class Restrict < ActiveRecord::Base
  #VARIANT = [0-system page(not edit id_str), 1-restrict edit content, 2-restrict edit id_str && content]
  attr_accessible :root_id, :root_type, :variant, :sys_name

  belongs_to :root, polymorphic: true
end
