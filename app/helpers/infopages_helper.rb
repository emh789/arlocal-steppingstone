module InfopagesHelper


  def infopage_admin_button_to_done_editing(infopage)
    button_admin_to_done_editing admin_infopage_path(infopage.id_admin)
  end


  def infopage_admin_button_to_edit(infopage)
    button_admin_to_edit edit_admin_infopage_path(infopage.id_admin)
  end


  def infopage_admin_button_to_edit_next(infopage, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_infopage_path(infopage.id_admin, pane: current_pane)
    else
      target_link = edit_admin_infopage_path(infopage.id_admin)
    end
    button_admin_to_next(target_link)
  end


  def infopage_admin_button_to_edit_previous(infopage, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_infopage_path(infopage.id_admin, pane: current_pane)
    else
      target_link = edit_admin_infopage_path(infopage.id_admin)
    end
    button_admin_to_previous(target_link)
  end


  def infopage_admin_button_to_index
    button_admin_to_index admin_infopages_path
  end


  def infopage_admin_button_to_new
    button_admin_to_new new_admin_infopage_path
  end


  def infopage_admin_button_to_next(infopage)
    button_admin_to_next admin_infopage_path(infopage.id_admin)
  end


  def infopage_admin_button_to_public(infopage = nil)
    case infopage
    when Infopage
      if infopage.published
        button_admin_to_public public_infopage_path(infopage.id_public)
      else
        button_admin_to_public_null
      end
    when nil
      button_admin_to_public public_infopages_path
    end
  end


  def infopage_admin_button_to_previous(infopage)
    button_admin_to_previous admin_infopage_path(infopage.id_admin)
  end


  def infopage_admin_edit_nav_button(infopage: nil, category: nil, current_pane: nil)
    button_admin_to_edit_pane(
      current_pane: current_pane,
      target_link: edit_admin_infopage_path(infopage.id_admin, pane: category),
      target_pane: category
    )
  end


  def infopage_admin_header_nav_buttons
    [ infopage_admin_button_to_index,
      infopage_admin_button_to_new
    ].join("\n").html_safe
  end


  def infopage_admin_link_title(infopage)
    link_to infopage.title, admin_infopage_path(infopage.id_admin)
  end


  def infopage_article_admin_button_to_new_join_single(infopage)
    button_admin_to_new_join_single edit_admin_infopage_path(infopage.id_admin, pane: :article_join_single)
  end


  def infopage_link_admin_button_to_new_join_single(infopage)
    button_admin_to_new_join_single edit_admin_infopage_path(infopage.id_admin, pane: :link_join_single)
  end



  def infopage_picture_admin_button_to_new_import(infopage)
    button_admin_to_new_import edit_admin_infopage_path(infopage.id_admin, pane: :picture_import)
  end


  def infopage_picture_admin_button_to_new_join_by_keyword(infopage)
    button_admin_to_new_join_by_keyword edit_admin_infopage_path(infopage.id_admin, pane: :picture_join_by_keyword)
  end


  def infopage_picture_admin_button_to_new_join_single(infopage)
    button_admin_to_new_join_single edit_admin_infopage_path(infopage.id_admin, pane: :picture_join_single)
  end


  def infopage_picture_admin_button_to_new_upload(infopage)
    button_admin_to_new_upload edit_admin_infopage_path(infopage.id_admin, pane: :picture_upload)
  end


  def infopageable_admin_link_titleish(infopage_item)
    case infopage_item.type_of
    when 'Article'
      article_admin_link_title(infopage_item.infopageable)
    when 'Link'
      link_admin_link_name(infopage_item.infopageable)
    when 'Picture'
      picture_admin_link_title(infopage_item.infopageable)
    end
  end


end
