module IconHelper

  def icon_destroy
    '✗'.html_safe
  end

  def icon_done_editing
    tag.span class: [:arl_fa_icon, :fa_done_editing]
  end

  def icon_edit
    tag.span class: [:arl_fa_icon, :fa_edit]
  end

  def icon_index
    tag.span class: [:arl_fa_icon, :fa_index]
  end

  def icon_new
    tag.span class: [:arl_fa_icon, :fa_new]
  end

  def icon_new_import
    tag.span class: [:arl_fa_icon, :fa_import]
  end

  def icon_new_join_by_keyword
    tag.span class: [:arl_fa_icon, :fa_join_by_keyword]
  end

  def icon_new_join
    tag.span class: [:arl_fa_icon, :fa_join]
  end

  def icon_new_join_single
    tag.span class: [:arl_fa_icon, :fa_join_single]
  end

  def icon_new_upload
    tag.span class: [:arl_fa_icon, :fa_upload]
  end

  def icon_next
    tag.span class: [:arl_fa_icon, :fa_next]
  end

  # The element for this is an Input rather than a stylized anchor>, so it cannot take a <span> element for font-awesome
  # icons; it would require the webfont. See also `stylesheets/.../2_buttons .arl_button_form_aux_submit`
  def icon_pin
    '📌'
  end

  def icon_previous
    tag.span class: [:arl_fa_icon, :fa_previous]
  end

  def icon_public
    tag.span class: [:arl_fa_icon, :fa_public]
  end

  def icon_published
    icon_public
  end

  def icon_private
    tag.span class: [:arl_fa_icon, :fa_private]
  end

  def icon_question
    '?'
  end

  def icon_remove
    '✗'.html_safe
  end

  def icon_share
    tag.span class: [:arl_fa_icon, :fa_share]
  end

  def icon_show
    '☛'.html_safe
  end

  def icon_show_more_pictures
    '⇒'.html_safe
  end

  def icon_visibility_index
    tag.span class: [:arl_fa_icon_mini, :fa_index]
  end

  def icon_visibility_join
    tag.span class: [:arl_fa_icon_mini, :fa_join]
  end

  def icon_visibility_private
    tag.span class: [:arl_fa_icon_mini, :fa_private]
  end

  def icon_visibility_share
    tag.span class: [:arl_fa_icon_mini, :fa_share]
  end


end
