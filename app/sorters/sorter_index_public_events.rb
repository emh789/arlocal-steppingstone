class SorterIndexPublicEvents


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    # {
    #   id: 'all',
    #   description: 'all events',
    #   method: Proc.new { |events| events.sort_by{ |e| e.datetime_utc } }
    # },
    # {
    #   id: 'future',
    #   description: 'future events',
    #   method: Proc.new { |events| events.only_future.sort_by{ |e| e.datetime_utc } }
    # },
    # {
    #   id: 'past',
    #   description: 'past events',
    #   method: Proc.new { |events| events.only_past.sort_by{ |e| e.datetime_utc }.reverse }
    # },
    {
      id: 'upcoming',
      description: 'upcoming events',
      method: Proc.new { |events| events.upcoming.sort_by{ |e| e.datetime_utc }.reverse }
    },
    {
      id: 'with_audio',
      description: 'past events with audio',
      method: Proc.new { |events| events.with_audio.sort_by{ |e| e.datetime_utc }.reverse }
    }
  ]


  attr_reader :id, :description


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
      public_events_path({filter: @id})
    else
      public_events_path
    end
  end


end
