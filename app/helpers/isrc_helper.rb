module IsrcHelper


  def isrc_admin_button_to_edit(filter: nil)
    if filter
      button_admin_to_edit admin_isrc_edit_path({filter: filter})
    else
      button_admin_to_edit admin_isrc_edit_path
    end
  end


  def isrc_admin_button_to_done_editing(filter: nil)
    if filter
      button_admin_to_done_editing admin_isrc_index_path({filter: filter})
    else
      button_admin_to_done_editing admin_isrc_index_path
    end
  end


  def isrc_admin_button_to_index
    button_admin_to_index admin_isrc_index_path
  end


  def isrc_admin_filter_select(form, params)
    selected = params[:filter] ? SorterIndexAdminIsrc.find_id_from_param(params[:filter]) : form.object.admin_index_isrc_sorter_id
    form.select(
      :admin_index_isrc_sorter_id,
      SorterIndexAdminIsrc.options_for_select(:url),
      { include_blank: false, selected: selected },
      { class: [:arl_active_refine_selection, :arl_button_select, :arl_isrc_index_filter] }
    )
  end


  def isrc_admin_header_nav_buttons
    [ isrc_admin_button_to_index
    ].join("\n").html_safe
  end


end
