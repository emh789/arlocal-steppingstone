module ArticlesHelper


  def article_admin_edit_nav_button(article: nil, category: nil, current_pane: nil)
    button_admin_to_edit_pane(
      current_pane: current_pane,
      target_link: edit_admin_article_path(article.id, pane: category),
      target_pane: category
    )
  end


  def article_admin_button_to_done_editing(article)
    button_admin_to_done_editing admin_article_path(article.id_admin)
  end


  def article_admin_button_to_edit(article)
    button_admin_to_edit edit_admin_article_path(article.id_admin)
  end


  def article_admin_button_to_edit_next(article, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_article_path(article.id_admin, pane: current_pane)
    else
      target_link = edit_admin_article_path(article.id_admin)
    end
    button_admin_to_next(target_link)
  end


  def article_admin_button_to_edit_previous(article, arlocal_settings: nil, current_pane: nil)
    if routing_will_retain_edit_pane(arlocal_settings, current_pane)
      target_link = edit_admin_article_path(article.id_admin, pane: current_pane)
    else
      target_link = edit_admin_article_path(article.id_admin)
    end
    button_admin_to_previous(target_link)
  end


  def article_admin_button_to_index
    button_admin_to_index admin_articles_path
  end


  def article_admin_button_to_new
    button_admin_to_new new_admin_article_path
  end


  def article_admin_button_to_next(article)
    button_admin_to_next admin_article_path(article.id_admin)
  end


  def article_admin_button_to_previous(article)
    button_admin_to_previous admin_article_path(article.id_admin)
  end


  def article_admin_header_nav_buttons
    [ article_admin_button_to_index,
      article_admin_button_to_new
    ].join("\n").html_safe
  end


  def article_admin_link_title(article)
    link_to article.title_for_display, admin_article_path(article.id_admin)
  end


end
