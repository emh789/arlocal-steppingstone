module ResourcesHelper


  def resource_coverpicture_tag(resource, html_class: nil)
    if resource.does_have_coverpicture
      picture_preferred_tag(resource.coverpicture_picture, html_class: html_class)
    else
      image_tag('', class: html_class)
    end
  end


  def resource_joined_albums_count_label(resource)
    "Albums: #{resource.albums_count.to_i}"
  end


  def resource_joined_albums_count_statement(resource, punctuated: false)
    count = resource.albums_count.to_i
    result = pluralize count, 'album'
    if punctuated && (count > 0)
      result = result.concat(':')
    end
    result
  end


  def resource_joined_articles_count_label(resource)
    "Articles: #{resource.articles_count.to_i}"
  end


  def resource_joined_articles_count_statement(resource, punctuated: false)
    count = resource.articles_count.to_i
    result = pluralize count, 'article'
    if punctuated && (count > 0)
      result = result.concat(':')
    end
    result
  end


  def resource_joined_audio_count_label(resource)
    "Audio: #{resource.audio_count.to_i}"
  end


  def resource_joined_audio_count_statement(resource, punctuated: false)
    count = resource.audio_count.to_i
    result = pluralize count, 'audio'
    if punctuated && (count > 0)
      result = result.concat(':')
    end
    result
  end


  def resource_joined_events_count_label(resource)
    "Events: #{resource.events_count.to_i}"
  end


  def resource_joined_events_count_statement(resource, punctuated: false)
    count = resource.events_count.to_i
    result = pluralize count, 'event'
    if punctuated && (count > 0)
      result = result.concat(':')
    end
    result
  end


  def resource_joined_keywords_count_label(resource)
    "Keywords: #{resource.keywords_count.to_i}"
  end


  def resource_joined_keywords_count_statement(resource, punctuated: false)
    pluralize resource.keywords_count.to_i, 'keyword'
  end


  def resource_joined_infopages_count_label(resource)
    "Infopages: #{resource.infopages.length.to_i}"
  end


  def resource_joined_links_count_statement(resource, punctuated: false)
    count = resource.links_count.to_i
    result = pluralize count, 'link'
    if punctuated && (count > 0)
      result = result.concat(':')
    end
    result
  end


  def resource_joined_pictures_count_label(resource)
    "Pictures: #{resource.pictures_count.to_i}"
  end


  def resource_joined_pictures_count_statement(resource, punctuated: false)
    count = resource.pictures_count.to_i
    result = pluralize count, 'picture'
    if punctuated && (count > 0)
      result = result.concat(':')
    end
    result
  end


  def resource_joined_videos_count_label(resource)
    "Videos: #{resource.videos_count.to_i}"
  end


  def resource_joined_videos_count_statement(resource, punctuated: false)
    count = resource.videos_count.to_i
    result = pluralize count, 'video'
    if punctuated && (count > 0)
      result = result.concat(':')
    end
    result
  end


  def resource_neighbor_nav_button_html_classes
    [:neighbor_nav_button]
  end


  def resource_reference_admin_link(resource)
    case resource
    when Audio
      audio_reference_admin_link(resource)
    when Video
      video_reference_admin_link(resource)
    end
  end


  # generates functionality in resource#show to cycle through all resource_pictures by click/tap on image element
  def resource_script_picture_cycler(resource, view: :published)
    picture_filepaths = Array.new
    case view
    when :all
      picture_filepaths << resource.pictures_all_sorted.map { |picture| picture_preferred_url(picture) }
    when :published
      picture_filepaths << resource.pictures_published_sorted.map { |picture| picture_preferred_url(picture) }
    end
    filepath_string = picture_filepaths.flatten.map {|path| '"' + path + '"'}.join(',')
    app_script_element_for(js_function_album_picture_cycler(filepath_string))
  end


end
