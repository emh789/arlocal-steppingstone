module KeywordsHelper


  def keyword_admin_button_to_done_editing(keyword)
    button_admin_to_done_editing admin_keyword_path(keyword.id_admin)
  end


  def keyword_admin_button_to_edit(keyword)
    button_admin_to_edit edit_admin_keyword_path(keyword.id_admin)
  end


  def keyword_admin_button_to_edit_next(keyword, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_keyword_path(keyword.id_admin, pane: current_pane)
    else
      target_link = edit_admin_keyword_path(keyword.id_admin)
    end
    button_admin_to_next(target_link)
  end


  def keyword_admin_button_to_edit_previous(keyword, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_keyword_path(keyword.id_admin, pane: current_pane)
    else
      target_link = edit_admin_keyword_path(keyword.id_admin)
    end
    button_admin_to_previous(target_link)
  end


  def keyword_admin_button_to_index
    button_admin_to_index admin_keywords_path
  end


  def keyword_admin_button_to_new
    button_admin_to_new new_admin_keyword_path
  end


  def keyword_admin_button_to_next(keyword)
    button_admin_to_next admin_keyword_path(keyword.id_admin)
  end


  def keyword_admin_button_to_previous(keyword)
    button_admin_to_previous admin_keyword_path(keyword.id_admin)
  end


  def keyword_admin_edit_nav_button(keyword: nil, category: nil, current_pane: nil)
    button_admin_to_edit_pane(
      current_pane: current_pane,
      target_link: edit_admin_keyword_path(keyword.id_admin, pane: category),
      target_pane: category
    )
  end


  def keyword_admin_header_nav_buttons
    [ keyword_admin_button_to_index,
      keyword_admin_button_to_new
    ].join("\n").html_safe
  end


  def keyword_admin_link_title(keyword)
    link_to keyword.title_for_display, admin_keyword_path(keyword.id_admin)
  end


  def keyword_album_admin_button_to_new_join_single(keyword)
    button_admin_to_new_join_single edit_admin_keyword_path(keyword.id_admin, pane: :album_join_single)
  end


  def keyword_audio_admin_button_to_new_join_single(keyword)
    button_admin_to_new_join_single edit_admin_keyword_path(keyword.id_admin, pane: :audio_join_single)
  end


  def keyword_audio_admin_button_to_new_import(keyword)
    button_admin_to_new_import edit_admin_keyword_path(keyword.id_admin, pane: :audio_import)
  end


  def keyword_audio_admin_button_to_new_upload(keyword)
    button_admin_to_new_upload edit_admin_keyword_path(keyword.id_admin, pane: :audio_upload)
  end


  def keyword_event_admin_button_to_new_join_single(keyword)
    button_admin_to_new_join_single edit_admin_keyword_path(keyword.id_admin, pane: :event_join_single)
  end


  def keyword_picture_admin_button_to_new_join_single(keyword)
    button_admin_to_new_join_single edit_admin_keyword_path(keyword.id_admin, pane: :picture_join_single)
  end


  def keyword_picture_admin_button_to_new_import(keyword)
    button_admin_to_new_import edit_admin_keyword_path(keyword.id_admin, pane: :picture_import)
  end


  def keyword_picture_admin_button_to_new_upload(keyword)
    button_admin_to_new_upload edit_admin_keyword_path(keyword.id_admin, pane: :picture_upload)
  end


  def keyword_video_admin_button_to_new_join_single(keyword)
    button_admin_to_new_join_single edit_admin_keyword_path(keyword.id_admin, pane: :video_join_single)
  end


end
