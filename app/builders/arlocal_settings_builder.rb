class ArlocalSettingsBuilder


  def build_and_save_default
    if ArlocalSettings.first
      Rails.logger.warn 'ARLOCAL: Database entry for ArlocalSettings resource already exists.'
    else
      arlocal_settings = default_settings
      arlocal_settings.save
      arlocal_settings
    end
  end


  def default_settings
    ArlocalSettings.new(params_default)
  end


  def params_default
    {
      admin_forms_autokeyword_enabled: false,
      admin_forms_autokeyword_id: nil,
      admin_forms_edit_slug_field: true,
      admin_forms_selectable_pictures_sort_method: 'all_title_asc',
      admin_index_albums_sort_method: 'title_asc',
      admin_index_audio_sort_method: 'filepath_asc',
      admin_index_events_sort_method: 'datetime_asc',
      admin_index_isrc_sort_method: 'isrc_asc',
      admin_index_pictures_sort_method: 'filepath_asc',
      admin_index_videos_sort_method: 'title_asc',
      artist_name: '',
      html_head_public_can_include_meta_description: true,
      icon_source_imported_file_path: '',
      icon_source_type: 'imported',
      marquee_enabled: false,
      marquee_markup_type: 'markdown',
      marquee_markup_text: '',
      public_index_albums_sort_method: 'datetime_asc',
      public_index_audio_sort_method: 'filepath_asc',
      public_index_events_sort_method: 'upcoming',
      public_index_pictures_sort_method: 'datetime_asc',
      public_index_videos_sort_method: 'datetime_asc',
      public_nav_can_include_albums: true,
      public_nav_can_include_audio: false,
      public_nav_can_include_events: true,
      public_nav_can_include_info: true,
      public_nav_can_include_pictures: true
    }
  end


end
