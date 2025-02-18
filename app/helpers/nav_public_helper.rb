module NavPublicHelper

  def nav_public_option_tag(option = { label: '', controller: '', path: '' }, selectable: nil)
    if (selectable) && (option[:controller].match(params[:controller]))
      content_tag(:option, option[:label], selected: 'selected', data: {url: option[:path]})
    else
      content_tag(:option, option[:label], data: {url: option[:path]})
    end
  end

  def nav_public_select(arlocal_settings)
    if arlocal_settings.public_layout_will_have_nav
      case params[:action]
      when 'index'
        nav_public_select_indexes_only(arlocal_settings)
      when 'show'
        nav_public_select_current_and_indexes(arlocal_settings)
      else
        nav_public_select_indexes_only(arlocal_settings)
      end
    end
  end

  def nav_public_select_classes
    [:arl_active_select, :arl_header_nav_select]
  end

  def nav_public_select_current_and_indexes(arlocal_settings)
    content_tag(:select, nav_public_select_current_and_indexes_optgroups(arlocal_settings), class: nav_public_select_classes).html_safe
  end

  def nav_public_select_current_and_indexes_optgroups(arlocal_settings)
    [ content_tag(:optgroup, nav_public_select_current_and_indexes_optgroup_current, label: content_for(:page_subtitle).concat(':')),
      content_tag(:optgroup, nav_public_select_current_and_indexes_optgroup_indexes(arlocal_settings), label: 'Indexes')
    ].join("\n").html_safe
  end

  def nav_public_select_current_and_indexes_optgroup_current
    content_tag(:option, content_for(:page_subtitle_detail), selected: 'selected')
  end

  def nav_public_select_current_and_indexes_optgroup_indexes(arlocal_settings)
    nav_public_indexes(arlocal_settings).map { |o| nav_public_option_tag(o, selectable: false) }.join("\n").html_safe
  end

  def nav_public_select_indexes_only(arlocal_settings)
    content_tag(:select, nav_public_select_indexes_only_indexes(arlocal_settings), class: nav_public_select_classes).html_safe
  end

  def nav_public_select_indexes_only_indexes(arlocal_settings)
    nav_public_indexes(arlocal_settings).map { |o| nav_public_option_tag(o, selectable: true) }.join("\n").html_safe
  end


  private

  def nav_public_indexes(arlocal_settings)
    [
      nav_public_index_albums(arlocal_settings),
      nav_public_index_events(arlocal_settings),
      nav_public_index_info(arlocal_settings),
      nav_public_index_pictures(arlocal_settings),
      nav_public_index_videos(arlocal_settings)
    ].reject { |a| a == nil }
  end

  def nav_public_index_albums(arlocal_settings)
    if arlocal_settings.public_nav_can_include_albums
      { label: 'Albums', controller: 'public/albums', path: public_albums_path }
    end
  end

  def nav_public_index_events(arlocal_settings)
    if arlocal_settings.public_nav_can_include_events
      { label: 'Events', controller: 'public/events', path: public_events_path }
    end
  end

  def nav_public_index_info(arlocal_settings)
    if arlocal_settings.public_nav_can_include_info
      { label: 'Info', controller: 'public/infopages', path: public_infopage_first_path }
    end
  end

  def nav_public_index_pictures(arlocal_settings)
    if arlocal_settings.public_nav_can_include_pictures
      { label: 'Pictures', controller: 'public/pictures', path: public_pictures_path }
    end
  end

  def nav_public_index_videos(arlocal_settings)
    if arlocal_settings.public_nav_can_include_videos
      { label: 'Videos', controller: 'public/videos', path: public_videos_path }
    end
  end

end
