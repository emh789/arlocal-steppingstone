module VisibilityHelper


  def visibilities
    [
      {
        id: 0,
        icon: icon_private,
        title: 'private',
        description: "#{icon_private} Private".html_safe
      },
      {
        id: 1,
        icon: icon_published,
        title: 'unlisted',
        description: "#{icon_published} Unlisted"
      },
      {
        id: 2,
        icon: icon_published,
        title: 'public',
        description: "#{icon_published} Public".html_safe
      }
    ]
  end


  def visibility_description(title)
    visibilities.select { |v| v[:title] == title }[0][:description]
  end


  def visibility_icon(title)
    visibilities.select { |v| v[:title] == title }[0][:icon]
  end


  def visibility_options_for_select
    options = []
    visibilities.sort_by { |v| v[:id] }.reverse.each do |vis|
      options << [vis[:description], vis[:title]]
    end
    options
  end


end
