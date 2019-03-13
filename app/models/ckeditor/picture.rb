# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: ckeditor_assets
#
#  id                :integer          not null, primary key
#  data_file_name    :string(255)      not null
#  data_content_type :string(255)
#  data_file_size    :integer
#  assetable_id      :integer
#  assetable_type    :string(30)
#  type              :string(30)
#  width             :integer
#  height            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
    url: "/pictures/:id/:style_:basename.:extension",
    path: ":rails_root/public/pictures/:id/:style_:basename.:extension",
    styles: { content: '800>', thumb: '118x100#' }

  validates_attachment_content_type :data, content_type: /\Aimage/
  validates_attachment_file_name :data, matches: [/png\Z/i, /jpe?g\Z/i]
  validates_attachment_size :data, less_than: 20.megabytes
  validates_attachment_presence :data
  do_not_validate_attachment_file_type :data

  def url_content
    url(:content)
  end
end
