module VisibilityHelper

  VISIBILITIES = [
    {
      description: 'administrators only',
      id: 'admin_only',
      order: 0,
    },
    {
      description: 'public – url',
      id: 'public_showable',
      order: 1,
    },
    {
      description: 'public – url, join',
      id: 'public_joinable',
      order: 2,
    },
    {
      description: 'public – url, join, index',
      id: 'public_indexable',
      order: 3,
    }
  ]

  def visibility_abbreviation(id)
    case id
    when 'admin_only'
      icon_visibility_private.html_safe
    when 'public_showable'
      icon_visibility_share.html_safe
    when 'public_joinable'
      [ icon_visibility_share, icon_visibility_join ].join.html_safe
    when 'public_indexable'
      [ icon_visibility_share, icon_visibility_join, icon_visibility_index ].join.html_safe
    end
  end

  def visibility_description(id)
    VISIBILITIES.select { |v| v[:id] == id }[0][:description]
  end

  def visibility_id(id)
    VISIBILITIES.select { |v| v[:id] == id }[0][:id]
  end

  def visibility_icon(title)
    VISIBILITIES.select { |v| v[:id] == id }[0][:icon]
  end

  def visibility_options_for_select
    options = []
    VISIBILITIES.each do |vis|
      options << [vis[:description].html_safe, vis[:id]]
    end
    options
  end

end
