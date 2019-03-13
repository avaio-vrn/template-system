1. add migration

```
# -*- encoding : utf-8 -*-
class UpgradeTemplateSystemTo050 < ActiveRecord::Migration
  def up
    create_table :template_type_categories do |t|
      t.string :content_name, null: false, limit: 70

      t.timestamps
    end
    rename_column :template_types, :human_name, :content_name
    rename_column :template_parts, :human_name, :content_name
    add_column :template_types, :template_type_category_id, :integer
    add_column :template_types, :content_header, :string, limit: 70
    add_column :template_types, :svg_content, :text
    add_column :template_types, :content_text, :text
    add_column :template_types, :use_count, :integer
  end
  def down
    drop_table :template_type_categories
    rename_column :template_types, :content_name, :human_name
    rename_column :template_parts, :content_name, :human_name
    remove_column :template_types, :template_type_category_id
    remove_column :template_types, :content_header
    remove_column :template_types, :svg_content
    remove_column :template_types, :content_text
    remove_column :template_types, :use_count
  end
end
```
