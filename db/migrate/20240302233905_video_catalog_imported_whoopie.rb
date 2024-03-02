class VideoCatalogImportedWhoopie < ActiveRecord::Migration[7.1]
  def change
    rename_column :videos, :source_catalog_file_path, :source_imported_file_path
  end
end
