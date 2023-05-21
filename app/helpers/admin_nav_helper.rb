module AdminNavHelper


  def admin_nav_button_html_classes
    [:arl_admin_header_nav_button]
  end


  def admin_nav_buttons
    case params[:controller]
    when 'admin/audio'
      audio_admin_header_nav_buttons
    when 'admin/welcome'
      welcome_admin_header_nav_buttons
    when 'admin/administrators', 'administrators/registrations'
      administrator_registrations_header_nav_buttons
    when 'admin/albums'
      album_admin_header_nav_buttons
    when 'admin/articles'
      article_admin_header_nav_buttons
    when 'admin/events'
      event_admin_header_nav_buttons
    when 'admin/infopages'
      infopage_admin_header_nav_buttons
    when 'admin/isrc'
      isrc_admin_header_nav_buttons
    when 'admin/keywords'
      keyword_admin_header_nav_buttons
    when 'admin/links'
      link_admin_header_nav_buttons
    when 'admin/pictures'
      picture_admin_header_nav_buttons
    when 'admin/streams'
      stream_admin_header_nav_buttons
    when 'admin/videos'
      video_admin_header_nav_buttons
    end
  end


  def admin_nav_optgroup_tags
    admin_nav_grouped_options.map do |options|
      content_tag(:optgroup, admin_nav_option_tags(options))
    end
  end


  def admin_nav_optgroups
    admin_nav_optgroup_tags.join("\n").html_safe
  end


  def admin_nav_select
    content_tag(:select, admin_nav_optgroups, class: admin_nav_select_classes).html_safe
  end


  def admin_nav_select_classes
    [:arl_active_select, :arl_admin_header_nav_select]
  end


  def admin_nav_option_tag(option = { label: '', category: '', path: '' })
    if option[:controller].match(params[:controller])
      content_tag(:option, option[:label], selected: 'selected', data: {url: option[:path]})
    else
      content_tag(:option, option[:label], data: {url: option[:path]})
    end
  end


  def admin_nav_option_tags(options)
    options.map { |o| admin_nav_option_tag(o) }.join("\n").html_safe
  end



  private


  def admin_nav_grouped_options
    [
      [
        { label: 'Welcome', controller: 'admin/welcome', path: admin_welcome_path },
        { label: 'A&R.local settings', controller: 'admin/arlocal_settings', path: edit_admin_arlocal_settings_path },
        { label: 'Administrators', controller: 'admin/administrators/registrations', path: admin_administrators_path },
      ],
      [
        { label: 'Albums', controller: 'admin/albums', path: admin_albums_path },
        { label: 'Articles', controller: 'admin/articles', path: admin_articles_path },
        { label: 'Audio', controller: 'admin/audio', path: admin_audio_index_path },
        { label: 'Events', controller: 'admin/events', path: admin_events_path },
        { label: 'Info Pages', controller: 'admin/infopages', path: admin_infopages_path },
        { label: 'ISRC', controller: 'admin/isrc', path: admin_isrc_index_path },
        { label: 'Keywords', controller: 'admin/keywords', path: admin_keywords_path },
        { label: 'Links', controller: 'admin/links', path: admin_links_path },
        { label: 'Pictures', controller: 'admin/pictures', path: admin_pictures_path },
        { label: 'Streams', controller: 'admin/streams', path: admin_streams_path },
        { label: 'Videos', controller: 'admin/videos', path: admin_videos_path }
      ],
      [
        { label: 'Log off', controller: 'admin/sessions/delete', path: administrator_sign_out_path }
      ]
    ]
  end


end
