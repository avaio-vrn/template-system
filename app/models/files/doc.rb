class Files::Doc < Files::File
  has_attached_file :file,
    styles: { },
    url: "/doc_files/:id/:filename",
    path: ":rails_root/public/doc_files/:id/:filename"
  validates_attachment_content_type :file, content_type: [ "application/pdf","application/msword",
                                                           "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                                                           "application/pdf","application/vnd.ms-excel",
                                                           "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                                           "text/plain" ]
  validates_attachment_file_name :file, matches: [/pdf\Z/i, /doc?x\Z/i, /txt/i, /xls?x/i ]
  validates_attachment_size :file, less_than: 10.megabytes

  def file_name
    self.file_file_name
  end

  def url
    if self.nil?
      "#".freeze
    else
      file.url('original', false)
    end
  end
end
