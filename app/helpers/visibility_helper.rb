module VisibilityHelper


  def visibilities
    [
      {
        description: "#{icon_published} public".html_safe,
        icon: icon_published,
        id: 'public',
      },
      {
        description: "#{icon_published} unlisted".html_safe,
        icon: icon_published,
        id: 'unlisted',
      },
      {
        description: "#{icon_private} private".html_safe,
        icon: icon_private,
        id: 'private',
      }
    ]
  end


  def visibility_description(id)
    visibilities.select { |v| v[:id] == id }[0][:description]
  end


  def visibility_icon(title)
    visibilities.select { |v| v[:id] == id }[0][:icon]
  end


  def visibility_options_for_select
    options = []
    visibilities.each do |vis|
      options << [vis[:description], vis[:id]]
    end
    options
  end


end
