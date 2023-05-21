module SourceUploaded


  module_function


  def rename_all_attachments
    [ Audio, Picture ].each { |resource_class| rename_class_attachments(resource_class) }
  end


  def rename_all_source_type
    [ Audio, Picture ].each { |resource_class| rename_class_source_type(resource_class) }
    rename_item_source_type_arlocal_settings_icon
  end


  def rename_class_attachments(resource_class)
    resource_class.all.each { |resource| rename_item_attachments(resource) }
  end


  def rename_class_source_type(resource_class)
    resource_class.all.each { |resource| rename_item_source_type(resource) }
  end


  def rename_item_attachments(resource)
    if resource.source_attachment.attachment
      resource.source_attachment.attachment.update_attribute(:name, 'source_uploaded')
    end
  end


  def rename_item_source_type(resource)
    case resource.source_type
    when 'imported'
      resource.update_attribute(:source_type, 'imported')
    when 'attachment'
      resource.update_attribute(:source_type, 'uploaded')
    end
  end


  def rename_item_source_type_arlocal_settings_icon
    arls = ArlocalSettings.first
    case arls.icon_source_type
    when 'imported'
      arls.update_attribute(:icon_source_type, 'imported')
    when 'attachment'
      arls.update_attribute(:icon_source_type, 'uploaded')
    end
  end


end
