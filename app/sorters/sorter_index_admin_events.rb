class SorterIndexAdminEvents


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      id: 'datetime_asc',
      description: 'by start time (ascending)',
    },
    {
      id: 'datetime_desc',
      description: 'by start time (descending)',
    },
    {
      id: 'title_asc',
      description: 'by title (ascending)',
    },
    {
      id: 'title_desc',
      description: 'by title (descending)',
    },
    {
      id: 'only_future',
      description: 'only future',
    },
    {
      id: 'only_past',
      description: 'only past',
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
      admin_events_path({filter: @id})
    else
      admin_events_path
    end
  end


end
