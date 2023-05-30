module SourceImportedHelper


  def source_imported_dirname(trailing_separator: false)
    case trailing_separator
    when true
      "#{source_imported_path_prefix_filesystem}#{File::SEPARATOR}"
    else
      "#{source_imported_path_prefix_filesystem}"
    end
  end


  # TODO: This looks obsolete.
  # def source_imported_file_exists?(item)
  #   File.exist?(imported_filesystem_path(item))
  # end


  # TODO: This has been refactored into the model and is obsolete as a helper method. OK to delete it entirely?
  # def source_imported_file_path(item)
  #   case item
  #   when Audio, Picture, Video
  #     File.join(source_imported_path_prefix_filesystem, item.source_imported_file_path)
  #   when String
  #     File.join(source_imported_path_prefix_filesystem, item)
  #   end
  # end


  def source_imported_path_prefix_filesystem
    Rails.application.config.x.arlocal[:source_imported_filesystem_dirname]
  end


  def source_imported_path_prefix_url
    Rails.application.config.x.arlocal[:source_imported_url_path_prefix]
  end


  def source_imported_url(item)
    case item
    when Audio, Picture, Video
      asset_url File.join(source_imported_path_prefix_url, item.source_imported_file_path), skip_pipeline: true
    when String
      asset_url File.join(source_imported_path_prefix_url, item), skip_pipeline: true
    end
  end


end


#     rename_column :arlocal_settings, :icon_source_catalog_file_path, :icon_source_imported_file_path
