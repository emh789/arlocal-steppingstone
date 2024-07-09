module VisibilityHelper


  def old_visibilities
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


  def visibilities
    [
      {
        abbreviation: 'admin',
        description: 'administrators only',
        id: 'admin_only',
        order: 0,
      },
      {
        abbreviation: 'public: U',
        description: 'public – url',
        id: 'public_showable',
        order: 1,
      },
      {
        abbreviation: 'public: U J',
        description: 'public – url, join',
        id: 'public_joinable',
        order: 2,
      },
      {
        abbreviation: 'public: U J I',
        description: 'public – url, join, index',
        id: 'public_indexable',
        order: 3,
      }
    ]
  end


  def visibility_abbreviation(id)
    visibilities.select { |v| v[:id] == id }[0][:abbreviation]
  end

  def visibility_description(id)
    visibilities.select { |v| v[:id] == id }[0][:description]
  end


  def visibility_id(id)
    visibilities.select { |v| v[:id] == id }[0][:id]
  end


  def visibility_icon(title)
    visibilities.select { |v| v[:id] == id }[0][:icon]
  end


  # def visibility_options_for_select
  #   options = []
  #   visibilities.sort_by!{ |v| v.order }.reverse.each do |vis|
  #     options << [vis[:description].html_safe, vis[:id]]
  #   end
  #   options
  # end
  #

  def visibility_options_for_select
    options = []
    visibilities.each do |vis|
      options << [vis[:description].html_safe, vis[:id]]
    end
    options
  end


end
