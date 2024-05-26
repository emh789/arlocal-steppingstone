module VisibilityHelper


  def visibilities
    [
      {
        description: 'public &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (url, association, index)',
        id: 'public',
      },
      {
        description: 'unindexed (url, association)',
        id: 'unindexed',
      },
      {
        description: 'unlisted &nbsp;&nbsp;&nbsp;&nbsp; (url)',
        id: 'unlisted',
      },
      {
        description: 'private',
        id: 'private',
      }
    ]
  end


  def visibility_id(id)
    visibilities.select { |v| v[:id] == id }[0][:id]
  end


  def visibility_icon(title)
    visibilities.select { |v| v[:id] == id }[0][:icon]
  end


  def visibility_options_for_select
    options = []
    visibilities.each do |vis|
      options << [vis[:description].html_safe, vis[:id]]
    end
    options
  end


end
