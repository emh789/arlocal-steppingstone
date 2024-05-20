module PicturesHelper


  def picture_admin_button_to_done_editing(picture)
    button_admin_to_done_editing admin_picture_path(@picture.id_admin)
  end


  def picture_admin_button_to_edit(picture)
    button_admin_to_edit edit_admin_picture_path(picture.id_admin)
  end


  def picture_admin_button_to_edit_next(picture, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_picture_path(picture.id_admin, pane: current_pane)
    else
      target_link = edit_admin_picture_path(picture.id_admin)
    end
    button_admin_to_next(target_link)
  end


  def picture_admin_button_to_edit_previous(picture, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_picture_path(picture.id_admin, pane: current_pane)
    else
      target_link = edit_admin_picture_path(picture.id_admin)
    end
    button_admin_to_previous(target_link)
  end


  def picture_admin_button_to_index
    button_admin_to_index admin_pictures_path
  end


  def picture_admin_button_to_new
    button_admin_to_new new_admin_picture_path
  end


  def picture_admin_button_to_new_import
    button_admin_to_new_import admin_picture_new_import_menu_path
  end


  def picture_admin_button_to_new_upload
    button_admin_to_new_upload admin_picture_new_upload_menu_path
  end


  def picture_admin_button_to_next(picture)
    button_admin_to_next admin_picture_path(picture.id_admin)
  end


  def picture_admin_button_to_public(picture = nil)
    case picture
    when Picture
      if picture.published
        button_admin_to_public public_picture_path(picture.id_public)
      else
        button_admin_to_public_null
      end
    when nil
      button_admin_to_public public_pictures_path
    end
  end


  def picture_admin_button_to_previous(picture)
    button_admin_to_previous admin_picture_path(picture.id_admin)
  end


  def picture_admin_edit_nav_button(picture: nil, category: nil, current_pane: nil)
    button_admin_to_edit_pane(
      current_pane: current_pane,
      target_link: edit_admin_picture_path(picture.id_admin, pane: category),
      target_pane: category
    )
  end


  def picture_admin_filepath_with_indicators(picture, html_class: [])
    picture_file_path_div_with_indicators(picture, html_class: html_class)
  end


  def picture_admin_filter_select(form, params)
    selected = params[:filter] ? (params[:filter]) : form.object.admin_index_pictures_sort_method
    form.select(
      :admin_index_pictures_sort_method,
      SorterIndexAdminPictures.options_for_select(:url),
      { include_blank: false, selected: selected },
      { class: [:arl_active_refine_selection, :arl_button_select, :arl_admin_pictures_index_filter] }
    )
  end


  def picture_admin_header_nav_buttons
    [ picture_admin_button_to_index,
      picture_admin_button_to_new,
      picture_admin_button_to_new_import,
      picture_admin_button_to_new_upload,
    ].join("\n").html_safe
  end


  def picture_admin_link_title(picture)
    link_to parser_inline(picture.title_props), admin_picture_path(picture.id_admin)
  end


  def picture_album_admin_button_to_new_join_single(picture)
    button_admin_to_new_join_single edit_admin_picture_path(picture.id_admin, pane: :album_join_single)
  end


  def picture_event_admin_button_to_new_join_single(picture)
    button_admin_to_new_join_single edit_admin_picture_path(picture.id_admin, pane: :event_join_single)
  end


  def picture_keyword_admin_button_to_new_join_single(picture)
    button_admin_to_new_join_single edit_admin_picture_path(picture.id_admin, pane: :keyword_join_single)
  end


  def picture_datetime_effective_statement(picture)
    "#{picture.datetime_effective_value} (#{picture.datetime_effective_method})"
  end


  def picture_file_path_div_with_indicators(picture, html_class: [])
    filename = picture.source_file_path
    html_class = [html_class].flatten
    if filename == ''
      filename = '<i>(no file indicated)</i>'
    end
    if picture.source_file_does_not_exist
      html_class << :arl_error_file_missing
    end
    tag.div "#{filename}".html_safe, class: html_class
  end


  def picture_for_select_original_nil_tag(html_class: nil)
    image_tag(asset_url(Rails.application.config.x.arlocal[:app_nilpicture_file_path]), class: html_class)
  end


  def picture_options_for_select(picture_options, form)
    options_for_select(
      picture_options.map { |picture| [
          picture.title_for_select,
          picture.id,
          {'data-picture-src' => picture_preferred_url(picture)}
      ] },
      selected: form.object.picture_id
    )
  end


  def picture_preferred_tag(picture, html_class: nil)
    case picture
    when nil
      tag.img(class: html_class, src: Rails.application.config.x.arlocal[:app_nilpicture_file_path])
    when Picture
      tag.img(src: picture_preferred_url(picture), class: html_class)
    end
  end


  def picture_preferred_url(picture)
    case picture.source_type
    when 'imported'
      source_imported_url(picture)
    when 'uploaded'
      if picture.source_uploaded.attached?
        url_for(picture.source_uploaded)
      end
    when nil
      asset_url(Rails.application.config.x.arlocal[:app_nilpicture_file_path])
    end
  end


  def picture_thumbnail_link(picture, html_class: :arl_picture_thumbnail)
    link_to(picture_preferred_tag(picture, html_class: html_class), public_picture_path(picture.id_public))
  end


  ## TODO: not used
  # def picture_title_link(picture, path, html_class: nil)
  #   link_to parser_div(picture.title_props), path, class: html_class
  # end


  def picture_video_admin_button_to_new_join_single(picture)
    button_admin_to_new_join_single edit_admin_picture_path(picture.id_admin, pane: :video_join_single)
  end


end
