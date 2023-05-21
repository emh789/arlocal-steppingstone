module RoutingHelper


  def routing_will_retain_edit_pane(arlocal_settings, pane)
    if (arlocal_settings) && (arlocal_settings.admin_forms_retain_pane_for_neighbors == true) && (pane)
      true
    else
      false
    end
  end


end
