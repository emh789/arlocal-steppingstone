module EventsHelper


  def event_admin_button_to_done_editing(event)
    button_admin_to_done_editing admin_event_path(@event.id_admin)
  end


  def event_admin_button_to_edit(event)
    button_admin_to_edit edit_admin_event_path(event.id_admin)
  end


  def event_admin_button_to_edit_next(event, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_event_path(event.id_admin, pane: current_pane)
    else
      target_link = edit_admin_event_path(event.id_admin)
    end
    button_admin_to_next(target_link)
  end


  def event_admin_button_to_edit_previous(event, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_event_path(event.id_admin, pane: current_pane)
    else
      target_link = edit_admin_event_path(event.id_admin)
    end
    button_admin_to_previous(target_link)
  end


  def event_admin_button_to_index
    button_admin_to_index admin_events_path
  end


  def event_admin_button_to_new
    button_admin_to_new new_admin_event_path
  end


  def event_admin_button_to_next(event)
    button_admin_to_next admin_event_path(event.id_admin)
  end


  def event_admin_button_to_public(event = nil)
    case event
    when Event
      if event.is_published?
        button_admin_to_public public_event_path(event.id_public)
      else
        button_admin_to_public_null
      end
    when nil
      button_admin_to_public public_events_path
    end
  end


  def event_admin_button_to_previous(event)
    button_admin_to_previous admin_event_path(event.id_admin)
  end


  def event_admin_edit_nav_button(event: nil, category: nil, current_pane: nil)
    button_admin_to_edit_pane(
      current_pane: current_pane,
      target_link: edit_admin_event_path(event.id_admin, pane: category),
      target_pane: category
    )
  end


  def event_admin_filter_select(form, params)
    selected = params[:filter] ? (params[:filter]) : form.object.admin_index_events_sort_method
    form.select(
      :admin_index_events_sort_method,
      SorterIndexAdminEvents.options_for_select(:url),
      { include_blank: false, selected: selected },
      { class: [:arl_active_refine_selection, :arl_button_select, :arl_audio_index_filter] }
    )
  end


  def event_admin_header_nav_buttons
    [ event_admin_button_to_index,
      event_admin_button_to_new
    ].join("\n").html_safe
  end


  def event_admin_link_date_and_venue(event)
    link_to event.date_and_venue, admin_event_path(event.id_admin)
  end


  def event_admin_link_datetime(event)
    link_to event.datetime_friendly, admin_event_path(event.id_admin)
  end


  def event_audio_admin_button_to_new_import(event)
    button_admin_to_new_import edit_admin_event_path(event.id_admin, pane: :audio_import)
  end


  def event_audio_admin_button_to_new_join_by_keyword(event)
    button_admin_to_new_join_by_keyword edit_admin_event_path(event.id_admin, pane: :audio_join_by_keyword)
  end


  def event_audio_admin_button_to_new_join_single(event)
    button_admin_to_new_join_single edit_admin_event_path(event.id_admin, pane: :audio_join_single)
  end


  def event_audio_admin_button_to_new_upload(event)
    button_admin_to_new_upload edit_admin_event_path(event.id_admin, pane: :audio_upload)
  end


  def event_keyword_admin_button_to_new_join_single(event)
    button_admin_to_new_join_single edit_admin_event_path(event.id_admin, pane: :keyword_join_single)
  end


  def event_linkable_city(event)
    if event.does_have_map_url
      event_linked_city(event)
    else
      event_linkless_city(event)
    end
  end


  def event_linked_city(event)
    link_to event.city, event.map_url, class: :arl_link_url, target: '_blank'
  end


  def event_linkless_city(event)
    event.city
  end


  def event_linkable_venue(event)
    if event.does_have_venue_url
      event_linked_venue(event)
    else
      event_linkless_venue(event)
    end
  end


  def event_linked_venue(event)
    link_to event.venue, event.venue_url, class: :arl_link_url, target: '_blank'
  end


  def event_linkless_venue(event)
    event.venue
  end


  def event_picture_admin_button_to_new_import(event)
    button_admin_to_new_import edit_admin_event_path(event.id_admin, pane: :picture_import)
  end


  def event_picture_admin_button_to_new_join_by_keyword(event)
    button_admin_to_new_join_by_keyword edit_admin_event_path(event.id_admin, pane: :picture_join_by_keyword)
  end


  def event_picture_admin_button_to_new_join_single(event)
    button_admin_to_new_join_single edit_admin_event_path(event.id_admin, pane: :picture_join_single)
  end


  def event_picture_admin_button_to_new_upload(event)
    button_admin_to_new_upload edit_admin_event_path(event.id_admin, pane: :picture_upload)
  end


  def event_public_filter_select(arlocal_settings, params)
    selected = params[:filter] ? (params[:filter]) : arlocal_settings.public_index_events_sort_method
    select(
      :events_index,
      :filter,
      SorterIndexPublicEvents.options_for_select(:url),
      { include_blank: false, selected: selected },
      { class: [:arl_active_refine_selection, :arl_button_select, :arl_events_index_select, :color_bg_heading] }
    )
  end


  def event_script_jPlayer_playlist(event)
    playlist_json = Array.new
    event.event_audio.each do |ea|
      playlist_json << js_fragment_jp_audio_ordered(ea)
    end
    js = js_function_jp_playlist_onready(playlist_json)
    app_script_element_for(js)
  end


  #  NYI
  #  def event_video_admin_button_to_new_import(event)
  #    button_admin_to_new_import edit_admin_event_path(event.id_admin, pane: :video_import)
  #  end


  def event_video_admin_button_to_new_join_by_keyword(event)
    button_admin_to_new_join_by_keyword edit_admin_event_path(event.id_admin, pane: :video_join_by_keyword)
  end


  def event_video_admin_button_to_new_join_single(event)
    button_admin_to_new_join_single edit_admin_event_path(event.id_admin, pane: :video_join_single)
  end


  #  NYI
  #  def event_video_admin_button_to_new_upload(event)
  #    button_admin_to_new_upload edit_admin_event_path(event.id_admin, pane: :video_upload)
  #  end



end
