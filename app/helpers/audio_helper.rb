module AudioHelper


  require 'mediainfo'


  def audio_admin_button_to_done_editing(audio)
    button_admin_to_done_editing admin_audio_path(audio.id_admin)
  end


  def audio_admin_button_to_edit(audio)
    button_admin_to_edit edit_admin_audio_path(audio.id_admin)
  end


  def audio_admin_button_to_edit_next(audio, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_audio_path(audio.id_admin, pane: current_pane)
    else
      target_link = edit_admin_audio_path(audio.id_admin)
    end
    button_admin_to_next(target_link)
  end


  def audio_admin_button_to_edit_previous(audio, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_audio_path(audio.id_admin, pane: current_pane)
    else
      target_link = edit_admin_audio_path(audio.id_admin)
    end
    button_admin_to_previous(target_link)
  end


  def audio_admin_button_to_index
    button_admin_to_index admin_audio_index_path
  end


  def audio_admin_button_to_new
    button_admin_to_new new_admin_audio_path
  end


  def audio_admin_button_to_new_import
    button_admin_to_new_import admin_audio_new_import_menu_path
  end


  def audio_admin_button_to_new_upload
    button_admin_to_new_upload admin_audio_new_upload_menu_path
  end


  def audio_admin_button_to_next(audio)
    button_admin_to_next admin_audio_path(audio.id_admin)
  end


  def audio_admin_button_to_previous(audio)
    button_admin_to_previous admin_audio_path(audio.id_admin)
  end


  def audio_admin_button_to_public(audio = nil)
    case audio
    when Audio
      if audio.published
        button_admin_to_public public_audio_path(audio.id_public)
      else
        button_admin_to_public_null
      end
    when nil
      button_admin_to_public public_audios_path
    end
  end


  def audio_admin_edit_nav_button(audio: nil, category: nil, current_pane: nil)
    button_admin_to_edit_pane(
      current_pane: current_pane,
      target_link: edit_admin_audio_path(audio.id, pane: category),
      target_pane: category
    )
  end


  def audio_admin_header_nav_buttons
    [ audio_admin_button_to_index,
      audio_admin_button_to_new,
      audio_admin_button_to_new_import,
      audio_admin_button_to_new_upload,
    ].join("\n").html_safe
  end


  def audio_admin_filter_select(form, params)
    selected = params[:filter] ? SorterIndexAdminAudio.find_id_from_param(params[:filter]) : form.object.admin_index_audio_sorter_id
    form.select(
      :admin_index_audio_sorter_id,
      SorterIndexAdminAudio.options_for_select(:url),
      { include_blank: false, selected: selected },
      { class: [:arl_active_refine_selection, :arl_button_select, :arl_audio_index_filter] }
    )
  end


  def audio_album_admin_button_to_new_join_single(audio)
    button_admin_to_new_join_single edit_admin_audio_path(audio.id_admin, pane: :album_join_single)
  end


  def audio_event_admin_button_to_new_join_single(audio)
    button_admin_to_new_join_single edit_admin_audio_path(audio.id_admin, pane: :event_join_single)
  end


  def audio_keyword_admin_button_to_new_join_single(audio)
    button_admin_to_new_join_single edit_admin_audio_path(audio.id_admin, pane: :keyword_join_single)
  end


  def audio_file_source_path_with_indicator_class(audio, html_class: [])
    filename = audio.source_file_path
    html_class = [html_class].flatten
    if filename == ''
      filename = '<i>(no file indicated)</i>'
    end
    if audio.source_file_does_not_exist
      html_class << :arl_error_file_missing
    end
    tag.div "#{filename}".html_safe, class: html_class
  end


  def audio_file_path_with_indicator_classes(audio, html_class: [])
    audio_file_source_path_with_indicators(audio, html_class: html_class)
  end


  def audio_preferred_url(audio)
    case audio.source_type
    when 'imported'
      source_imported_url(audio)
    when 'uploaded'
      if audio.source_uploaded.attached?
        url_for(audio.source_uploaded)
      end
    end
  end

  # used by app/views/admin/audio/_form_id3.haml
  def audio_read_source_metadata(audio)
    metadata = nil
    result = {}
    case audio.source_type
    when 'attachment'
      if audio.source_uploaded.attached?
        audio.source_uploaded.open do |a|
          metadata = MediaInfo.from(a.path)
        end
      end
    when 'imported'
      if File.exist?(source_imported_file_path(audio))
        metadata = MediaInfo.from(source_imported_file_path(audio))
      end
    end
    if MediaInfo::Tracks === metadata
      dur_mins = metadata.general.duration.divmod(1000)[0].divmod(60)[0]
      dur_secs = metadata.general.duration.divmod(1000)[0].divmod(60)[1]
      dur_mils = metadata.general.duration.divmod(1000)[1]
      result['Title'] = "#{metadata.general.track}"
      result['Artist'] = "#{metadata.general.performer}"
      result['Year'] = "© #{metadata.general.recorded_date}"
      result['Duration'] = "#{dur_mins}:#{dur_secs}.#{dur_mils}"
    end
    result
  end


  def audio_reference_admin_link(audio)
    link_to(audio.full_title, admin_audio_path(audio.id_admin))
  end


  def audio_script_jPlayer_single(audio)
    audio_json = js_fragment_jp_audio_unordered(audio)
    js = js_function_jp_single_onready(audio_json)
    app_script_element_for(js)
  end


  def audio_admin_title_link(audio)
    link_to (audio.full_title).gsub('/','/&shy;').html_safe, admin_audio_path(audio.id_admin)
  end


  def audio_title_link_with_indicator(audio, html_class: [])
    html_class = [html_class].flatten
    if audio.indexed == false
      html_class << :arl_error_not_indexed
    end
    link_to (audio.full_title).gsub('/','/&shy;').html_safe, admin_audio_path(audio.id_admin), class: html_class
  end


end
