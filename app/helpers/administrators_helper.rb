module AdministratorsHelper


  def administrator_registration_edit_nav_button(category: nil, current_pane: nil)
    button_admin_to_edit_pane(
      current_pane: current_pane,
      target_link: edit_administrator_registration_path(pane: category),
      target_pane: category
    )
  end


  def administrator_registrations_header_nav_buttons
    [ administrator_registrations_button_to_index
    ].join("\n").html_safe
  end


  def administrator_registrations_button_to_index
    button_admin_to_index admin_administrators_path
  end


end
