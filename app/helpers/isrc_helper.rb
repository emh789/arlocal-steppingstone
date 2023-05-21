module IsrcHelper


  def isrc_admin_button_to_edit
    button_admin_to_edit admin_isrc_edit_path
  end


  def isrc_admin_button_to_done_editing
    button_admin_to_done_editing admin_isrc_index_path
  end


  def isrc_admin_button_to_index
    button_admin_to_index admin_isrc_index_path
  end


  def isrc_admin_header_nav_buttons
    [ isrc_admin_button_to_index
    ].join("\n").html_safe
  end


end
