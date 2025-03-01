module AlbumsHelper


  def album_admin_button_to_done_editing(album)
    button_admin_to_done_editing admin_album_path(album.id_admin)
  end


  def album_admin_button_to_edit(album)
    button_admin_to_edit edit_admin_album_path(album.id_admin)
  end


  def album_admin_button_to_edit_next(album, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_album_path(album.id_admin, pane: current_pane)
    else
      target_link = edit_admin_album_path(album.id_admin)
    end
    button_admin_to_next(target_link)
  end


  def album_admin_button_to_edit_previous(album, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_album_path(album.id_admin, pane: current_pane)
    else
      target_link = edit_admin_album_path(album.id_admin)
    end
    button_admin_to_previous(target_link)
  end


  def album_admin_button_to_index
    button_admin_to_index admin_albums_path
  end


  def album_admin_button_to_new
    button_admin_to_new new_admin_album_path
  end


  def album_admin_button_to_next(album)
    button_admin_to_next admin_album_path(album.id_admin)
  end


  def album_admin_button_to_public(album = nil)
    case album
    when Album
      if album.is_published?
        button_admin_to_public public_album_path(album.id_public)
      else
        button_admin_to_public_null
      end
    when nil
      button_admin_to_public public_albums_path
    end
  end


  def album_admin_button_to_previous(album)
    button_admin_to_previous admin_album_path(album.id_admin)
  end


  def album_admin_edit_nav_button(album: nil, category: nil, current_pane: nil)
    button_admin_to_edit_pane(
      current_pane: current_pane,
      target_link: edit_admin_album_path(album.id_admin, pane: category),
      target_pane: category
    )
  end


  def album_admin_filter_select(form, params)
    selected = params[:filter] ? (params[:filter]) : form.object.admin_index_albums_sort_method
    form.select(
      :admin_index_albums_sort_method,
      SorterIndexAdminAlbums.options_for_select(:url),
      { include_blank: false, selected: selected },
      { class: [:arl_active_refine_selection, :arl_button_select, :arl_audio_index_filter] }
    )
  end


  def album_admin_header_nav_buttons
    [ album_admin_button_to_index,
      album_admin_button_to_new
    ].join("\n").html_safe
  end


  def album_admin_link_title(album)
    link_to album.title_for_display, admin_album_path(album.id_admin)
  end


  def album_audio_admin_button_to_new_import(album)
    button_admin_to_new_import edit_admin_album_path(album.id_admin, pane: :audio_import)
  end


  def album_audio_admin_button_to_new_join_by_keyword(album)
    button_admin_to_new_join_by_keyword edit_admin_album_path(album.id_admin, pane: :audio_join_by_keyword)
  end


  def album_audio_admin_button_to_new_join_single(album)
    button_admin_to_new_join_single edit_admin_album_path(album.id_admin, pane: :audio_join_single)
  end


  def album_audio_admin_button_to_new_upload(album)
    button_admin_to_new_upload edit_admin_album_path(album.id_admin, pane: :audio_upload)
  end


  def album_keyword_admin_button_to_new_join_single(album)
    button_admin_to_new_join_single edit_admin_album_path(album.id_admin, pane: :keyword_join_single)
  end


  def album_picture_admin_button_to_new_import(album)
    button_admin_to_new_import edit_admin_album_path(album.id_admin, pane: :picture_import)
  end


  def album_picture_admin_button_to_new_join_by_keyword(album)
    button_admin_to_new_join_by_keyword edit_admin_album_path(album.id_admin, pane: :picture_join_by_keyword)
  end


  def album_picture_admin_button_to_new_join_single(album)
    button_admin_to_new_join_single edit_admin_album_path(album.id_admin, pane: :picture_join_single)
  end


  def album_picture_admin_button_to_new_upload(album)
    button_admin_to_new_upload edit_admin_album_path(album.id_admin, pane: :picture_upload)
  end


  def album_script_jPlayer_playlist(album, view: :published)
    playlist_json = Array.new
    case view
    when :published
      album.album_audio_published_sorted.each do |aa|
        playlist_json << js_fragment_jp_audio_ordered(aa)
      end
    when :all
      album.album_audio_sorted.each do |aa|
        playlist_json << js_fragment_jp_audio_ordered(aa)
      end
    end
    js = js_function_jp_playlist_onready(playlist_json)
    app_script_element_for(js)
  end


  def album_statement_date_released(album)
    sanitize "Released #{album.date_released.strftime('%B %d %Y')}"
  end


end
