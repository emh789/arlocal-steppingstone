module ArlocalHelper


  def arlocal_admin_artist_home_link(arlocal_settings)
    link_to @arlocal_settings.artist_name_downcase, admin_root_path, class: [:arl_header_artist_name, :color_fg]
  end


  def arlocal_admin_header_nav_actions
    ['new', 'import', 'upload', 'index', 'public']
  end


  def arlocal_admin_header_nav_buttons
    result = ''
    html_class = [:arl_admin_header_nav_button, :color_bg3, :color_fg, :faux_border]
    arlocal_admin_header_nav_actions.each do |b|
      case b
      when 'import'
        result << button_tag(icon_new_import, class: html_class)
      when 'index'
        result << button_tag(icon_index, class: html_class)
      when 'new'
        result << button_tag(icon_new, class: html_class)
      when 'public'
        result << button_tag(icon_public, class: html_class)
      when 'upload'
        result << button_tag(icon_new_upload, class: html_class)
      end
    end
    result.html_safe
  end


  def arlocal_public_artist_home_link(arlocal_settings)
    link_to @arlocal_settings.artist_name_downcase, root_path, class: [:arl_header_artist_name, :color_fg]
  end


  def arlocal_public_nav_link(arlocal_settings, category)
    html_class = [:arl_header_nav_category, :color_link]
    case category
    when :albums
      arlocal_public_nav_link_albums(arlocal_settings, html_class)
    when :audio
      arlocal_public_nav_link_audio(arlocal_settings, html_class)
    when :events
      arlocal_public_nav_link_events(arlocal_settings, html_class)
    when :info
      arlocal_public_nav_link_info(arlocal_settings, html_class)
    when :pictures
      arlocal_public_nav_link_pictures(arlocal_settings, html_class)
    when :stream
      arlocal_public_nav_link_stream(arlocal_settings, html_class)
    when :videos
      arlocal_public_nav_link_videos(arlocal_settings, html_class)
    end
  end


  def arlocal_public_nav_link_albums(arlocal_settings, html_class)
    if @arlocal_settings.public_nav_can_include_albums
      link_to 'albums', public_albums_path, class: html_class
    end
  end


  def arlocal_public_nav_link_audio(arlocal_settings, html_class)
    if @arlocal_settings.public_nav_can_include_audio
      link_to 'audio', public_audio_path, class: html_class
    end
  end


  def arlocal_public_nav_link_events(arlocal_settings, html_class)
    if @arlocal_settings.public_nav_can_include_events
      link_to 'events', public_events_path, class: html_class
    end
  end


  def arlocal_public_nav_link_info(arlocal_settings, html_class)
    if @arlocal_settings.public_nav_can_include_info
      link_to 'info', public_infopage_first_path, class: html_class
    end
  end


  def arlocal_public_nav_link_pictures(arlocal_settings, html_class)
    if @arlocal_settings.public_nav_can_include_pictures
      link_to 'pictures', public_pictures_path, class: html_class
    end
  end


  def arlocal_public_nav_link_stream(arlocal_settings, html_class)
    if @arlocal_settings.public_nav_can_include_stream
      link_to 'stream', public_streams_path, class: html_class
    end
  end


  def arlocal_public_nav_link_videos(arlocal_settings, html_class)
    if @arlocal_settings.public_nav_can_include_videos
      link_to 'videos', public_videos_path, class: html_class
    end
  end


  def arlocal_settings_admin_edit_nav_button(arlocal_settings: nil, category: nil, current_pane: nil)
    button_admin_to_edit_pane(
      current_pane: current_pane,
      target_link: edit_admin_arlocal_settings_path(arlocal_settings, pane: category),
      target_pane: category
    )
  end


end
