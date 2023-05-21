class SourceCatalogSourceUploaded < ActiveRecord::Migration[7.0]
  def change
    rename_column :arlocal_settings, :icon_source_catalog_file_path, :icon_source_imported_file_path
    rename_column :audio, :source_catalog_file_path, :source_imported_file_path
    rename_column :pictures, :source_catalog_file_path, :source_imported_file_path
  end
end
