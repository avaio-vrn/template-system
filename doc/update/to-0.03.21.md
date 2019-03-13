!#ruby
records = TemplateContent.where("content_text like '%<!#>%'")
records.each do |a|
   b = a.content_text.split('<!#>')
   if a.template_tag.name == 'img'
     if b.size < 2
        b << "medium"
      elsif b.size == 2 && b[1].blank?
        b[1] = 'medium'
      elsif b.size == 3
        b_n = b[2];b[2] = b[1];b[1] = b_n
      end
   end
   a.update_attributes(content_text: b.pack('Z*'*b.size))
end

