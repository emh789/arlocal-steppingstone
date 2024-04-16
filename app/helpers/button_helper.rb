module ButtonHelper


  def button_admin_to_done_editing(path = nil)
    content_tag(:a, icon_done_editing, class: admin_nav_button_html_classes, href: path)
  end


  def button_admin_to_edit(path = nil)
    content_tag(:a, icon_edit, class: admin_nav_button_html_classes, href: path)
  end


  def button_admin_to_edit_pane(current_pane: nil, target_link: nil, target_pane: nil)
    html_class = [:arl_active_link_container]
    if current_pane == target_pane
      html_class << [:arl_admin_resource_edit_nav_item_current, :color_highlight_bg, :color_border]
    elsif current_pane != target_pane
      html_class << [:arl_admin_resource_edit_nav_item, :color_bg1, :color_border]
    end
    tag_anchor = tag.a(target_pane.to_s, class: :arl_admin_resource_edit_nav_item_link, href: target_link)
    tag.div tag_anchor, class: html_class, data: {tab: target_pane, url: target_link}
  end


  def button_admin_to_index(path = nil)
    content_tag(:a, icon_index, class: admin_nav_button_html_classes, href: path)
  end


  def button_admin_to_new(path = nil)
    content_tag(:a, icon_new, class: admin_nav_button_html_classes, href: path)
  end


  def button_admin_to_new_import(path = nil)
    content_tag(:a, icon_new_import, class: :arl_admin_resource_joins_button, href: path)
  end


  def button_admin_to_new_join_by_keyword(path = nil)
    content_tag(:a, icon_new_join_by_keyword, class: :arl_admin_resource_joins_button, href: path)
  end


  def button_admin_to_new_join_single(path = nil)
    content_tag(:a, icon_new_join_single, class: :arl_admin_resource_joins_button, href: path)
  end


  def button_admin_to_new_upload(path = nil)
    content_tag(:a, icon_new_upload, class: :arl_admin_resource_joins_button, href: path)
  end


  def button_admin_to_next(path = nil)
    content_tag(:a, icon_next, class: admin_nav_button_html_classes, href: path)
  end


  def button_admin_to_previous(path = nil)
    content_tag(:a, icon_previous, class: admin_nav_button_html_classes, href: path)
  end


  def button_admin_to_public(path = nil)
    content_tag(:a, icon_public, class: admin_nav_button_html_classes, href: path, target: 'new' )
  end


  def button_admin_to_public_null
    content_tag(:a, icon_private, class: [admin_nav_button_html_classes, :arl_button_not_allowed])
  end


  def button_to_edit_profile(path)
    button_to icon_edit, path, class: :arl_button_admin_resource, method: :get, title: 'edit profile'
  end


  def button_to_next(path)
    link_to icon_next, path, class: resource_neighbor_nav_button_html_classes
  end


  def button_to_previous(path)
    link_to icon_previous, path, class: resource_neighbor_nav_button_html_classes
  end


end
