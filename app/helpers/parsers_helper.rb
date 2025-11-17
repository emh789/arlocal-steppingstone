module ParsersHelper

  def parser_div(resource_text_props)
    parser_result(resource_text_props, wrap_with: :div)
  end

  def parser_inline(resource_text_props)
    sanitize parser_result(resource_text_props), tags: ['a', 'b', 'em', 'i', 'strong']
  end

  def parser_remove_markup(resource_text_props)
    strip_tags(parser_result(resource_text_props))
  end

  def parser_result(resource_text_props, html_class: nil, wrap_with: nil)
    parser_result = MarkupParser.parse_sanitize_class(resource_text_props)
    case wrap_with
    when :div
      content_tag(wrap_with, parser_result[:sanitized_text], class: parser_result[:html_class])
    when nil
      parser_result[:sanitized_text]
    end
  end

  def parser_vendor_links(markdown)
    fragment = CommonMarker.render_html(markdown)
    fragment_tree = Nokogiri::HTML5.fragment(fragment)
    fragment_tree.css('ul').each { |node| node['class'] = 'arl_albums_show_vendor_links' }
    fragment_tree.css('li').each { |node| node['class'] = 'arl_albums_show_vendor_link' }
    fragment_tree.to_html.html_safe
  end

end
