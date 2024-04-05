class SorterIndexPublicVideos


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
    },
    {
      id: 'keyword_title_asc',
      description: 'by keyword, then title (forward)',
    },
    {
      id: 'keyword_datetime_desc',
      description: 'by keyword, then datetime (new - old)',
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
      public_videos_path({filter: @id})
    else
      public_videos_path
    end
  end


end
