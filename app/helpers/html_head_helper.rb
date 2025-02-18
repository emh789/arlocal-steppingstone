module HtmlHeadHelper

  def html_head_favicon_preferred_url(arlocal_settings)
    case arlocal_settings.icon_source_type
    when 'imported'
      source_imported_url(arlocal_settings.icon_filename)
    when 'uploaded'
      url_for(arlocal_settings.icon_image)
    end
  end

  def html_head_meta_charset_tag
    '<meta charset="utf-8">'.html_safe
  end

  # NYI
  # def html_head_meta_description(text)
  #   tag.meta(name: 'description', content: sanitize(text)).html_safe
  # end

  def html_head_meta_viewport_tags
    '<meta name="viewport" content="initial-scale=1.0" />'.html_safe
  end

  def html_head_title_public(artist_name)
    tag.title sanitize(html_head_title_public_parsed(artist_name))   #.html_safe?
  end

  def html_head_title_public_parsed(artist_name)
    subtitle = content_for(:page_subtitle)
    detail = content_for(:page_subtitle_detail)
    if !subtitle && !detail && !artist_name
      "A&R.local"
    elsif !subtitle && !detail && artist_name
      "#{artist_name}"
    elsif subtitle && !detail && artist_name
      "#{subtitle} | #{artist_name}"
    elsif !subtitle && detail && artist_name
      "#{detail} | #{artist_name}"
    elsif subtitle && detail && artist_name
      "#{subtitle}: #{detail} | #{artist_name}"
    end
  end

  def html_head_title_admin(html_head_title_subtitle)
    title_string = "#{html_head_title_subtitle} | A&R.local admin"
    result = tag.title(sanitize(title_string)).html_safe
    result.html_safe
  end

  def html_head_title_neutral(html_head_title_subtitle)
    title_string = "#{html_head_title_subtitle} | A&R.local"
    result = tag.title(sanitize(title_string)).html_safe
    result.html_safe
  end

  def html_head_subtitle_set(subtitle)
    content_for :html_head_title_subtitle, subtitle
  end

end
