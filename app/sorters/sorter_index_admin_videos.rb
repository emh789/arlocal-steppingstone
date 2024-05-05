class SorterIndexAdminVideos


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      id: 'datetime_asc',
      description: 'by date released (old - new)',
      method: Proc.new { |videos| videos.sort_by{ |v| v.date_released_sortable } }
    },
    {
      id: 'datetime_desc',
      description: 'by date released (new - old)',
      method: Proc.new { |videos| videos.sort_by{ |v| v.date_released_sortable }.reverse }
    },
    {
      id: 'title_asc',
      description: 'by title (forward)',
      method: Proc.new { |videos| videos.sort_by{ |v| v.title.downcase } }
    },
    {
      id: 'title_desc',
      description: 'by title (reverse)',
      method: Proc.new { |videos| videos.sort_by{ |v| v.title.downcase }.reverse }
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
      admin_videos_path({filter: @id})
    else
      admin_videos_path
    end
  end


end
