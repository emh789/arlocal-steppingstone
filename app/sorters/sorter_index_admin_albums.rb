class SorterIndexAdminAlbums


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      id: 'datetime_asc',
      description: 'by release date (old - new)',
      method: Proc.new { |albums| albums.sort_by{ |a| a.date_released } }
    },
    {
      id: 'datetime_desc',
      description: 'by release date (new - old)',
      method: Proc.new { |albums| albums.sort_by{ |a| a.date_released }.reverse }
    },
    {
      id: 'title_asc',
      description: 'by title (forward)',
      method: Proc.new { |albums| albums.sort_by{ |a| a.title.downcase } }
    },
    {
      id: 'title_desc',
      description: 'by title (reverse)',
      method: Proc.new { |albums| albums.sort_by{ |a| a.title.downcase }.reverse }
    }
  ]


  attr_reader :id, :description, :method


  def initialize(sorter)
    if sorter
      @id = sorter[:id]
      @description = sorter[:description]
      @method = sorter[:method]
    end
  end



  public


  def sort(collection)
    @method.call collection
  end


  def url
    if @id
      admin_albums_path({filter: @id})
    else
      admin_albums_path
    end
  end


end
