class SorterIndexAdminEvents


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      # id: 0,
      id: 'datetime_asc',
      description: 'by start time (ascending)',
      symbol: :datetime_asc
    },
    {
      # id: 1,
      id: 'datetime_desc',
      description: 'by start time (descending)',
      symbol: :datetime_desc
    },
    {
      # id: 2,
      id: 'title_asc',
      description: 'by title (ascending)',
      symbol: :title_asc
    },
    {
      # id: 3,
      id: 'title_desc',
      description: 'by title (descending)',
      symbol: :title_desc
    },
    {
      # id: 4,
      id: 'only_future',
      description: 'only future',
      symbol: :only_future
    },
    {
      # id: 5,
      id: 'only_past',
      description: 'only past',
      symbol: :only_past
    }
  ]


  attr_reader :id, :description, :symbol


  def initialize(sorter)
    if sorter
      @id = sorter[:id]
      @description = sorter[:description]
      @symbol = sorter[:symbol]
    end
  end



  public


  # def url
  #   case @symbol
  #   when :all
  #     admin_events_path({filter: 'all'})
  #   when :future
  #     admin_events_path({filter: 'future'})
  #   when :past
  #     admin_events_path({filter: 'past'})
  #   when :upcoming
  #     admin_events_path({filter: 'upcoming'})
  #   else
  #     admin_events_path
  #   end
  # end


  def url
    if @id
      admin_events_path({filter: @id})
    else
      admin_events_path
    end
  end      


end
