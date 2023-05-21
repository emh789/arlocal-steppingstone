module WelcomeHelper


  def welcome_admin_header_nav_buttons
    [ welcome_button_to_index
    ].join("\n").html_safe
  end


  def welcome_button_to_index
    button_admin_to_index admin_welcome_path
  end


end
