class AlbumVendor < ActiveRecord::Migration[7.1]
  def change
    remove_column :albums, :vendor_widget_gumroad
    rename_column :albums, :show_can_have_vendor_widget_gumroad, :show_can_include_vendor_markdown_links
    add_column :albums, :vendor_markdown_links, :text
  end
end
