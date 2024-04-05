class SorterIndexPublicEvents


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    # {
    #   id: 'all',
    #   description: 'all events',
    # },
    # {
    #   id: 'future',
    #   description: 'future events',
    # },
    # {
    #   id: 'past',
    #   description: 'past events',
    # },
    {
      id: 'upcoming',
      description: 'upcoming events',
    },
    {
      id: 'with_audio',
      description: 'past events with audio',
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
      public_events_path({filter: @id})
    else
      public_events_path
    end
  end


end
