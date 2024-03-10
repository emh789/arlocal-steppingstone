module WelcomeHelper


  def welcome_admin_header_nav_buttons
    [ welcome_button_to_index
    ].join("\n").html_safe
  end


  def welcome_button_to_index
    button_admin_to_index admin_welcome_path
  end


  def welcome_markup_admin_nav_button(category: nil, current_pane: nil)
      button_admin_to_edit_pane(
        current_pane: current_pane,
        target_link: admin_welcome_markup_types_path(pane: category),
        target_pane: category
      )
  end

end
