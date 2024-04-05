class SorterIndexAdminVideos


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      id: 'datetime_asc',
      description: 'by release date (old - new)',
    },
    {
      id: 'datetime_desc',
      description: 'by release date (new - old)',
    },
    {
      id: 'title_asc',
      description: 'by title (forward)',
    },
    {
      id: 'title_desc',
      description: 'by title (reverse)',
    }
  ]


  attr_reader :id, :description


  def initialize(sorter)
    if sorter
      @id = sorter[:id]
      @description = sorter[:description]
    end
  end



  public


  def url
    if @id
      admin_videos_path({filter: @id})
    else
      admin_videos_path
    end
  end


end
