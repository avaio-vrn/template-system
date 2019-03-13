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

class Ckeditor::AttachmentFile < Ckeditor::Asset
  has_attached_file :data,
                    url: "/attachments/:id/:filename",
                    path: ":rails_root/public/attachments/:id/:filename"

  validates_attachment_size :data, less_than: 20.megabytes
  validates_attachment_presence :data
  do_not_validate_attachment_file_type :data

  def url_thumb
    @url_thumb ||= Ckeditor::Utils.filethumb(filename)
  end
end
