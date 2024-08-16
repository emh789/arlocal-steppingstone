module VisibilityHelper

  VISIBILITIES = [
    {
      abbreviation: 'admin',
      description: 'administrators only',
      id: 'admin_only',
      order: 0,
    },
    {
      abbreviation: 'public by url',
      description: 'public – url',
      id: 'public_showable',
      order: 1,
    },
    {
      abbreviation: 'public thru join',
      description: 'public – url, join',
      id: 'public_joinable',
      order: 2,
    },
    {
      abbreviation: 'public thru index',
      description: 'public – url, join, index',
      id: 'public_indexable',
      order: 3,
    }
  ]

  def visibility_abbreviation(id)
    VISIBILITIES.select { |v| v[:id] == id }[0][:abbreviation]
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
