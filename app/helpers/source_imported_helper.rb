module SourceImportedHelper


  def source_imported_dirname(trailing_separator: false)
    case trailing_separator
    when true
      "#{source_imported_path_prefix_filesystem}#{File::SEPARATOR}"
    else
      "#{source_imported_path_prefix_filesystem}"
    end
  end


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
