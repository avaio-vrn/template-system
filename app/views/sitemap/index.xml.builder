xml.instruct! :xml, :version=>"1.0"

xml.tag!('urlset',
         'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
         'xsi:schemaLocation' => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd",
         'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9",
         'xmlns:image' => "http://www.google.com/schemas/sitemap-image/1.1",
         'xmlns:video' => "http://www.google.com/schemas/sitemap-video/1.1",
         'xmlns:geo' => "http://www.google.com/geo/schemas/sitemap/1.0",
         'xmlns:news' => "http://www.google.com/schemas/sitemap-news/0.9",
         'xmlns:mobile' => "http://www.google.com/schemas/sitemap-mobile/1.0",
         'xmlns:pagemap' => "http://www.google.com/schemas/sitemap-pagemap/1.0",
         'xmlns:xhtml' => "http://www.w3.org/1999/xhtml"
        ) do
          xml.url do
            xml.loc "#{@biz_info.protocol}://#{@biz_info.domain_ascii}"
            xml.lastmod Page.where(id_str: 'home_index_page').first.updated_at.to_datetime
            xml.changefreq 'always' #weekly
            xml.priority '1.0' #'0.5'
          end

          sitemap.items.each do |item|
            xml.url do
              xml.loc "#{@biz_info.protocol}://#{@biz_info.domain_ascii}#{polymorphic_path(item.respond_to?(:invert_obj) ? item.invert_obj.select{ |r| r != 'admin' } : item)}"
              xml.lastmod item.is_a?(Class) ? Sitemap.class_updated_at(item) : item.updated_at.to_datetime
              xml.changefreq 'weekly'
              xml.priority '0.5'
            end
          end
        end
